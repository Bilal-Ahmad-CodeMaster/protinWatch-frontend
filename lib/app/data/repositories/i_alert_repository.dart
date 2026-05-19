import '../../models/alert_model.dart';

abstract class IAlertRepository {
  Future<List<AlertModel>> fetchAlerts();
}
