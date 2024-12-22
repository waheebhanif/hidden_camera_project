import 'package:hidden_camera_detector/app/controllers/auth_controller.dart';
import 'package:hidden_camera_detector/app/ui/global_widgets/custom_appbar.dart';
import 'package:hidden_camera_detector/app/ui/global_widgets/custom_text_field.dart';
import 'package:hidden_camera_detector/app/ui/theme/colors.dart';
import 'package:hidden_camera_detector/app/ui/theme/size_config.dart';
import 'package:hidden_camera_detector/app/ui/utils/app_exports.dart';

class PersonalInformationPage extends StatelessWidget {
  final AuthController _authController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = _authController.userName.value;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: 'Personal Info',
        onLeadingTap: () {
          Get.back();
        },
        titleStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            CustomTextField(
              controller: nameController,
              prefixIcon: Icon(
                Icons.person,
                color: kPrimaryTextColor,
              ),
              hintText: _authController.userName.value,
            ),
            SizedBox(height: getProportionateScreenHeight(32)),
            Text(
              'Email',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            CustomTextField(
              controller: TextEditingController(),
              prefixIcon: Icon(
                Icons.email,
                color: kPrimaryButtonColor,
              ),
              hintText: _authController.user.value?.email ?? "",
              readOnly: true,
            ),
            SizedBox(height: getProportionateScreenHeight(32)),
            Text(
              'Change Password',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            CustomTextField(
              hintText: 'Current Password',
              controller: currentPasswordController,
              obscureText: true,
            ),
            CustomTextField(
              hintText: 'New Password',
              controller: newPasswordController,
              obscureText: true,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                String newName = nameController.text.trim();
                String currentPassword = currentPasswordController.text.trim();
                String newPassword = newPasswordController.text.trim();

                if (newName.isNotEmpty) {
                  await _authController.updateName(newName);
                }
                if (currentPassword.isNotEmpty && newPassword.isNotEmpty) {
                  await _authController.updatePassword(
                      currentPassword, newPassword);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryButtonColor,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Text(
                'Update',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
