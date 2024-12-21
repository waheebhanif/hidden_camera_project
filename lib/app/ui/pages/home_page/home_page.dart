import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:hidden_camera_detector/app/controllers/home_controller.dart';
import 'package:hidden_camera_detector/app/ui/pages/scanner/ir_detector/ir_detector_screen.dart';
import 'package:hidden_camera_detector/app/ui/pages/scanner/magnetic_detector/magnetic_detector_screen.dart';
import 'package:hidden_camera_detector/app/ui/pages/scanner/rf_scanner_view.dart';
import 'package:hidden_camera_detector/app/ui/theme/colors.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: _buildCameraPreview(),
          ),
          _buildStatusSection(),
          _buildDetectorGrid(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Hidden Camera Detector',
            style: Theme.of(Get.context!).textTheme.displayLarge,
          ),
        ],
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        expandedTitleScale: 1,
        collapseMode: CollapseMode.pin,
        stretchModes: [StretchMode.zoomBackground],
        titlePadding: EdgeInsets.only(left: 16, bottom: 16),
        // title: Text(
        //   'Hidden Camera Detector',
        //   // style: Theme.of(Get.context!).textTheme.bodyLarge,
        //   style: TextStyle(color: Colors.white),
        // ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [kPrimaryButtonColor.withOpacity(0.5), kWhite],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.help_outline, color: Colors.black),
          onPressed: _showHelp,
        ),
        // IconButton(
        //   icon: Icon(Icons.settings),
        //   onPressed: () => Get.toNamed('/settings'),
        // ),
      ],
    );
  }

  Widget _buildCameraPreview() {
    return Container(
      height: 200,
      margin: EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Obx(() {
                if (!controller.isCameraInitialized.value) {
                  return Center(child: CircularProgressIndicator());
                }
                return CameraPreview(controller.cameraController.value!);
              }),
              Positioned(
                bottom: 16,
                right: 16,
                child: Row(
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'flash',
                      child: Icon(Icons.flash_on),
                      onPressed: () {
                        
                        // Toggle flash
                      },
                    ),
                    SizedBox(width: 8),
                    FloatingActionButton.small(
                      heroTag: 'flip',
                      child: Icon(Icons.flip_camera_ios),
                      onPressed: () {
                        // Flip camera
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 8),
                    Obx(() => Text(
                          controller.currentStatus.value,
                          style: TextStyle(fontSize: 16),
                        )),
                  ],
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: Colors.blue.shade100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetectorGrid() {
    return SliverPadding(
      padding: EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        delegate: SliverChildListDelegate([
          _buildDetectorCard(
            title: 'RF Detector',
            icon: Icons.wifi_tethering,
            color: Colors.blue,
            description: 'Detect radio frequency signals from hidden devices',
            onTap: () => Get.to(() => RFDetectorScreen()),
          ),
          _buildDetectorCard(
            title: 'Magnetic Field',
            icon: Icons.compass_calibration,
            color: Colors.green,
            description: 'Detect magnetic fields from electronic devices',
            onTap: () => Get.to(() => MagneticDetectorScreen()),
          ),
          _buildDetectorCard(
            title: 'IR Camera',
            icon: Icons.camera,
            color: Colors.orange,
            description: 'Detect infrared light from hidden cameras',
            onTap: () => Get.to(() => IRDetectorScreen()),
          ),
          _buildStatsCard(),
        ]),
      ),
    );
  }

  Widget _buildDetectorCard({
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics, size: 32, color: Colors.purple),
            SizedBox(height: 16),
            Text(
              'Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'View detection history and analysis',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Scans', '24'),
                _buildStat('Alerts', '3'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kPrimaryButtonColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showHelp() {
    Get.dialog(
      AlertDialog(
        title: Text('How to Use'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpItem(
                'RF Detector',
                'Detects radio frequency signals that might indicate hidden cameras',
              ),
              _buildHelpItem(
                'Magnetic Field',
                'Finds electronic devices by detecting their magnetic fields',
              ),
              _buildHelpItem(
                'IR Camera',
                'Uses your phone\'s camera to spot infrared lights',
              ),
              _buildHelpItem(
                'Tips',
                '• Scan each area multiple times\n'
                    '• Move slowly while scanning\n'
                    '• Check suspicious spots thoroughly\n'
                    '• Use multiple detection methods',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
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
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }
}

// lib/widgets/scan_result_dialog.dart
class ScanResultDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color color;

  const ScanResultDialog({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Close'),
        ),
      ],
    );
  }
}
