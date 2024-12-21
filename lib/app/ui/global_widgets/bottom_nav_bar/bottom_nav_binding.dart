import 'package:hidden_camera_detector/app/controllers/auth_controller.dart';
import 'package:hidden_camera_detector/app/ui/global_widgets/bottom_nav_bar/bottom_nav_controller.dart';
import 'package:hidden_camera_detector/app/ui/utils/app_exports.dart';

class BottomNavBarBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavBarController>(() => BottomNavBarController());
    Get.put<HomeController>(HomeController());
    Get.put<AuthController>(AuthController());
    // Get.put<AdminController>(AdminController());
    // Get.put<OrdersController>(OrdersController());
  }
}
