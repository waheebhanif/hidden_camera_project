// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hidden_camera_detector/app/ui/pages/scanner/scanner_controller.dart';

// class ScannerView extends StatefulWidget {
//   @override
//   State<ScannerView> createState() => _ScannerViewState();
// }

// class _ScannerViewState extends State<ScannerView>
//     with SingleTickerProviderStateMixin {
//   final ScannerController _scannerController = Get.find();
//   late AnimationController _animationController;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Hidden Camera Scanner'),
//         backgroundColor: Colors.black87,
//       ),
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Detection Mode Toggles
//             // _buildDetectionModeToggles(),

//             // Sonar-like Scanning Interface
//             // Expanded(
//             //   child: Obx(() => _buildSonarInterface(context)),
//             // ),

//             // Scan Button
//             // _buildScanButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget _buildSonarInterface(BuildContext context) {
//   //   return Stack(
//   //     fit: StackFit.expand,
//   //     children: [
//   //       // Background Sonar Grid
//   //       _buildSonarBackground(),

//   //       // Signal Strength Indicator
//   //       if (_scannerController.isScanning.value)
//   //         Center(
//   //           child: Column(
//   //             mainAxisAlignment: MainAxisAlignment.center,
//   //             children: [
//   //               Text(
//   //                 'Overall Signal Strength',
//   //                 style: TextStyle(color: Colors.green[200], fontSize: 16),
//   //               ),
//   //               SizedBox(height: 10),
//   //               _buildSignalStrengthIndicator(),
//   //             ],
//   //           ),
//   //         ),

//   //       // Detected Devices List
//   //       Positioned(
//   //         bottom: 20,
//   //         left: 0,
//   //         right: 0,
//   //         child: _buildDetectedDevicesList(),
//   //       ),
//   //     ],
//   //   );
//   // }

//   // Widget _buildSonarBackground() {
//   //   return Obx(() => CustomPaint(
//   //         painter: SonarPainter(
//   //           isScanning: _scannerController.isScanning.value,
//   //           animationValue: _animationController.value,
//   //         ),
//   //       ));
//   // }

//   // Widget _buildSignalStrengthIndicator() {
//   //   return Obx(() {
//   //     double strength = _scannerController.overallSignalStrength.value;
//   //     return Container(
//   //       width: 200,
//   //       height: 20,
//   //       decoration: BoxDecoration(
//   //         border: Border.all(color: Colors.green[200]!),
//   //         borderRadius: BorderRadius.circular(10),
//   //       ),
//   //       child: Row(
//   //         children: [
//   //           Expanded(
//   //             flex: (strength * 100).toInt(),
//   //             child: Container(
//   //               color: _getSignalColor(strength),
//   //             ),
//   //           ),
//   //           Expanded(
//   //             flex: 100 - (strength * 100).toInt(),
//   //             child: Container(),
//   //           ),
//   //         ],
//   //       ),
//   //     );
//   //   });
//   // }

//   Color _getSignalColor(double strength) {
//     if (strength < 0.3) return Colors.green;
//     if (strength < 0.6) return Colors.yellow;
//     return Colors.red;
//   }

//   // Widget _buildDetectedDevicesList() {
//   //   return Obx(() {
//   //     if (!_scannerController.isScanning.value &&
//   //         _scannerController.detectedDevices.isEmpty) {
//   //       return SizedBox.shrink();
//   //     }

//   //     return Container(
//   //       margin: EdgeInsets.symmetric(horizontal: 20),
//   //       decoration: BoxDecoration(
//   //         color: Colors.black54,
//   //         borderRadius: BorderRadius.circular(10),
//   //       ),
//   //       child: ListView.builder(
//   //         shrinkWrap: true,
//   //         itemCount: _scannerController.detectedDevices.length,
//   //         itemBuilder: (context, index) {
//   //           var device = _scannerController.detectedDevices[index];
//   //           return ListTile(
//   //             leading: Icon(
//   //               _getIconForDeviceType(device.type),
//   //               color: _getColorForSignalStrength(device.signalStrength),
//   //             ),
//   //             title: Text(
//   //               device.name,
//   //               style: TextStyle(
//   //                 color: _getColorForSignalStrength(device.signalStrength),
//   //               ),
//   //             ),
//   //             trailing: Text(
//   //               '${(device.signalStrength * 100).toStringAsFixed(0)}%',
//   //               style: TextStyle(
//   //                 color: _getColorForSignalStrength(device.signalStrength),
//   //               ),
//   //             ),
//   //           );
//   //         },
//   //       ),
//   //     );
//   //   });
//   // }

//   IconData _getIconForDeviceType(DetectionType type) {
//     switch (type) {
//       case DetectionType.infrared:
//         return Icons.camera_alt;
//       case DetectionType.lensReflection:
//         return Icons.lens;
//       case DetectionType.rf:
//         return Icons.wifi;
//     }
//   }

//   Color _getColorForSignalStrength(double strength) {
//     if (strength < 0.3) return Colors.green;
//     if (strength < 0.6) return Colors.yellow;
//     return Colors.red;
//   }

//   // Widget _buildDetectionModeToggles() {
//   //   return Container(
//   //     color: Colors.black87,
//   //     child: Row(
//   //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   //       children: [
//   //         _buildToggle(
//   //           'Infrared',
//   //           _scannerController.infraredDetectionEnabled,
//   //         ),
//   //         _buildToggle(
//   //           'Lens Reflection',
//   //           _scannerController.lensReflectionDetectionEnabled,
//   //         ),
//   //         _buildToggle(
//   //           'RF Signal',
//   //           _scannerController.rfDetectionEnabled,
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   // Widget _buildToggle(String label, RxBool value) {
//   //   return Obx(() => GestureDetector(
//   //         onTap: () => value.value = !value.value,
//   //         child: Container(
//   //           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//   //           decoration: BoxDecoration(
//   //             color: value.value ? Colors.green : Colors.red,
//   //             borderRadius: BorderRadius.circular(20),
//   //           ),
//   //           child: Text(
//   //             label,
//   //             style: TextStyle(color: Colors.white, fontSize: 12),
//   //           ),
//   //         ),
//   //       ));
//   // }

//   // Widget _buildScanButton() {
//   //   return Obx(() => Container(
//   //         width: double.infinity,
//   //         padding: EdgeInsets.all(10),
//   //         color: Colors.black87,
//   //         child: ElevatedButton(
//   //           onPressed: _scannerController.isScanning.value
//   //               ? null
//   //               : _scannerController.startScan,
//   //           style: ElevatedButton.styleFrom(
//   //             backgroundColor: Colors.green,
//   //             padding: const EdgeInsets.symmetric(vertical: 15),
//   //           ),
//   //           child: Text(
//   //             _scannerController.isScanning.value
//   //                 ? 'Scanning...'
//   //                 : 'Start Scan',
//   //             style: TextStyle(color: Colors.white),
//   //           ),
//   //         ),
//   //       ));
//   // }
// }

// class SonarPainter extends CustomPainter {
//   final bool isScanning;
//   final double animationValue;

//   SonarPainter({required this.isScanning, required this.animationValue});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0;

//     final center = Offset(size.width / 2, size.height / 2);

//     if (isScanning) {
//       // Draw fading concentric circles
//       for (double i = 0.2; i <= 1.0; i += 0.2) {
//         double radius = size.width * i * animationValue;

//         // Create a gradient opacity effect
//         paint.color = Colors.green.withOpacity(0.2 * (1 - animationValue));

//         canvas.drawCircle(center, radius, paint);
//       }

//       // Continuous rotating sweep line
//       final angle = animationValue * 2 * pi;
//       final lineLength = size.width * 0.5;
//       final endpoint = Offset(center.dx + lineLength * cos(angle),
//           center.dy + lineLength * sin(angle));

//       final linePaint = Paint()
//         ..color = Colors.green.withOpacity(0.5)
//         ..strokeWidth = 3.0;

//       canvas.drawLine(center, endpoint, linePaint);

//       // Additional ping effect
//       double pingRadius = size.width * 0.3 * animationValue;
//       final pingPaint = Paint()
//         ..color = Colors.green.withOpacity(0.1 * (1 - animationValue))
//         ..style = PaintingStyle.fill;

//       canvas.drawCircle(center, pingRadius, pingPaint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant SonarPainter oldDelegate) {
//     return oldDelegate.isScanning != isScanning ||
//         oldDelegate.animationValue != animationValue;
//   }
// }
