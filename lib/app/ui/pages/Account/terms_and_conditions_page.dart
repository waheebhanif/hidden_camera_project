import 'package:hidden_camera_detector/app/ui/global_widgets/custom_appbar.dart';
import 'package:hidden_camera_detector/app/ui/utils/app_exports.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Terms and Conditions'),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Terms and Conditions',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'These terms and conditions outline the rules and regulations for the use of Hidden Camera Detector\'s Website, located at https://hiddencameradetector.com.',
            ),
          ])),
    );
  }
}
