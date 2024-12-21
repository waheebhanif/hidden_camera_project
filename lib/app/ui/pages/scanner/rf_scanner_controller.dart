import 'package:hidden_camera_detector/app/data/models/detector_models.dart';
import 'package:hidden_camera_detector/app/ui/utils/app_exports.dart';
import 'package:intl/intl.dart';

class RFDetectorController extends GetxController {
  RxDouble signalStrength = 0.0.obs;
  RxBool isScanning = false.obs;
  RxList<ScanLog> scanHistory = <ScanLog>[].obs;
  List<FrequencyBand> frequencyBands = [
    FrequencyBand('WiFi', '2.4 GHz'),
    FrequencyBand('Bluetooth', '2.4 GHz'),
    FrequencyBand('Wireless Cameras', '5.8 GHz'),
    FrequencyBand('Cellular', '800-900 MHz'),
  ];

  Timer? _scanTimer;

  void startScan() {
    isScanning.value = true;
    _scanTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
      _updateSignalStrength();
      _checkFrequencyBands();
    });

    addLog('Scan started');
  }

  void resetScan() {
    _scanTimer?.cancel();
    isScanning.value = false;
    signalStrength.value = 0;
    for (var band in frequencyBands) {
      band.isActive.value = false;
    }
    addLog('Scan reset');
  }

  void _updateSignalStrength() {
    // Simulate signal strength changes
    signalStrength.value = (Random().nextDouble() * 100).clamp(0, 100);
  }

  void _checkFrequencyBands() {
    for (var band in frequencyBands) {
      band.isActive.value = Random().nextBool();
      if (band.isActive.value) {
        addLog('Activity detected in ${band.name} band');
      }
    }
  }

  void addLog(String message) {
    final timestamp = DateFormat('HH:mm:ss').format(DateTime.now());
    scanHistory.insert(0, ScanLog(message, timestamp));
    if (scanHistory.length > 10) scanHistory.removeLast();
  }

  @override
  void onClose() {
    _scanTimer?.cancel();
    super.onClose();
  }
}
