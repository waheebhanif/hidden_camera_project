
import 'package:camera/camera.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool isCameraInitialized = false.obs;
  Rx<CameraController?> cameraController = Rx<CameraController?>(null);
  RxString currentStatus = "Ready to scan".obs;
  RxBool isAnyDetectorActive = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        cameraController.value = CameraController(
          cameras[0],
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await cameraController.value!.initialize();
        isCameraInitialized.value = true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize camera: $e');
    }
  }

  @override
  void onClose() {
    cameraController.value?.dispose();
    super.onClose();
  }
}
