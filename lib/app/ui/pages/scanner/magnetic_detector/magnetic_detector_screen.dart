import 'package:hidden_camera_detector/app/ui/pages/scanner/magnetic_detector/magnetic_detector_controller.dart';
import 'package:hidden_camera_detector/app/ui/pages/scanner/widgets/compass_painter.dart';
import 'package:hidden_camera_detector/app/ui/utils/app_exports.dart';

class MagneticDetectorScreen extends StatelessWidget {
  final MagneticDetectorController controller =
      Get.put(MagneticDetectorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Magnetic Field Detector'),
      ),
      body: Column(
        children: [
          _buildCompass(),
          _buildFieldStrengthGraph(),
          _buildAxisReadings(),
          _buildDetectionControls(),
        ],
      ),
    );
  }

  Widget _buildCompass() {
    return Container(
      height: 200,
      child: Card(
        margin: EdgeInsets.all(16),
        child: Obx(() => Transform.rotate(
              angle: controller.compassAngle.value * 3.14159 / 180,
              child: CustomPaint(
                painter: CompassPainter(),
                size: Size(200, 200),
              ),
            )),
      ),
    );
  }

  Widget _buildFieldStrengthGraph() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Magnetic Field Strength Over Time',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            // Container(
            //   height: 200,
            //   child: Obx(() => LineChart(
            //     controller.magneticFieldData.value,
            //     // Add chart configuration here
            //   )),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildAxisReadings() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildAxisValue('X', controller.xAxis),
            _buildAxisValue('Y', controller.yAxis),
            _buildAxisValue('Z', controller.zAxis),
          ],
        ),
      ),
    );
  }

  Widget _buildAxisValue(String axis, RxDouble value) {
    return Column(
      children: [
        Text(axis, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Obx(() => Text('${value.value.toStringAsFixed(2)} μT')),
      ],
    );
  }

  Widget _buildDetectionControls() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () => controller.toggleDetection(),
            icon: Obx(() => Icon(
                  controller.isDetecting.value ? Icons.stop : Icons.play_arrow,
                )),
            label: Obx(() => Text(
                  controller.isDetecting.value
                      ? 'Stop Detection'
                      : 'Start Detection',
                )),
          ),
          SizedBox(height: 16),
          Obx(() => Text(
                controller.detectionStatus.value,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }
}
