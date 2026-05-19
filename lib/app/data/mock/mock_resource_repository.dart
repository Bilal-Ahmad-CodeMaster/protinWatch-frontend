import '../repositories/i_resource_repository.dart';
import '../../models/resource_model.dart';
import '../providers/mock_data_loader.dart';

class MockResourceRepository implements IResourceRepository {
  @override
  Future<ResourceAllocationData> fetchResources() async {
    final data = await MockDataLoader.loadJson('assets/mock/resources.json');
    return ResourceAllocationData.fromJson(data);
  }
}
