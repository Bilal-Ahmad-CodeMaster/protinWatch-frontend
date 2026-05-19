// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart' hide MapController;
// import 'package:latlong2/latlong.dart';
// import 'package:get/get.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../theme/app_theme.dart';
// import '../../controllers/map_controller.dart';
// import '../../models/sequence_model.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   final MapController _mapController = Get.find<MapController>();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.sizeOf(context).width;
//     final defaultMarkers = [
//       SequenceModel(
//         id: 'PW-2019-A7F2C1',
//         name: 'Covid-19 Spike',
//         sequenceString: '',
//         originLocation: 'Wuhan, China',
//         latitude: 33.7,
//         longitude: 112.6,
//         detectionDate: DateTime(2019, 12, 26),
//         threatScore: ThreatScoreModel(
//           kmerScore: 73,
//           esm2Score: 91,
//           structuralTmScore: 0.82,
//           combinedThreatIndex: 91,
//         ),
//         agentTrace: [],
//         closestMatch: '',
//         geminiBriefEn: '',
//         geminiBriefUr: '',
//         pdbStructure: '',
//       ),
//       SequenceModel(
//         id: 'PW-EBOLA-VAR',
//         name: 'Ebola variant',
//         sequenceString: '',
//         originLocation: 'West Africa',
//         latitude: 9.0,
//         longitude: -1.5,
//         detectionDate: DateTime.now(),
//         threatScore: ThreatScoreModel(
//           kmerScore: 50,
//           esm2Score: 60,
//           structuralTmScore: 0.6,
//           combinedThreatIndex: 67,
//         ),
//         agentTrace: [],
//         closestMatch: '',
//         geminiBriefEn: '',
//         geminiBriefUr: '',
//         pdbStructure: '',
//       ),
//       SequenceModel(
//         id: 'PW-ZIKA-VAR',
//         name: 'Zika',
//         sequenceString: '',
//         originLocation: 'Brazil',
//         latitude: -15.8,
//         longitude: -47.9,
//         detectionDate: DateTime.now(),
//         threatScore: ThreatScoreModel(
//           kmerScore: 40,
//           esm2Score: 50,
//           structuralTmScore: 0.5,
//           combinedThreatIndex: 54,
//         ),
//         agentTrace: [],
//         closestMatch: '',
//         geminiBriefEn: '',
//         geminiBriefUr: '',
//         pdbStructure: '',
//       ),
//     ];

//     return Scaffold(
//       backgroundColor: AppTheme.background,
//       body: Stack(
//         children: [
//           Obx(() {
//             final sequences = _mapController.markers.isEmpty
//                 ? defaultMarkers
//                 : _mapController.markers;

//             return FlutterMap(
//               options: MapOptions(
//                 initialCenter: const LatLng(20, 0),
//                 initialZoom: 2,
//                 interactionOptions: const InteractionOptions(
//                   flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
//                 ),
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate:
//                       'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}@2x.png',
//                   userAgentPackageName: 'com.proteinwatch.crio_app',
//                 ),
//                 MarkerLayer(
//                   markers: sequences
//                       .map((seq) => _buildMarker(context, seq, w))
//                       .toList(),
//                 ),
//               ],
//             );
//           }),

//           // HUD Overlay
//           Positioned(
//             top: w * 0.01,
//             left: w * 0.04,
//             right: w * 0.04,
//             child: Container(
//               padding: .symmetric(horizontal: w * 0.02, vertical: w * 0.01),
//               decoration: AppTheme.glassDecoration.copyWith(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.public, color: AppTheme.infoBlue, size: w * 0.05),
//                   SizedBox(width: w * 0.025),
//                   Expanded(
//                     child: Text(
//                       'Global Threat Tracker',
//                       style: GoogleFonts.outfit(
//                         color: AppTheme.primaryText,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: w * 0.025,
//                       vertical: w * 0.01,
//                     ),
//                     decoration: BoxDecoration(
//                       color: AppTheme.criticalRed.withValues(alpha: 0.2),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: AppTheme.criticalRed),
//                     ),
//                     child: Text(
//                       'Live',
//                       style: GoogleFonts.outfit(
//                         color: AppTheme.criticalRed,
//                         fontWeight: FontWeight.bold,
//                         fontSize: w * 0.03,
//                       ),
//                     ),
//                   ).animate(onPlay: (c) => c.repeat(reverse: true)).fade(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Marker _buildMarker(BuildContext context, SequenceModel seq, double w) {
//     final score = seq.threatScore.combinedThreatIndex;
//     final color = score >= 75
//         ? AppTheme.criticalRed
//         : (score >= 50 ? AppTheme.warningAmber : AppTheme.safeGreen);
//     final isCritical = score >= 75;
//     final label = seq.name.split(' ').first;

//     return Marker(
//       point: LatLng(seq.latitude, seq.longitude),
//       width: w * 0.2,
//       height: w * 0.05,
//       child: GestureDetector(
//         onTap: () => _showMarkerDetails(context, seq, color),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 if (isCritical)
//                   Container(
//                         width: w * 0.1,
//                         height: w * 0.1,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: color.withValues(alpha: 0.3),
//                         ),
//                       )
//                       .animate(onPlay: (c) => c.repeat())
//                       .scale(
//                         begin: const Offset(0.5, 0.5),
//                         end: const Offset(1.5, 1.5),
//                       )
//                       .fade(end: 0),

//                 Container(
//                   width: w * 0.01,
//                   height: w * 0.01,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: color,
//                     boxShadow: [
//                       BoxShadow(
//                         color: color.withValues(alpha: 0.5),
//                         blurRadius: 6,
//                         spreadRadius: 1,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(width: w * 0.01),
//             Flexible(
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: w * 0.01,
//                   vertical: w * 0.005,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text(
//                   label,
//                   style: GoogleFonts.outfit(
//                     color: Colors.white,
//                     fontSize: w * 0.02,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showMarkerDetails(
//     BuildContext context,
//     SequenceModel seq,
//     Color color,
//   ) {
//     final w = MediaQuery.sizeOf(context).width;
//     final h = MediaQuery.sizeOf(context).height;

//     Get.bottomSheet(
//       Container(
//         padding: EdgeInsets.only(
//           left: w * 0.05,
//           right: w * 0.05,
//           top: h * 0.02,
//           bottom: MediaQuery.of(context).padding.bottom + w * 0.25,
//         ),
//         decoration: BoxDecoration(
//           color: AppTheme.cardSurface.withValues(alpha: 0.95),
//           borderRadius: BorderRadius.vertical(top: Radius.circular(w * 0.06)),
//           border: const Border(
//             top: BorderSide(color: AppTheme.cardBorder, width: 2),
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Container(
//                 width: w * 0.1,
//                 height: h * 0.005,
//                 decoration: BoxDecoration(
//                   color: AppTheme.secondaryText.withValues(alpha: 0.3),
//                   borderRadius: BorderRadius.circular(w * 0.005),
//                 ),
//               ),
//             ),
//             SizedBox(height: h * 0.02),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         seq.name,
//                         style: GoogleFonts.outfit(
//                           color: AppTheme.primaryText,
//                           fontSize: w * 0.05,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Text(
//                         seq.originLocation,
//                         style: GoogleFonts.outfit(
//                           color: AppTheme.secondaryText,
//                           fontSize: w * 0.035,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: w * 0.04,
//                     vertical: h * 0.01,
//                   ),
//                   decoration: BoxDecoration(
//                     color: color.withValues(alpha: 0.2),
//                     borderRadius: BorderRadius.circular(w * 0.03),
//                     border: Border.all(color: color),
//                   ),
//                   child: Text(
//                     '${seq.threatScore.combinedThreatIndex}/100',
//                     style: GoogleFonts.outfit(
//                       color: color,
//                       fontSize: w * 0.055,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: h * 0.01),

//             Row(
//               children: [
//                 Icon(
//                   Icons.calendar_today,
//                   color: AppTheme.secondaryText,
//                   size: w * 0.045,
//                 ),
//                 SizedBox(width: w * 0.02),
//                 Text(
//                   'Detected: ${seq.detectionDate.toIso8601String().split('T').first}',
//                   style: GoogleFonts.outfit(
//                     color: AppTheme.primaryText,
//                     fontSize: w * 0.038,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: Colors.transparent,
//       isScrollControlled: false,
//       isDismissible: true,
//       enableDrag: true,
//     );
//   }
// }
