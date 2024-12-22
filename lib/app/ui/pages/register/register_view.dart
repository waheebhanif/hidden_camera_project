import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_camera_detector/app/routes/app_routes.dart';
import 'package:hidden_camera_detector/app/ui/global_widgets/custom_text_field.dart';
import 'package:hidden_camera_detector/app/ui/theme/colors.dart';
import 'package:hidden_camera_detector/app/ui/theme/size_config.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../controllers/auth_controller.dart';

class RegisterView extends StatelessWidget {
  final AuthController _authController = Get.find();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: getProportionateScreenHeight(120)),
                Text('Register',
                    style: Theme.of(context).textTheme.displayMedium),
                SizedBox(height: 24),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                Obx(
                  () => _authController.isLoading.value
                      ? Center(
                          child: LoadingAnimationWidget.beat(
                            color: kPrimaryButtonColor,
                            size: 50,
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryButtonColor,
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: Text(
                            'Register',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () => Get.back(),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Already have an account? ',
                        style: Theme.of(context).textTheme.displaySmall),
                    TextSpan(
                        text: 'Login',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(color: kPrimaryButtonColor)),
                  ])),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      _authController.register(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim());
    }
  }
}
