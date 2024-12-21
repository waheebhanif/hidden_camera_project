import 'package:hidden_camera_detector/app/ui/utils/app_exports.dart';

class FrequencyBand {
  final String name;
  final String range;
  final RxBool isActive = false.obs;

  FrequencyBand(this.name, this.range);
}

class ScanLog {
  final String message;
  final String timestamp;

  ScanLog(this.message, this.timestamp);
}

class MagneticReading {
  final double strength;
  final DateTime timestamp;

  MagneticReading({required this.strength, required this.timestamp});
}
