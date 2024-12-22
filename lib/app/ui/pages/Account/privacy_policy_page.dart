import 'package:hidden_camera_detector/app/ui/global_widgets/custom_appbar.dart';
import 'package:hidden_camera_detector/app/ui/utils/app_exports.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Privacy Policy'),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Privacy Policy',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'Your privacy is important to us. It is Hidden Camera Detector\'s policy to respect your privacy regarding any information we may collect from you across our website, https://hiddencameradetector.com, and other sites we own and operate.',
            ),
          ])),
    );
  }
}
