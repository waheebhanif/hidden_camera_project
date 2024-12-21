import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_camera_detector/app/controllers/auth_controller.dart';
import 'package:hidden_camera_detector/app/routes/app_routes.dart';
import 'package:hidden_camera_detector/app/ui/global_widgets/custom_text_field.dart';
import 'package:hidden_camera_detector/app/ui/theme/colors.dart';
import 'package:hidden_camera_detector/app/ui/theme/size_config.dart';

class LoginView extends StatelessWidget {
  final AuthController _authController = Get.find();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Login', style: Theme.of(context).textTheme.displayMedium),
              SizedBox(height: getProportionateScreenHeight(24)),
              CustomTextField(
                controller: _emailController,
                hintText: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
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
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              Obx(
                () => _authController.isLoading.value
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryButtonColor,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: Text(
                          'Login',
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
                onPressed: () => Get.toNamed(AppRoutes.REGISTER),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: 'Don\'t have an account? ',
                      style: Theme.of(context).textTheme.displaySmall),
                  TextSpan(
                      text: 'Register',
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
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      _authController.login(
          _emailController.text.trim(), _passwordController.text.trim());
      Get.toNamed(AppRoutes.BOTTOM_NAVBAR);
    }
  }
}
