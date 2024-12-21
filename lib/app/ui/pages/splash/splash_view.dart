import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_camera_detector/app/ui/theme/colors.dart';
import 'package:hidden_camera_detector/app/ui/utils/assets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final AuthController _authController = Get.find();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    Future.delayed(Duration(seconds: 2), () {
      if (_authController.user.value != null) {
        // User is logged in, navigate to home
        Get.offNamed(AppRoutes.BOTTOM_NAVBAR);
      } else {
        // No user logged in, go to login
        Get.offNamed(AppRoutes.LOGIN);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.imageSpyCameraDetector,
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Hidden Camera Detector',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 20),
            LoadingAnimationWidget.beat(
              color: kRedColor,
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
