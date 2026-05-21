import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('assets/mock/covid_replay.json');
  final jsonStr = file.readAsStringSync();
  final json = jsonDecode(jsonStr);
  
  double score = ((json['structural_score'] ?? json['structural_tm_score'] ?? 0.0) as num).toDouble();
  double normalized = score > 1.0 ? score / 100.0 : score;
}
