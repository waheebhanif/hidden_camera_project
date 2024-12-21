import 'package:get/get.dart';
import 'package:hidden_camera_detector/app/controllers/auth_controller.dart';
import 'package:hidden_camera_detector/app/ui/pages/scanner/scanner_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<DetectorController>(() => DetectorController());
  }
}