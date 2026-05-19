import '../repositories/i_alert_repository.dart';
import '../../models/alert_model.dart';
import '../providers/mock_data_loader.dart';

class MockAlertRepository implements IAlertRepository {
  @override
  Future<List<AlertModel>> fetchAlerts() async {
    final data = await MockDataLoader.loadJson('assets/mock/alerts.json');
    return (data as List).map((e) => AlertModel.fromJson(e)).toList();
  }
}
