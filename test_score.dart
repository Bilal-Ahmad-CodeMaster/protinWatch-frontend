import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('assets/mock/covid_replay.json');
  final jsonStr = file.readAsStringSync();
  final json = jsonDecode(jsonStr);
  
  double score = ((json['structural_score'] ?? json['structural_tm_score'] ?? 0.0) as num).toDouble();
  print('Raw score: $score');
  
  double normalized = score > 1.0 ? score / 100.0 : score;
  print('Normalized score: $normalized');
  
  print('In ThreatBars, (normalized * 100).toInt() is: ${(normalized * 100).toInt()}');
}
