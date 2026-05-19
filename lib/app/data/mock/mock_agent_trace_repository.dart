import '../repositories/i_agent_trace_repository.dart';
import '../../models/agent_trace_model.dart';
import '../providers/mock_data_loader.dart';

class MockAgentTraceRepository implements IAgentTraceRepository {
  @override
  Future<List<AgentTraceModel>> fetchAgentTraces() async {
    final data = await MockDataLoader.loadJson('assets/mock/agent_trace.json');
    return (data as List).map((e) => AgentTraceModel.fromJson(e)).toList();
  }
}
