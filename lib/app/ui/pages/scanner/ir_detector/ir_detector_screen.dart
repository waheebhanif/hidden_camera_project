import 'package:hidden_camera_detector/app/ui/pages/scanner/ir_detector/ir_detector_controller.dart';
import 'package:hidden_camera_detector/app/ui/theme/colors.dart';
import 'package:hidden_camera_detector/app/ui/utils/app_exports.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class EnhancedIRDetectorScreen extends StatelessWidget {
  final controller = Get.put(IRDetectorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildCameraPreview(),
            _buildControls(),
            _buildReadingsView(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade900, Colors.blue.shade700],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white),
              Text(
                'IR Camera Detector',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => _showInstructionsDialog(),
                icon: Icon(Icons.help_outline),
                tooltip: 'How to use',
                iconSize: 28,
                color: Colors.white,
              ),
            ],
          ),
          SizedBox(height: 8),
          Obx(() => Text(
                controller.isInitialized.value
                    ? 'Camera Ready'
                    : 'Initializing Camera...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Obx(() {
      if (!controller.isInitialized.value) {
        return Container(
          height: Get.height * 0.4,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: LoadingAnimationWidget.beat(
              color: kPrimaryButtonColor,
              size: 50,
            ),
          ),
        );
      }

      return Container(
        height: Get.height * 0.4,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kPrimaryButtonColor, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Center(
                child: CameraPreview(
                  controller.cameraController!,
                  child: CustomPaint(
                    painter: ScanOverlayPainter(
                      isScanning: controller.isScanning.value,
                      irStrength: controller.irStrength.value,
                    ),
                  ),
                ),
              ),
              if (controller.isScanning.value)
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Scanning...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildIRMeter() {
    return Obx(() => SizedBox(
          width: 100,
          height: 100,
          child: CustomPaint(
            painter: IRMeterPainter(
              strength: controller.irStrength.value,
              isScanning: controller.isScanning.value,
            ),
          ),
        ));
  }

  Widget _buildControls() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: ElevatedButton.icon(
                onPressed: controller.isInitialized.value
                    ? (controller.isScanning.value
                        ? controller.stopScanning
                        : controller.startScanning)
                    : null,
                icon: Icon(
                  controller.isScanning.value ? Icons.stop : Icons.play_arrow,
                  color: kWhite,
                ),
                label: Text(
                  controller.isScanning.value
                      ? 'Stop Scanning'
                      : 'Start Scanning',
                  style: Theme.of(Get.context!).textTheme.bodySmall,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      controller.isScanning.value ? Colors.red : Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              )),
              SizedBox(width: 16),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${controller.irStrength.value.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getStrengthColor(controller.irStrength.value),
                    ),
                  ),
                  Text(
                    'IR Strength',
                    style: Theme.of(Get.context!).textTheme.headlineSmall,
                  ),
                ],
              ),
              _buildIRMeter(),
            ],
          ),
        ));
  }

  Widget _buildReadingsView() {
    return Container(
      height: Get.height * 0.2,
      child: Obx(() {
        if (controller.readings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.security, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text(
                  'No potential cameras detected',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Potential Hidden Cameras',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.clear_all),
                    onPressed: () => controller.readings.clear(),
                    tooltip: 'Clear all',
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.readings.length,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final reading = controller.readings[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        'Strong IR Source Detected',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                      subtitle: Text(
                        'Strength: ${reading.strength.toStringAsFixed(1)}%\n'
                        'Time: ${_formatTime(reading.timestamp)}',
                        style: TextStyle(fontSize: 13),
                      ),
                      trailing: Text(
                        _getTimeAgo(reading.timestamp),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}';
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Color _getStrengthColor(double strength) {
    if (strength > 75) return Colors.red;
    if (strength > 50) return Colors.orange;
    if (strength > 25) return Colors.yellow;
    return Colors.green;
  }
  // Previous code remains the same until _buildControls...

  void _showInstructionsDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        insetPadding: EdgeInsets.all(10),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'How to Use IR Detector',
              style: Theme.of(Get.context!).textTheme.bodyMedium,
            ),
            Spacer(),
            TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: Text('Got it'),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInstructionStep(
                icon: Icons.lightbulb_outline,
                title: 'Find a Dark Environment',
                description:
                    'For best results, use the detector in a dimly lit or dark room.',
              ),
              _buildInstructionStep(
                icon: Icons.phone_android,
                title: 'Hold Your Phone Correctly',
                description:
                    'Keep your phone steady and about 1-2 feet away from suspected areas.',
              ),
              _buildInstructionStep(
                icon: Icons.speed,
                title: 'Scan Slowly',
                description:
                    'Move your phone slowly across the area you want to check. Quick movements can cause false readings.',
              ),
              _buildInstructionStep(
                icon: Icons.camera_alt,
                title: 'Look for Strong Signals',
                description:
                    'Hidden cameras often show up as bright white dots in your camera view. Red indicators on the strength meter suggest a potential hidden camera.',
              ),
              _buildInstructionStep(
                icon: Icons.warning_amber,
                title: 'Verify Findings',
                description:
                    'Not all IR sources are cameras. Look closely at suspected areas for lens reflections or unusual objects.',
              ),
              Divider(height: 24),
              Text(
                'What to Look For:',
                style: Theme.of(Get.context!).textTheme.bodyMedium,
              ),
              SizedBox(height: 8),
              _buildIndicator(
                color: Colors.green,
                text: 'Low IR (Normal)',
              ),
              _buildIndicator(
                color: Colors.orange,
                text: 'Medium IR (Investigate)',
              ),
              _buildIndicator(
                color: Colors.red,
                text: 'High IR (Potential Camera)',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionStep({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 24, color: Colors.blue),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(Get.context!).textTheme.bodyMedium,
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(Get.context!).textTheme.displaySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator({
    required Color color,
    required String text,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(width: 8),
          Text(text, style: Theme.of(Get.context!).textTheme.displaySmall),
        ],
      ),
    );
  }
}

class ScanOverlayPainter extends CustomPainter {
  final bool isScanning;
  final double irStrength;

  ScanOverlayPainter({
    required this.isScanning,
    required this.irStrength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isScanning) return;

    final paint = Paint()
      ..color = _getStrengthColor(irStrength).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw center targeting box
    final centerRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.3,
      height: size.height * 0.3,
    );

    canvas.drawRect(centerRect, paint);

    // Draw corner indicators
    final cornerSize = 20.0;
    final cornerPaint = Paint()
      ..color = _getStrengthColor(irStrength)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Top-left corner
    canvas.drawLine(
      Offset(0, cornerSize),
      Offset(0, 0),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(0, 0),
      Offset(cornerSize, 0),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(size.width - cornerSize, 0),
      Offset(size.width, 0),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerSize),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(0, size.height - cornerSize),
      Offset(0, size.height),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerSize, size.height),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(size.width - cornerSize, size.height),
      Offset(size.width, size.height),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width, size.height - cornerSize),
      Offset(size.width, size.height),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(ScanOverlayPainter oldDelegate) {
    return oldDelegate.isScanning != isScanning ||
        oldDelegate.irStrength != irStrength;
  }

  Color _getStrengthColor(double strength) {
    if (strength > 75) return Colors.red;
    if (strength > 50) return Colors.orange;
    if (strength > 25) return Colors.yellow;
    return Colors.green;
  }
}

class IRMeterPainter extends CustomPainter {
  final double strength;
  final bool isScanning;

  IRMeterPainter({
    required this.strength,
    required this.isScanning,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.2;

    // Draw background circle
    final bgPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    canvas.drawCircle(center, radius, bgPaint);

    // Draw strength arc
    final strengthPaint = Paint()
      ..color = _getStrengthColor(strength)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14 / 2,
      3.14 * 2 * (strength / 100),
      false,
      strengthPaint,
    );

    // Draw scanning indicator
    if (isScanning) {
      final scanPaint = Paint()
        ..color = Colors.blue.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(center, radius + 15, scanPaint);
    }
  }

  @override
  bool shouldRepaint(IRMeterPainter oldDelegate) {
    return oldDelegate.strength != strength ||
        oldDelegate.isScanning != isScanning;
  }

  Color _getStrengthColor(double strength) {
    if (strength > 75) return Colors.red;
    if (strength > 50) return Colors.orange;
    if (strength > 25) return Colors.yellow;
    return Colors.green;
  }
}

class Vector2 {
  final double x;
  final double y;

  Vector2(this.x, this.y);
}
