import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:hidden_camera_detector/app/ui/pages/scanner/rf_scanner_controller.dart';
import 'package:hidden_camera_detector/app/ui/theme/colors.dart';
import 'package:hidden_camera_detector/app/ui/utils/app_exports.dart';

class RFDetectorScreen extends StatelessWidget {
  final RFDetectorController controller = Get.put(RFDetectorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RF Detector'),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () => _showHelp(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSignalStrengthMeter(),
          _buildFrequencyBands(),
          _buildScanControls(),
          _buildHistoryLog(),
        ],
      ),
    );
  }

  Widget _buildSignalStrengthMeter() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Signal Strength',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Obx(() => FAProgressBar(
                    currentValue: controller.signalStrength.value,
                    maxValue: 100,
                    size: 30,
                    animatedDuration: Duration(milliseconds: 300),
                    direction: Axis.horizontal,
                    border: Border.all(color: Colors.blue),
                    progressColor:
                        _getStrengthColor(controller.signalStrength.value),
                    backgroundColor: Colors.blue[50]!,
                  )),
              SizedBox(height: 8),
              Obx(() => Text(
                    '${controller.signalStrength.value.toStringAsFixed(1)} dBm',
                    style: TextStyle(fontSize: 18),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStrengthColor(double value) {
    if (value < 30) return Colors.green;
    if (value < 70) return Colors.orange;
    return Colors.red;
  }

  Widget _buildFrequencyBands() {
    return Expanded(
      child: Card(
        elevation: 0,
        margin: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: controller.frequencyBands.length,
          itemBuilder: (context, index) {
            final band = controller.frequencyBands[index];
            return ListTile(
              title: Text('${band.name} (${band.range})'),
              trailing: Obx(() => Icon(
                    Icons.radio_button_checked,
                    color: band.isActive.value ? Colors.red : Colors.grey,
                  )),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScanControls() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Obx(() => ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryButtonColor,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: controller.isScanning.value
                      ? null
                      : () => controller.startScan(),
                  icon: Icon(Icons.radar, color: Colors.white),
                  label: Text(
                    controller.isScanning.value ? 'Scanning...' : 'Start Scan',
                    style: Theme.of(Get.context!)
                        .textTheme
                        .displaySmall!
                        .copyWith(
                            color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                )),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryButtonColor,
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () => controller.resetScan(),
              icon: Icon(Icons.refresh, color: Colors.white),
              label: Text(
                'Reset',
                style: Theme.of(Get.context!)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryLog() {
    return Container(
      height: 150,
      child: Card(
        margin: EdgeInsets.all(16),
        child: Obx(() => ListView.builder(
              itemCount: controller.scanHistory.length,
              itemBuilder: (context, index) {
                final log = controller.scanHistory[index];
                return ListTile(
                  dense: true,
                  leading: Icon(Icons.history),
                  title: Text(log.message),
                  subtitle: Text(log.timestamp),
                );
              },
            )),
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('How to Use RF Detector'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpItem('Signal Strength',
                  'Shows the current RF signal strength in your area.'),
              _buildHelpItem('Frequency Bands',
                  'Common frequency ranges used by surveillance devices.'),
              _buildHelpItem(
                  'Scan History', 'Log of detected signals and activities.'),
              _buildHelpItem(
                  'Tips',
                  '• Move slowly around the area\n'
                      '• Pay attention to sudden strength changes\n'
                      '• Check suspicious areas multiple times'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }
}
