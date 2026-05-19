import '../../models/agent_trace_model.dart';

abstract class IAgentTraceRepository {
  Future<List<AgentTraceModel>> fetchAgentTraces();
}
