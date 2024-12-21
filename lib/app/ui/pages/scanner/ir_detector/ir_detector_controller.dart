import 'package:hidden_camera_detector/app/ui/utils/app_exports.dart';

class IRDetectorController extends GetxController {
  Rx<CameraController?> cameraController = Rx<CameraController?>(null);
  RxBool isNightModeEnabled = false.obs;
  RxBool isIRFilterEnabled = false.obs;
  RxBool isAnalysisEnabled = false.obs;
  RxDouble sensitivity = 50.0.obs;
  RxString detectionStatus = 'Ready'.obs;
  RxDouble detectionProgress = 0.0.obs;

  List<CameraDescription> cameras = [];
  int currentCameraIndex = 0;
  bool isStreaming = false;

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        await _setupCamera(0);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize camera: $e');
    }
  }

  Future<void> _setupCamera(int index) async {
    // Stop any existing stream before disposing
    await _stopImageProcessing();
    
    if (cameraController.value != null) {
      await cameraController.value!.dispose();
    }

    cameraController.value = CameraController(
      cameras[index],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    try {
      await cameraController.value!.initialize();
      currentCameraIndex = index;
      // Only start processing if analysis is enabled
      if (isAnalysisEnabled.value) {
        await _startImageProcessing();
      }
    } catch (e) {
      Get.snackbar('Error', 'Camera initialization failed: $e');
    }
  }

  Future<void> _startImageProcessing() async {
    if (cameraController.value == null || isStreaming) return;

    try {
      isStreaming = true;
      await cameraController.value!.startImageStream((image) {
        if (isAnalysisEnabled.value) {
          _processImage(image);
        }
      });
    } catch (e) {
      isStreaming = false;
      Get.snackbar('Error', 'Failed to start image stream: $e');
    }
  }

  Future<void> _stopImageProcessing() async {
    if (cameraController.value == null || !isStreaming) return;

    try {
      await cameraController.value!.stopImageStream();
      isStreaming = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to stop image stream: $e');
    }
  }

  void _processImage(CameraImage image) {
    // Implement IR detection algorithm here
    // This is a simplified example
    int irPixels = 0;
    int totalPixels = image.width * image.height;

    // Simulate IR detection
    detectionProgress.value = irPixels / totalPixels;

    if (detectionProgress.value > sensitivity.value / 100) {
      detectionStatus.value = 'IR Source Detected!';
    } else {
      detectionStatus.value = 'Scanning...';
    }
  }

  Future<void> switchCamera() async {
    final newIndex = (currentCameraIndex + 1) % cameras.length;
    await _setupCamera(newIndex);
  }

  Future<void> toggleFlash() async {
    if (cameraController.value == null) return;

    try {
      final newMode = cameraController.value!.value.flashMode == FlashMode.torch
          ? FlashMode.off
          : FlashMode.torch;

      await cameraController.value!.setFlashMode(newMode);
    } catch (e) {
      Get.snackbar('Error', 'Failed to toggle flash: $e');
    }
  }

  void toggleNightMode() {
    isNightModeEnabled.value = !isNightModeEnabled.value;
    // Implement night mode image processing
  }

  void toggleIRFilter() {
    isIRFilterEnabled.value = !isIRFilterEnabled.value;
    // Implement IR filter processing
  }

  Future<void> toggleAnalysis() async {
    isAnalysisEnabled.value = !isAnalysisEnabled.value;
    if (isAnalysisEnabled.value) {
      await _startImageProcessing();
    } else {
      await _stopImageProcessing();
    }
  }

  void setSensitivity(double value) {
    sensitivity.value = value;
  }

  @override
  void onClose() {
    _stopImageProcessing();
    cameraController.value?.dispose();
    super.onClose();
  }
}