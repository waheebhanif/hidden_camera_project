import 'package:get/get.dart';
import 'package:hidden_camera_detector/app/ui/pages/scanner/scanner_controller.dart';

class ScannerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetectorController>(() => DetectorController());
  }
}