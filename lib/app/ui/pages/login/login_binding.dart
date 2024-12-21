import 'package:get/get.dart';
import 'package:hidden_camera_detector/app/controllers/auth_controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}