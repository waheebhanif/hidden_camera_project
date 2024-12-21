import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:hidden_camera_detector/app/ui/pages/scanner/ir_detector/ir_detector_screen.dart';
import 'package:sensors_plus/sensors_plus.dart';

class IRDetectorController extends GetxController {
  CameraController? cameraController;
  final RxDouble irStrength = 0.0.obs;
  final RxBool isScanning = false.obs;
  final RxList<IRReading> readings = <IRReading>[].obs;
  final RxBool hasCameraPermission = false.obs;
  final RxBool isInitialized = false.obs;
  final RxDouble phoneRotationX = 0.0.obs;
  final RxDouble phoneRotationY = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    initCamera();
    initSensors();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    try {
      await cameraController!.initialize();
      isInitialized.value = true;
      hasCameraPermission.value = true;
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void initSensors() {
    gyroscopeEvents.listen((GyroscopeEvent event) {
      phoneRotationX.value = event.x;
      phoneRotationY.value = event.y;
    });
  }

  void startScanning() async {
    if (!isInitialized.value) return;

    isScanning.value = true;
    await cameraController!.startImageStream((image) {
      if (!isScanning.value) return;
      _analyzeImageForIR(image);
    });
  }

  void stopScanning() {
    isScanning.value = false;
    cameraController?.stopImageStream();
  }

  void _analyzeImageForIR(CameraImage image) {
    try {
      // Analyze center portion of the image for IR light
      final int width = image.width;
      final int height = image.height;
      final bytes = image.planes[0].bytes;

      // Calculate average brightness in center region
      int totalBrightness = 0;
      int samplesCount = 0;

      // Analyze center region (middle 20% of the image)
      final startX = (width * 0.4).round();
      final endX = (width * 0.6).round();
      final startY = (height * 0.4).round();
      final endY = (height * 0.6).round();

      for (int y = startY; y < endY; y++) {
        for (int x = startX; x < endX; x++) {
          final pixel = bytes[y * width + x];
          totalBrightness += pixel;
          samplesCount++;
        }
      }

      final averageBrightness = totalBrightness / samplesCount;
      // Convert to 0-100 scale
      final normalizedStrength =
          ((averageBrightness - 50) / 155 * 100).clamp(0.0, 100.0);

      irStrength.value = normalizedStrength;
      if (normalizedStrength > 70) {
        // Changed threshold to 70
        readings.insert(
            0,
            IRReading(
              // Insert at beginning for newest first
              strength: normalizedStrength,
              timestamp: DateTime.now(),
              rotation: Vector2(phoneRotationX.value, phoneRotationY.value),
            ));

        // Keep only last 10 significant readings
        if (readings.length > 10) {
          readings.removeLast();
        }

        Get.snackbar(
          'High IR Detected',
          'Possible hidden camera nearby!',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('Error analyzing image: $e');
    }
  }
}

class IRReading {
  final double strength;
  final DateTime timestamp;
  final Vector2 rotation;

  IRReading({
    required this.strength,
    required this.timestamp,
    required this.rotation,
  });
}
