class ResourceModel {
  final String id;
  final String name;
  final int deployed;
  final int total;
  final String type;

  ResourceModel({
    required this.id,
    required this.name,
    required this.deployed,
    required this.total,
    required this.type,
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      deployed: json['deployed'] ?? 0,
      total: json['total'] ?? 0,
      type: json['type'] ?? '',
    );
  }
}

class TradeOffWarning {
  final bool active;
  final String title;
  final String description;

  TradeOffWarning({
    required this.active,
    required this.title,
    required this.description,
  });

  factory TradeOffWarning.fromJson(Map<String, dynamic> json) {
    return TradeOffWarning(
      active: json['active'] ?? false,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class ResourceAllocationData {
  final int totalFreeResources;
  final TradeOffWarning warning;
  final Map<String, List<ResourceModel>> allocations;

  ResourceAllocationData({
    required this.totalFreeResources,
    required this.warning,
    required this.allocations,
  });

  factory ResourceAllocationData.fromJson(Map<String, dynamic> json) {
    final allocMap = json['allocations'] as Map<String, dynamic>? ?? {};
    final Map<String, List<ResourceModel>> parsedAllocations = {};
    
    allocMap.forEach((key, value) {
      if (value is List) {
        parsedAllocations[key] = value.map((e) => ResourceModel.fromJson(e)).toList();
      }
    });

    return ResourceAllocationData(
      totalFreeResources: json['total_free_resources'] ?? 0,
      warning: TradeOffWarning.fromJson(json['trade_off_warning'] ?? {}),
      allocations: parsedAllocations,
    );
  }
}
