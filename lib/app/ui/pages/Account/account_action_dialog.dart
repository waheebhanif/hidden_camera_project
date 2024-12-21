


import 'package:hidden_camera_detector/app/ui/theme/colors.dart';
import 'package:hidden_camera_detector/app/ui/utils/app_exports.dart';

class AccountActionDialog extends StatelessWidget {
  final String title;
  final Icon iconAsset;
  final String actionButtonText;
  final VoidCallback onAction;

  const AccountActionDialog({
    Key? key,
    required this.title,
    required this.iconAsset,
    required this.actionButtonText,
    required this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Stack(
            children: [
              // Image.asset(
              //   Assets.iconsDilogBackground,
              //   fit: BoxFit.cover,
              // ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Icon(
                    Icons.warning,
                    size: 48,
                    color: kPrimaryButtonColor,
                  ),
                ),
              ),
            ],
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: const Color(0xFF545454),
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: kPrimaryButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color(0xFFE5E5E5).withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    child: Text(
                      actionButtonText,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: const Color(0xFF272727),
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
