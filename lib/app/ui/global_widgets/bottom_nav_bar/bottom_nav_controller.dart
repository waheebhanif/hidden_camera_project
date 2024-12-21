import 'package:hidden_camera_detector/app/ui/pages/home_page/home_page.dart';
import 'package:hidden_camera_detector/app/ui/pages/Account/account_screen.dart';
import 'package:hidden_camera_detector/app/ui/utils/app_exports.dart';

class BottomNavBarController extends GetxController {
  final RxInt _selectedIndex = 0.obs;

  int get selectedIndex => _selectedIndex.value;

  final List<Widget> _pages = [
    HomeScreen(),
    AccountScreen(),
  ];

  Widget get currentPage => _pages[selectedIndex];

  void navigateToPage(int index) {
    _selectedIndex.value = index; // Update index to switch tabs
  }
}
