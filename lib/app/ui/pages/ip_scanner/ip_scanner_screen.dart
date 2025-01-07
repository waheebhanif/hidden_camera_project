import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_camera_detector/app/ui/pages/ip_scanner/ip_scanner_controller.dart';
import 'package:hidden_camera_detector/app/ui/theme/colors.dart';

class IPScannerScreen extends StatelessWidget {
  final IPScannerController controller = Get.put(IPScannerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network Scanner'),
        actions: [
          Obx(() => controller.isScanning.value
              ? Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  ),
                )
              : SizedBox()),
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () => _showHelp(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildNetworkInfo(),
          _buildScanSummary(),
          _buildDevicesList(),
          _buildScanControls(),
        ],
      ),
    );
  }

  Widget _buildNetworkInfo() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Network Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Obx(() => Icon(
                      Icons.wifi,
                      color: controller.isConnected.value
                          ? Colors.green
                          : Colors.grey,
                    )),
              ],
            ),
            SizedBox(height: 16),
            Obx(() =>
                _buildInfoRow('Network Name', controller.networkName.value)),
            Obx(() => _buildInfoRow('Your IP', controller.deviceIP.value)),
            Obx(() => _buildInfoRow('Gateway', controller.gatewayIP.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildScanSummary() {
    return Obx(() => controller.devices.isNotEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Found ${controller.devices.length} devices',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Text(
                  'Last scan: ${DateTime.now().toString().substring(11, 16)}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        : SizedBox());
  }

  Widget _buildDevicesList() {
    return Expanded(
      child: Card(
        margin: EdgeInsets.all(16),
        child: Obx(() => ListView.builder(
              itemCount: controller.devices.length,
              itemBuilder: (context, index) {
                final device = controller.devices[index];
                return _buildDeviceCard(device);
              },
            )),
      ),
    );
  }

  Widget _buildDeviceCard(NetworkDevice device) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        leading: Icon(
          device.isGateway ? Icons.router : Icons.devices,
          color: device.isGateway ? Colors.blue : null,
        ),
        title: Text(
          device.deviceName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: device.isGateway ? Colors.blue : null,
          ),
        ),
        subtitle: Text(device.ipAddress),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('MAC Address', device.macAddress),
                SizedBox(height: 8),
                _buildDetailRow(
                  'Open Ports',
                  device.openPorts.isEmpty
                      ? 'None detected'
                      : device.openPorts.join(', '),
                ),
                if (device.isGateway) ...[
                  SizedBox(height: 8),
                  _buildDetailRow('Type', 'Network Gateway'),
                ],
                SizedBox(height: 8),
                _buildDetailRow(
                  'Status',
                  'Online',
                  icon: Icon(Icons.circle, size: 12, color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Widget? icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              if (icon != null) ...[
                icon,
                SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildScanControls() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Obx(() => ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryButtonColor,
                    minimumSize: Size(double.infinity, 48),
                  ),
                  onPressed:
                      controller.isScanning.value ? null : controller.startScan,
                  icon: Icon(
                    controller.isScanning.value
                        ? Icons.radar
                        : Icons.radar_outlined,
                    color: Colors.white,
                  ),
                  label: Text(
                    controller.isScanning.value
                        ? 'Scanning...'
                        : 'Scan Network',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Network Scanner Help'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpItem('Network Info',
                'Shows your current network details including name and IP addresses'),
            _buildHelpItem('Device Cards',
                'Tap a device to see more details including MAC address and open ports'),
            _buildHelpItem('Gateway Device',
                'Marked in blue, this is your router or network gateway'),
            _buildHelpItem('Open Ports',
                'Shows detected open network ports that might indicate device type or services'),
          ],
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
