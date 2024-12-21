import 'package:hidden_camera_detector/app/ui/pages/scanner/ir_detector/ir_detector_controller.dart';
import 'package:hidden_camera_detector/app/ui/utils/app_exports.dart';

class IRDetectorScreen extends StatelessWidget {
  final IRDetectorController controller = Get.put(IRDetectorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IR Camera Detector'),
      ),
      body: Column(
        children: [
          _buildCameraPreview(),
          _buildControls(),
          _buildDetectionResults(),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Expanded(
      flex: 2,
      child: Card(
        margin: EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Obx(() =>
                  controller.cameraController.value?.value.isInitialized ??
                          false
                      ? CameraPreview(controller.cameraController.value!)
                      : Center(child: CircularProgressIndicator())),
              Positioned(
                top: 16,
                right: 16,
                child: FloatingActionButton(
                  mini: true,
                  child: Icon(Icons.flip_camera_ios),
                  onPressed: controller.switchCamera,
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  mini: true,
                  child: Icon(Icons.flash_on),
                  onPressed: controller.toggleFlash,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildControlButton(
                  'Night Mode',
                  Icons.nightlight_round,
                  controller.toggleNightMode,
                ),
                _buildControlButton(
                  'IR Filter',
                  Icons.filter_vintage,
                  controller.toggleIRFilter,
                ),
                _buildControlButton(
                  'Analysis',
                  Icons.analytics,
                  controller.toggleAnalysis,
                ),
              ],
            ),
            SizedBox(height: 16),
            Obx(() => Slider(
                  value: controller.sensitivity.value,
                  onChanged: controller.setSensitivity,
                  min: 0,
                  max: 100,
                  label:
                      'Sensitivity: ${controller.sensitivity.value.round()}%',
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(
      String label, IconData icon, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
          color: Colors.blue,
        ),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildDetectionResults() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Detection Results',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Obx(() => Text(controller.detectionStatus.value)),
            SizedBox(height: 8),
            Obx(() => LinearProgressIndicator(
                  value: controller.detectionProgress.value,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                )),
          ],
        ),
      ),
    );
  }
}
