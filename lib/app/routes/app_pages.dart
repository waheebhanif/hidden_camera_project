import 'package:get/get.dart';
import 'package:hidden_camera_detector/app/bindings/home_binding.dart';
import 'package:hidden_camera_detector/app/ui/global_widgets/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:hidden_camera_detector/app/ui/global_widgets/bottom_nav_bar/bottom_nav_binding.dart';
import 'package:hidden_camera_detector/app/ui/pages/Account/personal_information_page.dart';
import 'package:hidden_camera_detector/app/ui/pages/home_page/home_page.dart';
import 'package:hidden_camera_detector/app/ui/pages/login/login_binding.dart';
import 'package:hidden_camera_detector/app/ui/pages/login/login_view.dart';
import 'package:hidden_camera_detector/app/ui/pages/Account/account_screen.dart';
import 'package:hidden_camera_detector/app/ui/pages/register/register_binding.dart';
import 'package:hidden_camera_detector/app/ui/pages/register/register_view.dart';
import 'package:hidden_camera_detector/app/ui/pages/splash/splash_binding.dart';
import 'package:hidden_camera_detector/app/ui/pages/splash/splash_view.dart';

import '../ui/pages/unknown_route_page/unknown_route_page.dart';
import 'app_routes.dart';

const _defaultTransition = Transition.rightToLeftWithFade;

class AppPages {
  static final unknownRoutePage = GetPage(
    name: AppRoutes.UNKNOWN,
    page: () => const UnknownRoutePage(),
    transition: _defaultTransition,
  );

  static final List<GetPage> pages = [
    unknownRoutePage,
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashView(),
      transition: _defaultTransition,
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginView(),
      transition: _defaultTransition,
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => RegisterView(),
      transition: _defaultTransition,
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.BOTTOM_NAVBAR,
      page: () => const BottomNavBar(),
      transition: _defaultTransition,
      binding: BottomNavBarBinding(),
    ),
    GetPage(
      name: AppRoutes.ACCOUNT,
      page: () => AccountScreen(),
      transition: _defaultTransition,
      // binding: ScannerBinding(),
    ),
    GetPage(
      name: AppRoutes.PERSONAL_INFORMATION,
      page: () => PersonalInformationPage(),
      transition: _defaultTransition,
      binding: LoginBinding(),
    ),
  ];
}
