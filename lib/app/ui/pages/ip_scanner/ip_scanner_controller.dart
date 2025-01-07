import 'dart:io';
import 'package:hidden_camera_detector/app/ui/utils/app_exports.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:permission_handler/permission_handler.dart';

class IPScannerController extends GetxController {
  final NetworkInfo _networkInfo = NetworkInfo();
  RxBool isConnected = false.obs;
  RxBool isScanning = false.obs;
  RxString networkName = ''.obs;
  RxString deviceIP = ''.obs;
  RxString gatewayIP = ''.obs;
  RxList<NetworkDevice> devices = <NetworkDevice>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeNetworkInfo();
  }

  void _initializeNetworkInfo() async {
    try {
      final wifiName = await _networkInfo.getWifiName();
      final wifiIP = await _networkInfo.getWifiIP();
      final gatewayIP = await _networkInfo.getWifiGatewayIP();

      networkName.value = wifiName ?? 'Unknown Network';
      deviceIP.value = wifiIP ?? 'Unknown IP';
      this.gatewayIP.value = gatewayIP ?? 'Unknown Gateway';

      isConnected.value =
          wifiName != null && wifiIP != null && gatewayIP != null;
    } catch (e) {
      print('Error getting network info: $e');
    }
  }

  Future<void> startScan() async {
    if (!isConnected.value) {
      Get.snackbar(
        'Error',
        'Please connect to a WiFi network first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isScanning.value = true;
    devices.clear();

    try {
      // Get the subnet from device IP
      final String subnet =
          deviceIP.value.substring(0, deviceIP.value.lastIndexOf('.'));

      // Scan multiple common ports to increase device discovery
      final commonPorts = [
        80,
        443,
        22,
        21,
        62078
      ]; // HTTP, HTTPS, SSH, FTP, iPhone

      for (final port in commonPorts) {
        final stream = NetworkAnalyzer.discover2(subnet, port);

        await for (final host in stream) {
          if (host.exists) {
            // Check if device already discovered
            if (!devices.any((device) => device.ipAddress == host.ip)) {
              try {
                // Use faster ping timeout for quicker scanning
                final ping = Ping(host.ip, count: 1, timeout: 1);
                final response = await ping.stream.first;

                if (response.response != null) {
                  final macAddress = await _getMacAddress(host.ip);
                  final deviceName = await _getDeviceName(host.ip);

                  devices.add(NetworkDevice(
                      ipAddress: host.ip,
                      macAddress: macAddress,
                      deviceName: deviceName,
                      signalStrength: 100.0,
                      // Add port information
                      openPorts: [port],
                      isGateway: host.ip == gatewayIP.value));
                }
              } catch (e) {
                print('Error processing ${host.ip}: $e');
              }
            } else {
              // Update existing device's open ports
              final existingDevice =
                  devices.firstWhere((device) => device.ipAddress == host.ip);
              existingDevice.openPorts.add(port);
            }
          }
        }
      }

      // Sort devices by IP address for better readability
      devices.sort((a, b) => a.ipAddress.compareTo(b.ipAddress));
    } catch (e) {
      print('Error during network scan: $e');
      Get.snackbar(
        'Scan Error',
        'Error while scanning network devices',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isScanning.value = false;
    }
  }

  Future<String> _getMacAddress(String ip) async {
    try {
      // Try multiple methods to get MAC address
      String? macAddress;

      // Method 1: ARP table
      final arpResult = await Process.run('arp', ['-n', ip]);
      final arpOutput = arpResult.stdout.toString();
      final RegExp macRegex =
          RegExp(r'([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})');
      final arpMatch = macRegex.firstMatch(arpOutput);
      if (arpMatch != null) {
        macAddress = arpMatch.group(0);
      }

      return macAddress ?? 'Unknown MAC';
    } catch (e) {
      print('Error getting MAC for $ip: $e');
      return 'Unknown MAC';
    }
  }

  Future<String> _getDeviceName(String ip) async {
    try {
      // Try multiple methods to get device name
      String deviceName = 'Unknown Device';

      // Method 1: Reverse DNS lookup
      try {
        final result = await InternetAddress(ip).reverse();
        if (result.host != ip) {
          deviceName = result.host;
        }
      } catch (e) {
        print('Reverse DNS lookup failed for $ip: $e');
      }

      // Method 2: Try to identify common devices by open ports
      if (deviceName == 'Unknown Device') {
        final ping = Ping(ip, count: 1, timeout: 1);
        final response = await ping.stream.first;
        if (response.response != null) {
          if (ip == gatewayIP.value) {
            deviceName = 'Router/Gateway';
          }
        }
      }

      return deviceName;
    } catch (e) {
      print('Error getting name for $ip: $e');
      return 'Unknown Device';
    }
  }
}

class NetworkDevice {
  final String ipAddress;
  final String macAddress;
  final String deviceName;
  final double signalStrength;
  final List<int> openPorts;
  final bool isGateway;

  NetworkDevice({
    required this.ipAddress,
    required this.macAddress,
    required this.deviceName,
    required this.signalStrength,
    this.openPorts = const [],
    this.isGateway = false,
  });
}
