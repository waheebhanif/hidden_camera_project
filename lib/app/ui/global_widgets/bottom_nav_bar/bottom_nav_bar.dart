import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_camera_detector/app/ui/global_widgets/bottom_nav_bar/bottom_nav_controller.dart';
import 'package:hidden_camera_detector/app/ui/theme/colors.dart';

// Binding for BottomNavBar

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavBarController>();

    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Obx(() =>
            controller.currentPage), // Dynamically display the selected page
        bottomNavigationBar: Obx(() => Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: kTransparent,
                items: [
                  _buildNavItem(
                    icon: Icons.radar,
                    label: 'Scanner',
                  ),
                  _buildNavItem(
                    icon: Icons.settings_accessibility_outlined,
                    label: 'Account',
                  ),
                  // _buildNavItem(
                  //   icon: Icons.shopping_cart,
                  //   label: 'Orders',
                  // ),
                ],
                currentIndex: controller.selectedIndex,
                onTap: controller.navigateToPage,
                selectedLabelStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: kPrimaryTextColor,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: Color(0xff999999),
                ),
              ),
            )),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    // required IconData activeIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      activeIcon: Icon(
        icon,
        color: kPrimaryButtonColor,
      ),
      label: label,
    );
  }
}
