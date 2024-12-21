import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? leadingIconPath;
  final VoidCallback? onLeadingTap;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool centerTitle;
  final TextStyle? titleStyle;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.leadingIconPath,
    this.onLeadingTap,
    this.actions,
    this.backgroundColor,
    this.centerTitle = true,
    this.titleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: onLeadingTap ?? () => Get.back(),
        icon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
      ),
      title: Text(
        title,
        style: titleStyle ?? Theme.of(context).textTheme.headlineMedium,
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
