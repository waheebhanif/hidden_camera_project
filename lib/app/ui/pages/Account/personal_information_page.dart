import 'package:hidden_camera_detector/app/controllers/auth_controller.dart';
import 'package:hidden_camera_detector/app/ui/global_widgets/custom_appbar.dart';
import 'package:hidden_camera_detector/app/ui/global_widgets/custom_text_field.dart';
import 'package:hidden_camera_detector/app/ui/theme/colors.dart';
import 'package:hidden_camera_detector/app/ui/theme/size_config.dart';
import 'package:hidden_camera_detector/app/ui/utils/app_exports.dart';

class PersonalInformationPage extends StatelessWidget {
  final AuthController _authController = Get.find();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              // Stack(
              //   children: [
              //     Container(
              //       margin: const EdgeInsets.only(top: 24),
              //       padding: const EdgeInsets.all(3),
              //       decoration: BoxDecoration(
              //         color: kGray,
              //         borderRadius: BorderRadius.circular(100),
              //       ),
              //       child: const CircleAvatar(
              //         radius: 54,
              //         backgroundColor: kScaffoldBackgroundColor,
              //         child: CircleAvatar(
              //           radius: 50,
              //           backgroundImage: AssetImage(Assets.imageCompanyRecipe),
              //         ),
              //       ),
              //     ),
              //     Positioned(
              //       right: 2,
              //       bottom: 0,
              //       child: InkWell(
              //         onTap: () {},
              //         child: SvgPicture.asset(
              //           Assets.iconsEdit,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: getProportionateScreenHeight(32)),
              Text(
                'Email',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              CustomTextField(
                prefixIcon: Icon(
                  Icons.email,
                  color: kPrimaryTextColor,
                ),
                hintText: _authController.user.value?.email ?? "",
                controller: emailController,
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
              ),

              CustomTextField(
                hintText: 'New Password',
                controller: newPasswordController,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryButtonColor,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(
                  'Update',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          )),
    );
  }
}
