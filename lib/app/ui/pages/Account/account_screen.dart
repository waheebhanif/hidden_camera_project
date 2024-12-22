import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_camera_detector/app/controllers/auth_controller.dart';
import 'package:hidden_camera_detector/app/routes/app_routes.dart';
import 'package:hidden_camera_detector/app/ui/global_widgets/custom_text_field.dart';
import 'package:hidden_camera_detector/app/ui/pages/Account/account_action_dialog.dart';
import 'package:hidden_camera_detector/app/ui/theme/colors.dart';
import 'package:hidden_camera_detector/app/ui/theme/size_config.dart';

class AccountScreen extends StatelessWidget {
  final AuthController _authController = Get.find();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Account',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: kDefaultIconLightColor.withOpacity(0.3),
            height: 1,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: getProportionateScreenHeight(32)),
                Text(
                  'Account Settings',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: const Color(0xFF5D5D5D),
                      ),
                ),
                SizedBox(height: getProportionateScreenHeight(16)),
                InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.PERSONAL_INFORMATION);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: kGray.withOpacity(0.15),
                          blurRadius: 22,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Personal Information',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: const Color(0xFF383838),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: kGray,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(48),
                ),
                Text(
                  'Legal',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: const Color(0xFF5D5D5D),
                      ),
                ),
                SizedBox(height: getProportionateScreenHeight(16)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: kGray.withOpacity(0.15),
                        blurRadius: 22,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.PRIVACY_POLICY);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Privacy policy',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: const Color(0xFF383838),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: kGray,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(24)),
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.TERMS_AND_CONDITIONS);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Terms and conditions',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: const Color(0xFF383838),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: kGray,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(48),
                ),
                Text(
                  'Account Actions',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: const Color(0xFF5D5D5D),
                      ),
                ),
                SizedBox(height: getProportionateScreenHeight(16)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: kGray.withOpacity(0.15),
                        blurRadius: 22,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          _showActionDialog(
                            context,
                            title:
                                'This action will permanently\ndelete your account and all data.',
                            iconAsset: Icon(
                              Icons.delete,
                              color: kRedColor,
                            ),
                            actionButtonText: 'Delete',
                            onAction: () async {
                              // Add delete account logic here
                              // In your UI
                              Navigator.of(context).pop();
                              _passwordDialog(context);
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delete Account',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: const Color(0xFF383838),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            Icon(
                              Icons.delete,
                              color: kRedColor,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(24)),
                      InkWell(
                        onTap: () {
                          _showActionDialog(
                            context,
                            title: 'Are you sure you want to\nlog out?',
                            iconAsset: Icon(
                              Icons.logout,
                              color: kRedColor,
                            ),
                            actionButtonText: 'Logout',
                            onAction: () {
                              // Add logout logic here

                              Navigator.of(context).pop();
                              _authController.logout();
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Logout',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: const Color(0xFF383838),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            Icon(
                              Icons.logout,
                              color: kRedColor,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(16)),
                      Text(
                        'v1.0.0',
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  color: const Color(0xFF5D5D5D),
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showActionDialog(
    BuildContext context, {
    required String title,
    required Icon iconAsset,
    required String actionButtonText,
    required VoidCallback onAction,
  }) {
    showDialog(
      context: context,
      builder: (context) => AccountActionDialog(
        title: title,
        iconAsset: iconAsset,
        actionButtonText: actionButtonText,
        onAction: onAction,
      ),
    );
  }

  void _passwordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: const Text('Enter your password'),
        content: CustomTextField(
          controller: passwordController,
          hintText: "Enter Password",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _authController.deleteAccount(passwordController.text);
              Navigator.of(context).pop();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
