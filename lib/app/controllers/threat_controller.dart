import 'package:get/get.dart';
import '../models/sequence_model.dart';
import 'sequence_controller.dart';

class ThreatController extends GetxController {
  final SequenceController _sequenceController = Get.find<SequenceController>();

  final RxList<SequenceModel> history = <SequenceModel>[].obs;

  final RxInt threatIndex = 0.obs;
  final RxInt kmerScore = 0.obs;
  final RxInt esm2Score = 0.obs;
  final RxDouble structuralScore = 0.0.obs;
  final RxBool alertFired = false.obs;

  @override
  void onInit() {
    super.onInit();
    // React to sequence changes
    ever(_sequenceController.selectedSequence, (sequence) {
      if (sequence != null) {
        threatIndex.value = sequence.threatScore.combinedThreatIndex;
        kmerScore.value = sequence.threatScore.kmerScore;
        esm2Score.value = sequence.threatScore.esm2Score;
        structuralScore.value = sequence.threatScore.structuralTmScore;
        alertFired.value = sequence.alert != null;
      }
    });
  }

  // Method used by ReplayController to stage the reveal
  void updateStagedScores(int kmer, int esm2, double structural, int combined) {
    kmerScore.value = kmer;
    esm2Score.value = esm2;
    structuralScore.value = structural;
    threatIndex.value = combined;
  }
}
