import 'package:get/get.dart';
import '../models/sequence_model.dart';
import 'sequence_controller.dart';

class ResourceAssignment {
  final String virusName;
  final double threatScore;
  final String assignedWHO; // 'WHO Team A' or 'QUEUED' or 'ESCALATED' or 'None'
  final String assignedLab;
  final String travelStatus;
  final String status; // 'ACTIVE', 'QUEUED', 'ESCALATED', 'CONFLICT', 'SPLIT'
  final DateTime assignedAt;
  final List<String> actionLog; // agent trace entries
  final SequenceModel sequence;

  ResourceAssignment({
    required this.virusName,
    required this.threatScore,
    required this.assignedWHO,
    required this.assignedLab,
    required this.travelStatus,
    required this.status,
    required this.assignedAt,
    required this.actionLog,
    required this.sequence,
  });

  ResourceAssignment copyWith({
    String? virusName,
    double? threatScore,
    String? assignedWHO,
    String? assignedLab,
    String? travelStatus,
    String? status,
    DateTime? assignedAt,
    List<String>? actionLog,
    SequenceModel? sequence,
  }) {
    return ResourceAssignment(
      virusName: virusName ?? this.virusName,
      threatScore: threatScore ?? this.threatScore,
      assignedWHO: assignedWHO ?? this.assignedWHO,
      assignedLab: assignedLab ?? this.assignedLab,
      travelStatus: travelStatus ?? this.travelStatus,
      status: status ?? this.status,
      assignedAt: assignedAt ?? this.assignedAt,
      actionLog: actionLog ?? this.actionLog,
      sequence: sequence ?? this.sequence,
    );
  }
}

class ResourceController extends GetxController {
  final SequenceController _sequenceController = Get.find<SequenceController>();

  // 3 resource pools
  final RxInt whoTeamsAvailable = 3.obs;
  final RxInt labNetworksAvailable = 5.obs;
  final RxInt travelAlertsAvailable = 2.obs;

  final RxList<ResourceAssignment> assignments = <ResourceAssignment>[].obs;
  final RxBool hasConflict = false.obs;

  // Demo simulation state variables
  final RxBool isDemoActive = false.obs;
  List<SequenceModel> _lastSequences = [];

  @override
  void onInit() {
    super.onInit();
    // Watch hasConflict and print change to console
    ever(hasConflict, (val) {
      // hasConflict changed
    });

    // Initialize allocations using sequence controller data
    _processSequences(_sequenceController.sequences);

    // Watch sequence list changes
    ever(_sequenceController.sequences, (list) {
      _processSequences(list);
    });
  }

  void _processSequences(List<SequenceModel> list) {
    _lastSequences = list;
    if (isDemoActive.value) {
      // Don't overwrite state while demo simulation is active
      return;
    }
    if (list.isEmpty) return;

    // Reset resource pool counts
    whoTeamsAvailable.value = 3;
    labNetworksAvailable.value = 5;
    travelAlertsAvailable.value = 2;
    hasConflict.value = false;

    // Deduplicate by virus name keeping only highest score entry
    final Map<String, SequenceModel> uniqueSequences = {};
    for (var sequence in list) {
      final existing = uniqueSequences[sequence.name];
      if (existing == null ||
          sequence.threatScore.combinedThreatIndex >
              existing.threatScore.combinedThreatIndex) {
        uniqueSequences[sequence.name] = sequence;
      }
    }
    final deduplicatedList = uniqueSequences.values.toList();


    // Sort by threat index descending
    deduplicatedList.sort(
      (a, b) => b.threatScore.combinedThreatIndex.compareTo(
        a.threatScore.combinedThreatIndex,
      ),
    );

    final List<ResourceAssignment> newAssignments = [];

    for (var sequence in deduplicatedList) {
      final score = sequence.threatScore.combinedThreatIndex.toDouble();

      String assignedWHO = 'None';
      String assignedLab = 'None';
      String travelStatus = 'None';
      String status = 'ACTIVE';
      List<String> actionLog = [];

      if (score > 75) {
        // Allocate WHO Team
        if (whoTeamsAvailable.value > 0) {
          assignedWHO =
              'WHO Team ${String.fromCharCode(65 + (3 - whoTeamsAvailable.value))}'; // WHO Team A, B, C
          whoTeamsAvailable.value--;
        } else {
          assignedWHO = 'QUEUED';
          status = 'QUEUED';
        }

        // Allocate Lab Network
        if (labNetworksAvailable.value > 0) {
          assignedLab = 'Lab Network ${6 - labNetworksAvailable.value}';
          labNetworksAvailable.value--;
        } else {
          assignedLab = 'QUEUED';
        }

        // Allocate Travel Alert
        if (travelAlertsAvailable.value > 0) {
          travelStatus = 'Alert Level ${3 - travelAlertsAvailable.value}';
          travelAlertsAvailable.value--;
        } else {
          travelStatus = 'QUEUED';
        }

        actionLog.add(
          'Auto-assigned critical response resources at ${_formatUtc(DateTime.now())}',
        );
      } else if (score >= 50) {
        // Allocate Lab only
        if (labNetworksAvailable.value > 0) {
          assignedLab = 'Lab Network ${6 - labNetworksAvailable.value}';
          labNetworksAvailable.value--;
        } else {
          assignedLab = 'QUEUED';
        }
        actionLog.add(
          'Auto-assigned lab monitoring resources at ${_formatUtc(DateTime.now())}',
        );
      } else {
        // 'Monitoring only'
        status = 'ACTIVE';
        actionLog.add(
          'Watchlist registration at ${_formatUtc(DateTime.now())}',
        );
      }

      newAssignments.add(
        ResourceAssignment(
          virusName: sequence.name,
          threatScore: score,
          assignedWHO: assignedWHO,
          assignedLab: assignedLab,
          travelStatus: travelStatus,
          status: status,
          assignedAt: DateTime.now(),
          actionLog: actionLog,
          sequence: sequence,
        ),
      );
    }

    assignments.value = newAssignments;

    // Check conflict: conflict triggers when whoTeamsAvailable <= 1
    if (whoTeamsAvailable.value <= 1) {
      hasConflict.value = true;
    }
  }

  String _formatUtc(DateTime dateTime) {
    final utc = dateTime.toUtc();
    final hour = utc.hour.toString().padLeft(2, '0');
    final minute = utc.minute.toString().padLeft(2, '0');
    return '$hour:$minute UTC';
  }

  void queueThreat(String virusName) {
    final index = assignments.indexWhere((a) => a.virusName == virusName);
    if (index != -1) {
      assignments[index] = assignments[index].copyWith(
        status: 'QUEUED',
        actionLog: [
          ...assignments[index].actionLog,
          'Queued at ${_formatUtc(DateTime.now())}',
        ],
      );
      assignments.refresh();
    }
  }

  void splitResources(String virusName) {
    final index = assignments.indexWhere((a) => a.virusName == virusName);
    if (index != -1) {
      assignments[index] = assignments[index].copyWith(
        status: 'SPLIT',
        assignedWHO: 'Partial Team',
        actionLog: [
          ...assignments[index].actionLog,
          'Split resources at ${_formatUtc(DateTime.now())}',
        ],
      );
      assignments.refresh();
    }
  }

  void escalateToHQ(String virusName) {
    final index = assignments.indexWhere((a) => a.virusName == virusName);
    if (index != -1) {
      assignments[index] = assignments[index].copyWith(
        status: 'ESCALATED',
        actionLog: [
          ...assignments[index].actionLog,
          'Escalated to WHO HQ at ${_formatUtc(DateTime.now())}',
        ],
      );
      assignments.refresh();
    }
  }

  String? getFirstQueuedThreatName() {
    final firstQueued = assignments.firstWhereOrNull(
      (a) => a.status == 'QUEUED',
    );
    return firstQueued?.virusName;
  }

  /// Returns the name of the first REAL critical virus from assignments.
  /// A "real" virus is any non-simulated virus with threatScore > 75.
  /// Falls back to 'Novel-H7N2' only when no real critical virus exists at all.
  String get conflictVirusName => getTargetThreatName();

  String getTargetThreatName() {
    // First check real assignments for any CRITICAL virus (not simulated)
    final realCritical = assignments.firstWhereOrNull(
      (a) => a.threatScore > 75 && a.virusName != 'Novel-H7N2',
    );
    if (realCritical != null) return realCritical.virusName;
    // Fallback to simulation virus
    return 'Novel-H7N2';
  }

  void resolveConflict(String action) {
    final virusName = getFirstQueuedThreatName();
    if (virusName != null) {
      if (action == 'queue') {
        queueThreat(virusName);
      } else if (action == 'split') {
        splitResources(virusName);
      } else if (action == 'escalate') {
        escalateToHQ(virusName);
      }

      // Check if there are any remaining queued critical threats
      final remainingQueuedCritical = assignments.any(
        (a) => a.threatScore > 75 && a.status == 'QUEUED',
      );
      if (!remainingQueuedCritical) {
        hasConflict.value = false;
      }
    }
  }

  void toggleDemo() {
    isDemoActive.value = !isDemoActive.value;
    if (isDemoActive.value) {
      // Activate Demo:
      // Sets whoTeamsAvailable to 0
      whoTeamsAvailable.value = 0;

      // Create a dummy critical sequence:
      final SequenceModel dummySequence;
      if (_lastSequences.isNotEmpty) {
        final orig = _lastSequences.first;
        dummySequence = SequenceModel(
          id: 'demo-H7N2',
          name: 'Novel-H7N2',
          sequenceString: orig.sequenceString,
          originLocation: 'Geneva, CH',
          latitude: orig.latitude,
          longitude: orig.longitude,
          detectionDate: DateTime.now(),
          threatScore: ThreatScoreModel(
            combinedThreatIndex: 89,
            kmerScore: 85,
            esm2Score: 92,
            structuralTmScore: 0.88,
          ),
          alert: orig.alert,
          agentTrace: orig.agentTrace,
          closestMatch: orig.closestMatch,
          geminiBriefEn: 'Simulated Novel Influenza H7N2 Mutation Detected.',
          geminiBriefUr: 'ڈیمو خطرہ سمیولیشن',
          pdbStructure: orig.pdbStructure,
        );
      } else {
        dummySequence = SequenceModel(
          id: 'demo-H7N2',
          name: 'Novel-H7N2',
          sequenceString: 'ATCG',
          originLocation: 'Geneva, CH',
          latitude: 46.2,
          longitude: 6.1,
          detectionDate: DateTime.now(),
          threatScore: ThreatScoreModel(
            combinedThreatIndex: 89,
            kmerScore: 85,
            esm2Score: 92,
            structuralTmScore: 0.88,
          ),
          agentTrace: [],
          closestMatch: 'None',
          geminiBriefEn: 'Simulated Novel Influenza H7N2 Mutation Detected.',
          geminiBriefUr: 'ڈیمو خطرہ سمیولیشن',
          pdbStructure: '',
        );
      }

      final fakeAssignment = ResourceAssignment(
        virusName: 'Novel-H7N2',
        threatScore: 89.0,
        assignedWHO: 'QUEUED',
        assignedLab: 'Lab Network 1',
        travelStatus: 'Alert Level 1',
        status: 'QUEUED',
        assignedAt: DateTime.now(),
        actionLog: [
          'Simulated Critical threat initiated at ${_formatUtc(DateTime.now())}',
        ],
        sequence: dummySequence,
      );

      // Insert fake critical threat at the top of assignments queue
      assignments.insert(0, fakeAssignment);

      // Trigger hasConflict = true
      hasConflict.value = true;
    } else {
      // Reset Demo: Restore original state
      _processSequences(_sequenceController.sequences);
    }
  }
}
