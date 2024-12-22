import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_camera_detector/app/ui/pages/scanner/ir_detector/ir_detector_screen.dart';
import 'package:hidden_camera_detector/app/ui/pages/scanner/rf_scanner_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildSearchBar(),
          _buildQuickStats(),
          _buildDetectorGrid(),
          _buildRecentScans(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 140,
      floating: false,
      pinned: true,
      stretch: true,
      leading: SizedBox.shrink(),
      backgroundColor: Colors.blue.shade900,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: EdgeInsets.only(left: 16, bottom: 16),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade900, Colors.blue.shade700],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hidden Camera Detector',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Scan your surroundings for hidden devices',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        // IconButton(
        //   icon: Icon(Icons.notifications_outlined, color: Colors.white),
        //   onPressed: () => Get.toNamed('/notifications'),
        // ),
        IconButton(
          icon: Icon(Icons.help_outline, color: Colors.white),
          onPressed: _showHelp,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search scan history...',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildStatCard(
              'Total Scans',
              '147',
              Icons.analytics_outlined,
              Colors.blue,
            ),
            SizedBox(width: 16),
            _buildStatCard(
              'Detections',
              '3',
              Icons.warning_amber_outlined,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
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
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildListDelegate([
          _buildDetectorCard(
            title: 'RF Detector',
            icon: Icons.wifi_tethering,
            color: Colors.blue,
            description: 'Detect radio frequency signals',
            // features: ['2.4GHz - 5GHz', 'Real-time scanning'],
            onTap: () => Get.to(() => RFDetectorScreen()),
          ),
          _buildDetectorCard(
            title: 'IR Camera',
            icon: Icons.camera,
            color: Colors.orange,
            description: 'Detect infrared light',
            // features: ['Night vision', 'LED detection'],
            onTap: () => Get.to(() => EnhancedIRDetectorScreen()),
          ),
        ]),
      ),
    );
  }

  Widget _buildDetectorCard({
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    // required List<String> features,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 28, color: color),
              ),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 12),
              // ...features.map((feature) => Padding(
              //       padding: EdgeInsets.only(bottom: 4),
              //       child: Row(
              //         children: [
              //           Icon(Icons.check_circle_outline,
              //               size: 14, color: color),
              //           SizedBox(width: 4),
              //           Text(
              //             feature,
              //             style: TextStyle(
              //               fontSize: 11,
              //               color: Colors.grey.shade700,
              //             ),
              //           ),
              //         ],
              //       ),
              //     )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentScans() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Scans',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // TextButton(
                //   onPressed: () => Get.toNamed('/scan-history'),
                //   child: Text('View All'),
                // ),
              ],
            ),
            SizedBox(height: 12),
            _buildScanHistoryItem(
              'RF Scan',
              'No suspicious signals detected',
              Icons.check_circle_outline,
              Colors.green,
              '2 hours ago',
            ),
            _buildScanHistoryItem(
              'IR Scan',
              'Potential camera detected',
              Icons.warning_amber_outlined,
              Colors.orange,
              '5 hours ago',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanHistoryItem(
    String title,
    String description,
    IconData icon,
    Color color,
    String time,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
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
            children: [
              _buildHelpItem(
                Icons.help_outline,
                'RF Detector',
                'Detects radio frequency signals that might indicate hidden cameras',
              ),
              _buildHelpItem(
                Icons.camera,
                'IR Camera',
                'Uses your phone\'s camera to spot infrared lights',
              ),
              _buildHelpItem(
                Icons.lightbulb_outline,
                'Tips',
                '• Scan each area multiple times\n'
                    '• Move slowly while scanning\n'
                    '• Check suspicious spots thoroughly\n'
                    '• Use multiple detection methods',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpItem(IconData icon, String title, String description) {
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
}
