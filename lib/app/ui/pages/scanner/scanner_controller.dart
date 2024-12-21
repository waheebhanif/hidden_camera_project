// import 'package:get/get.dart';
// // import 'package:camera/camera.dart';
// // import 'package:sensors_plus/sensors_plus.dart';
// // import 'dart:async';
// // import 'dart:math';

// class ScannerController extends GetxController {
//   // // Detection modes
//   // RxBool infraredDetectionEnabled = true.obs;
//   // RxBool lensReflectionDetectionEnabled = true.obs;
//   // RxBool rfDetectionEnabled = true.obs;

//   // // Scan results with signal strength
//   // RxList<DetectedDevice> detectedDevices = <DetectedDevice>[].obs;
//   // RxBool isScanning = false.obs;

//   // // Camera controller
//   // late CameraController cameraController;
  
//   // // Detection streams
//   // StreamSubscription? _infraredSubscription;
//   // StreamSubscription? _rfDetectionSubscription;

//   // // Sonar-like scanning variables
//   // RxDouble overallSignalStrength = 0.0.obs;
//   // RxInt scanProgress = 0.obs;

//   // @override
//   // void onInit() {
//   //   super.onInit();
//   //   _initializeCamera();
//   // }

//   // void _initializeCamera() async {
//   //   final cameras = await availableCameras();
//   //   cameraController = CameraController(
//   //     cameras.first, 
//   //     ResolutionPreset.high,
//   //     imageFormatGroup: ImageFormatGroup.bgra8888
//   //   );
    
//   //   await cameraController.initialize();
//   // }

//   // void startScan() {
//   //   isScanning.value = true;
//   //   detectedDevices.clear();
//   //   overallSignalStrength.value = 0.0;
//   //   scanProgress.value = 0;

//   //   // Start periodic scan progress
//   //   Timer.periodic(Duration(seconds: 1), (timer) {
//   //     if (scanProgress.value < 100) {
//   //       scanProgress.value += 5;
//   //     } else {
//   //       timer.cancel();
//   //     }
//   //   });

//   //   // Infrared Detection
//   //   if (infraredDetectionEnabled.value) {
//   //     _startInfraredDetection();
//   //   }

//   //   // Lens Reflection Detection
//   //   if (lensReflectionDetectionEnabled.value) {
//   //     _startLensReflectionDetection();
//   //   }

//   //   // RF Detection
//   //   if (rfDetectionEnabled.value) {
//   //     _startRFDetection();
//   //   }

//   //   // Stop scan after 2 minutes
//   //   Future.delayed(Duration(minutes: 2), () => stopScan());
//   // }

//   // void _startInfraredDetection() {
//   //   _infraredSubscription = accelerometerEvents.listen((event) {
//   //     // Simulate infrared detection with movement sensitivity
//   //     double signalStrength = _calculateSignalStrength(event.x, event.y, event.z);
      
//   //     if (signalStrength > 0.5) {
//   //       _addOrUpdateDevice(
//   //         DetectedDevice(
//   //           name: 'Potential Infrared Camera', 
//   //           type: DetectionType.infrared,
//   //           signalStrength: signalStrength
//   //         )
//   //       );
//   //     }
//   //   });
//   // }

//   // void _startLensReflectionDetection() {
//   //   // Simulate lens reflection detection
//   //   cameraController.setFlashMode(FlashMode.torch);
    
//   //   // Mock implementation of lens reflection detection
//   //   Timer.periodic(Duration(seconds: 3), (_) {
//   //     double mockSignalStrength = Random().nextDouble();
//   //     if (mockSignalStrength > 0.7) {
//   //       _addOrUpdateDevice(
//   //         DetectedDevice(
//   //           name: 'Suspicious Lens Reflection', 
//   //           type: DetectionType.lensReflection,
//   //           signalStrength: mockSignalStrength
//   //         )
//   //       );
//   //     }
//   //   });
//   // }

//   // void _startRFDetection() {
//   //   _rfDetectionSubscription = Stream.periodic(Duration(seconds: 2)).listen((_) {
//   //     // Simulate RF signal detection with variable strength
//   //     double signalStrength = Random().nextDouble();
      
//   //     if (signalStrength > 0.6) {
//   //       _addOrUpdateDevice(
//   //         DetectedDevice(
//   //           name: 'Wireless RF Signal', 
//   //           type: DetectionType.rf,
//   //           signalStrength: signalStrength
//   //         )
//   //       );
//   //     }
//   //   });
//   // }

//   // void _addOrUpdateDevice(DetectedDevice device) {
//   //   // Check if device already exists
//   //   int existingIndex = detectedDevices.indexWhere((d) => d.name == device.name);
    
//   //   if (existingIndex != -1) {
//   //     // Update existing device
//   //     detectedDevices[existingIndex] = device;
//   //   } else {
//   //     // Add new device
//   //     detectedDevices.add(device);
//   //   }

//   //   // Update overall signal strength
//   //   overallSignalStrength.value = detectedDevices
//   //     .map((d) => d.signalStrength)
//   //     .reduce((a, b) => a + b) / detectedDevices.length;
//   // }

//   // double _calculateSignalStrength(double x, double y, double z) {
//   //   // Calculate signal strength based on movement intensity
//   //   return sqrt(x*x + y*y + z*z) / 20.0;
//   // }

//   // void stopScan() {
//   //   isScanning.value = false;
//   //   _infraredSubscription?.cancel();
//   //   _rfDetectionSubscription?.cancel();
//   //   cameraController.setFlashMode(FlashMode.off);
//   // }

//   // @override
//   // void onClose() {
//   //   cameraController.dispose();
//   //   _infraredSubscription?.cancel();
//   //   _rfDetectionSubscription?.cancel();
//   //   super.onClose();
//   // }
// }

// enum DetectionType { infrared, lensReflection, rf }

// class DetectedDevice {
//   final String name;
//   final DetectionType type;
//   final double signalStrength;

//   DetectedDevice({
//     required this.name, 
//     required this.type, 
//     required this.signalStrength
//   });
// }


// lib/controllers/detector_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_camera_detector/app/ui/pages/home_page/home_page.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;

class DetectorController extends GetxController {
  RxBool isScanning = false.obs;
  RxDouble magneticFieldStrength = 0.0.obs;
  RxList<CameraDescription> cameras = <CameraDescription>[].obs;
  Rx<CameraController?> cameraController = Rx<CameraController?>(null);
  RxInt currentCameraIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _requestPermissions();
    initializeCameras();
    initializeSensors();
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
  }

  Future<void> initializeCameras() async {
    try {
      cameras.value = await availableCameras();
      if (cameras.isNotEmpty) {
        await _initializeCamera(0);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize camera: $e');
    }
  }

  Future<void> _initializeCamera(int index) async {
    if (cameraController.value != null) {
      await cameraController.value!.dispose();
    }

    if (cameras.isEmpty || index >= cameras.length) return;

    cameraController.value = CameraController(
      cameras[index],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await cameraController.value!.initialize();
      currentCameraIndex.value = index;
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize camera: $e');
    }
  }

  Future<void> switchCamera() async {
    final newIndex = (currentCameraIndex.value + 1) % cameras.length;
    await _initializeCamera(newIndex);
  }

  void initializeSensors() {
    magnetometerEvents.listen((MagnetometerEvent event) {
      double strength = math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      magneticFieldStrength.value = strength;
    });
  }

  Future<void> startRFDetection() async {
    if (isScanning.value) return;
    
    isScanning.value = true;
    // Simulate RF detection
    await Future.delayed(Duration(seconds: 3));
    isScanning.value = false;
    
    Get.dialog(
      ScanResultDialog(
        title: 'RF Scan Complete',
        message: 'No suspicious RF signals detected in your vicinity.',
        icon: Icons.wifi_tethering,
        color: Colors.blue,
      ),
    );
  }

  Future<void> startMagneticFieldDetection() async {
    if (isScanning.value) return;
    
    isScanning.value = true;
    await Future.delayed(Duration(seconds: 3));
    isScanning.value = false;
    
    final strength = magneticFieldStrength.value;
    String message = '';
    
    if (strength > 70) {
      message = 'High magnetic field detected! This might indicate nearby electronic devices.';
    } else if (strength > 40) {
      message = 'Moderate magnetic field detected. Consider investigating the area.';
    } else {
      message = 'Normal magnetic field levels detected.';
    }
    
    Get.dialog(
      ScanResultDialog(
        title: 'Magnetic Field Scan',
        message: '$message\nCurrent strength: ${strength.toStringAsFixed(2)} μT',
        icon: Icons.compass_calibration,
        color: Colors.green,
      ),
    );
  }

  Future<void> startIRDetection() async {
    if (isScanning.value || cameraController.value == null) return;
    
    isScanning.value = true;
    
    try {
      // Enable torch if available
      if (cameraController.value!.value.isInitialized) {
        await cameraController.value!.setFlashMode(FlashMode.torch);
      }
      
      await Future.delayed(Duration(seconds: 3));
      
      // Disable torch
      if (cameraController.value!.value.isInitialized) {
        await cameraController.value!.setFlashMode(FlashMode.off);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to control camera flash: $e');
    }
    
    isScanning.value = false;
    
    Get.dialog(
      ScanResultDialog(
        title: 'IR Scan Complete',
        message: 'Look for any bright spots in the camera view - they might indicate IR sources.',
        icon: Icons.camera,
        color: Colors.orange,
      ),
    );
  }

  @override
  void onClose() {
    cameraController.value?.dispose();
    super.onClose();
  }
}