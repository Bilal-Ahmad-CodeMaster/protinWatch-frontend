import 'package:get/get.dart';
import '../data/repositories/i_resource_repository.dart';
import '../models/resource_model.dart';

class ResourceController extends GetxController {
  final IResourceRepository repository;
  ResourceController({required this.repository});

  final resourceData = Rxn<ResourceAllocationData>();
  final isLoading = true.obs;
  final showWarning = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadResources();
  }

  Future<void> loadResources() async {
    isLoading.value = true;
    try {
      resourceData.value = await repository.fetchResources();
    } finally {
      isLoading.value = false;
    }
  }

  void triggerTradeOffWarning() {
    showWarning.value = true;
  }
}
