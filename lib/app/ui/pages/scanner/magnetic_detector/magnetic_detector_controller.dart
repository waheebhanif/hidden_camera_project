import 'package:hidden_camera_detector/app/data/models/detector_models.dart';
import 'package:hidden_camera_detector/app/ui/utils/app_exports.dart';

class MagneticDetectorController extends GetxController {
  RxDouble compassAngle = 0.0.obs;
  RxDouble xAxis = 0.0.obs;
  RxDouble yAxis = 0.0.obs;
  RxDouble zAxis = 0.0.obs;
  RxBool isDetecting = false.obs;
  RxString detectionStatus = 'Ready to detect'.obs;
  RxList<MagneticReading> readings = <MagneticReading>[].obs;

  StreamSubscription? _magnetometerSubscription;
  Timer? _updateTimer;

  @override
  void onInit() {
    super.onInit();
    _initializeSensors();
  }

  void _initializeSensors() {
    _magnetometerSubscription =
        magnetometerEvents.listen((MagnetometerEvent event) {
      xAxis.value = event.x;
      yAxis.value = event.y;
      zAxis.value = event.z;

      // Update compass angle based on magnetic north
      compassAngle.value = atan2(event.y, event.x) * 180 / pi;

      if (isDetecting.value) {
        _processReading(event);
      }
    });
  }

  void toggleDetection() {
    isDetecting.value = !isDetecting.value;
    if (isDetecting.value) {
      detectionStatus.value = 'Detection in progress...';
      _startDataCollection();
    } else {
      detectionStatus.value = 'Detection stopped';
      _updateTimer?.cancel();
    }
  }

  void _startDataCollection() {
    readings.clear();
    _updateTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
      _analyzeReadings();
    });
  }

  void _processReading(MagnetometerEvent event) {
    final strength =
        sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    readings.add(MagneticReading(
      strength: strength,
      timestamp: DateTime.now(),
    ));

    // Keep only last 100 readings
    if (readings.length > 100) {
      readings.removeAt(0);
    }
  }

  void _analyzeReadings() {
    if (readings.isEmpty) return;

    final currentStrength = readings.last.strength;
    final averageStrength =
        readings.map((r) => r.strength).reduce((a, b) => a + b) /
            readings.length;

    if (currentStrength > averageStrength * 1.5) {
      detectionStatus.value = 'Warning: Strong magnetic field detected!';
    } else if (currentStrength > averageStrength * 1.2) {
      detectionStatus.value = 'Notice: Elevated magnetic field levels';
    } else {
      detectionStatus.value = 'Normal magnetic field levels';
    }
  }

  @override
  void onClose() {
    _magnetometerSubscription?.cancel();
    _updateTimer?.cancel();
    super.onClose();
  }
}
