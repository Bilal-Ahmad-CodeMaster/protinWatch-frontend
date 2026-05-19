import 'package:get/get.dart';
import 'sequence_controller.dart';
import '../models/sequence_model.dart';

class MapController extends GetxController {
  final SequenceController _sequenceController = Get.find<SequenceController>();
  
  final RxList<SequenceModel> markers = <SequenceModel>[].obs;
  final RxString selectedMarkerId = ''.obs;

  static final List<SequenceModel> defaultMapMarkers = [
    SequenceModel(
      id: 'PW-H5N7',
      name: 'H5N7 Variant',
      sequenceString: '',
      originLocation: 'East Asia • Wuhan',
      latitude: 33.7,
      longitude: 112.6,
      detectionDate: DateTime(2019, 12, 26),
      threatScore: ThreatScoreModel(
        kmerScore: 73,
        esm2Score: 91,
        structuralTmScore: 0.82,
        combinedThreatIndex: 91,
      ),
      agentTrace: [],
      closestMatch: '',
      geminiBriefEn: '',
      geminiBriefUr: '',
      pdbStructure: '',
    ),
    SequenceModel(
      id: 'PW-COV',
      name: 'Novel Betacoronavirus',
      sequenceString: '',
      originLocation: 'W. Africa • Lagos',
      latitude: 9.0,
      longitude: -1.5,
      detectionDate: DateTime.now().subtract(const Duration(days: 40)),
      threatScore: ThreatScoreModel(
        kmerScore: 68,
        esm2Score: 78,
        structuralTmScore: 0.72,
        combinedThreatIndex: 78,
      ),
      agentTrace: [],
      closestMatch: '',
      geminiBriefEn: '',
      geminiBriefUr: '',
      pdbStructure: '',
    ),
    SequenceModel(
      id: 'PW-INF-B',
      name: 'Influenza B Mut.',
      sequenceString: '',
      originLocation: 'Europe • Berlin',
      latitude: 52.5,
      longitude: 13.4,
      detectionDate: DateTime.now().subtract(const Duration(days: 80)),
      threatScore: ThreatScoreModel(
        kmerScore: 40,
        esm2Score: 58,
        structuralTmScore: 0.55,
        combinedThreatIndex: 58,
      ),
      agentTrace: [],
      closestMatch: '',
      geminiBriefEn: '',
      geminiBriefUr: '',
      pdbStructure: '',
    ),
    SequenceModel(
      id: 'PW-COV-OC43',
      name: 'CoV-OC43 Variant',
      sequenceString: '',
      originLocation: 'N. America • NYC',
      latitude: 40.7,
      longitude: -74.0,
      detectionDate: DateTime.now().subtract(const Duration(days: 120)),
      threatScore: ThreatScoreModel(
        kmerScore: 20,
        esm2Score: 27,
        structuralTmScore: 0.35,
        combinedThreatIndex: 27,
      ),
      agentTrace: [],
      closestMatch: '',
      geminiBriefEn: '',
      geminiBriefUr: '',
      pdbStructure: '',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // Bind markers to sequence history, falling back to default markers if empty
    ever(_sequenceController.sequences, (List<SequenceModel> sequences) {
      _updateMarkers(sequences);
    });

    _updateMarkers(_sequenceController.sequences);
  }

  void _updateMarkers(List<SequenceModel> sequences) {
    if (sequences.isEmpty) {
      markers.value = defaultMapMarkers;
    } else {
      markers.value = sequences;
    }
  }

  void selectMarker(String id) {
    selectedMarkerId.value = id;
    final match = markers.firstWhereOrNull((s) => s.id == id);
    if (match != null) {
      _sequenceController.selectedSequence.value = match;
    }
  }
}
