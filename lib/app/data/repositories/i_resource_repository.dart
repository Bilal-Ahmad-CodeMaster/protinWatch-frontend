import '../../models/resource_model.dart';

abstract class IResourceRepository {
  Future<ResourceAllocationData> fetchResources();
}
