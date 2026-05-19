import 'dart:convert';
import 'package:flutter/services.dart';

class MockDataLoader {
  static Future<dynamic> loadJson(String path) async {
    // Simulate network latency (800ms) to ensure our Shimmer skeletons look great during the demo
    await Future.delayed(const Duration(milliseconds: 800));
    final String response = await rootBundle.loadString(path);
    return json.decode(response);
  }
}
