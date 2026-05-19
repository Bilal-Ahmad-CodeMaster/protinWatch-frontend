import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/sequence_model.dart';

class ApiService extends GetxService {
  late final Dio _dio;
  final String _baseUrl = const String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://bilalahmadcodemaster-proteinwatch-backend.hf.space',
  );

  // Cache the offline replay data
  Map<String, dynamic>? _offlineData;

  Future<ApiService> init() async {
    String activeUrl = _baseUrl;

    try {
      if (Platform.isAndroid) {
        if (activeUrl.contains('localhost')) {
          activeUrl = activeUrl.replaceAll('localhost', '10.0.2.2');
        } else if (activeUrl.contains('127.0.0.1')) {
          activeUrl = activeUrl.replaceAll('127.0.0.1', '10.0.2.2');
        }
      }
    } catch (_) {}

    _dio = Dio(
      BaseOptions(
        baseUrl: activeUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print(
            '🌐 API CALL: [${options.method}] ${options.baseUrl}${options.path}',
          );
          if (options.queryParameters.isNotEmpty) {
            print('   Params: ${options.queryParameters}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print(
            '✅ API RESPONSE: [${response.statusCode}] ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print(
            '❌ API ERROR: [${e.response?.statusCode}] ${e.requestOptions.path} -> ${e.message}',
          );
          return handler.next(e);
        },
      ),
    );

    // Load offline demo data
    try {
      final jsonString = await rootBundle.loadString(
        'assets/mock/covid_replay.json',
      );
      _offlineData = jsonDecode(jsonString);
    } catch (e) {
      print('Warning: Could not load offline mock data: $e');
    }

    return this;
  }

  // Fallback helper
  T _getOfflineData<T>(String key, T defaultValue) {
    if (_offlineData != null && _offlineData!.containsKey(key)) {
      return _offlineData![key] as T;
    }
    return defaultValue;
  }

  Future<SequenceModel> analyzeSequence(String sequence) async {
    try {
      final response = await _dio.post(
        '/analyze',
        data: {'sequence': sequence},
      );
      return SequenceModel.fromJson(response.data);
    } catch (e) {
      print('API Error (analyze), using offline fallback: $e');
      if (_offlineData != null) {
        final data = Map<String, dynamic>.from(_offlineData!);
        data['name'] = 'H5N7 Variant';
        data['origin_location'] = 'East Asia • Wuhan';
        data['latitude'] = 33.7;
        data['longitude'] = 112.6;
        data['pdb_structure'] = '';
        return SequenceModel.fromJson(data);
      }
      throw Exception(
        'Failed to analyze sequence and no offline data available.',
      );
    }
  }

  Future<List<SequenceModel>> getHistory({int? limit}) async {
    try {
      final response = await _dio.get(
        '/history',
        queryParameters: limit != null ? {'limit': limit} : null,
      );
      return (response.data as List)
          .map((e) => SequenceModel.fromJson(e))
          .toList();
    } catch (e) {
      print('API Error (history), using offline fallback: $e');
      if (_offlineData != null) {
        return [
          SequenceModel(
            id: 'PW-H5N7',
            name: 'H5N7 Variant',
            sequenceString: _offlineData!['sequence'] ?? '',
            originLocation: 'East Asia • Wuhan',
            latitude: 33.7,
            longitude: 112.6,
            detectionDate: DateTime(2019, 12, 26),
            threatScore: ThreatScoreModel(
              kmerScore: 73,
              esm2Score: 91,
              structuralTmScore: 0.82,
              combinedThreatIndex: 91,
            ),
            alert: _offlineData!['alert_ticket'] != null
                ? AlertModel.fromJson(_offlineData!['alert_ticket'])
                : null,
            agentTrace:
                (_offlineData!['agent_trace'] as List<dynamic>?)
                    ?.map(
                      (e) => AgentStepModel.fromJson(e as Map<String, dynamic>),
                    )
                    .toList() ??
                [],
            closestMatch:
                _offlineData!['closest_match'] ??
                'SARS-CoV (2003) - 79.6% identity',
            geminiBriefEn: _offlineData!['gemini_brief_en'] ?? '',
            geminiBriefUr: _offlineData!['gemini_brief_ur'] ?? '',
            pdbStructure: '',
          ),
          SequenceModel(
            id: 'PW-COV',
            name: 'Novel Betacoronavirus',
            sequenceString: '',
            originLocation: 'W. Africa • Lagos',
            latitude: 9.0,
            longitude: -1.5,
            detectionDate: DateTime.now().subtract(const Duration(days: 40)),
            threatScore: ThreatScoreModel(
              kmerScore: 68,
              esm2Score: 78,
              structuralTmScore: 0.72,
              combinedThreatIndex: 78,
            ),
            agentTrace: [],
            closestMatch: 'MERS-CoV (2012) - 82.1% identity',
            geminiBriefEn: 'Novel Betacoronavirus detected in Lagos, Nigeria.',
            geminiBriefUr:
                'لاگوس، نائیجیریا میں نیا بیٹا کورونا وائرس دریافت ہوا ہے۔',
            pdbStructure: '',
          ),
          SequenceModel(
            id: 'PW-INF-B',
            name: 'Influenza B Mut.',
            sequenceString: '',
            originLocation: 'Europe • Berlin',
            latitude: 52.5,
            longitude: 13.4,
            detectionDate: DateTime.now().subtract(const Duration(days: 80)),
            threatScore: ThreatScoreModel(
              kmerScore: 40,
              esm2Score: 58,
              structuralTmScore: 0.55,
              combinedThreatIndex: 58,
            ),
            agentTrace: [],
            closestMatch: 'Influenza B virus - 98.4% identity',
            geminiBriefEn: 'Influenza B mutation detected in Berlin, Germany.',
            geminiBriefUr:
                'برلن، جرمنی میں انفلوئنزا بی کی نئی قسم دریافت ہوئی ہے۔',
            pdbStructure: '',
          ),
          SequenceModel(
            id: 'PW-COV-OC43',
            name: 'CoV-OC43 Variant',
            sequenceString: '',
            originLocation: 'N. America • NYC',
            latitude: 40.7,
            longitude: -74.0,
            detectionDate: DateTime.now().subtract(const Duration(days: 120)),
            threatScore: ThreatScoreModel(
              kmerScore: 20,
              esm2Score: 27,
              structuralTmScore: 0.35,
              combinedThreatIndex: 27,
            ),
            agentTrace: [],
            closestMatch: 'Human coronavirus OC43 - 99.1% identity',
            geminiBriefEn: 'CoV-OC43 variant detected in NYC, USA.',
            geminiBriefUr:
                'نیویارک، امریکہ میں کورونا وائرس OC43 کی نئی قسم دریافت ہوئی ہے۔',
            pdbStructure: '',
          ),
        ];
      }
      return [];
    }
  }

  Future<String> getStructure(String sequenceId) async {
    try {
      final response = await _dio.get('/structure/$sequenceId');
      print('PDB Response for $sequenceId: ${response.data}');
      if (response.data is Map && response.data.containsKey('pdb')) {
        return response.data['pdb'].toString();
      }
      return response.data.toString();
    } catch (e) {
      print('API Error (structure), using offline fallback: $e');
      try {
        return await rootBundle.loadString('assets/mock/crio_protein.pdb');
      } catch (err) {
        print('Error loading offline protein PDB file: $err');
        return _getOfflineData('pdb_structure', '');
      }
    }
  }

  Stream<String> streamBrief({
    required String sequence,
    required double threatIndex,
    required double kmer,
    required double esm,
    String? language,
  }) async* {
    // SSE requires streaming response
    try {
      final response = await _dio.get<ResponseBody>(
        '/stream-brief',
        queryParameters: {
          'sequence': sequence,
          'threat_index': threatIndex,
          'kmer': kmer,
          'esm': esm,
          'lang': language,
        },
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: Duration.zero,
          sendTimeout: Duration.zero,
        ),
      );

      final stream = response.data!.stream.cast<List<int>>().transform(
        utf8.decoder,
      );
      await for (final text in stream) {
        // Basic SSE parser (extract data lines)
        for (var line in text.split('\n')) {
          if (line.endsWith('\r')) {
            line = line.substring(0, line.length - 1);
          }
          if (line.startsWith('data: ')) {
            yield line.substring(6);
          }
        }
      }
    } catch (e) {
      print('API Error (stream-brief), using offline fallback: $e');
      // Simulated SSE streaming from offline data
      final fullText = language == 'ur'
          ? _getOfflineData('gemini_brief_ur', 'کوئی ڈیٹا دستیاب نہیں ہے۔')
          : _getOfflineData('gemini_brief_en', 'No brief available.');

      final words = fullText.split(' ');
      for (var word in words) {
        await Future.delayed(const Duration(milliseconds: 50));
        yield '$word ';
      }
    }
  }

  Future<AlertModel?> simulateAction(int threatIndex, String sequenceId) async {
    try {
      final response = await _dio.post(
        '/simulate-action',
        data: {'threat_index': threatIndex, 'sequence_id': sequenceId},
      );
      return AlertModel.fromJson(response.data);
    } catch (e) {
      print('API Error (simulate-action), using offline fallback: $e');
      if (_offlineData != null && _offlineData!['alert_ticket'] != null) {
        return AlertModel.fromJson(_offlineData!['alert_ticket']);
      }
      return null;
    }
  }

  Future<List<AgentStepModel>> getAgentTrace(String analysisId) async {
    try {
      final response = await _dio.get('/agent-trace/$analysisId');
      return (response.data as List)
          .map((e) => AgentStepModel.fromJson(e))
          .toList();
    } catch (e) {
      print('API Error (agent-trace), using offline fallback: $e');
      if (_offlineData != null && _offlineData!['agent_trace'] != null) {
        return (_offlineData!['agent_trace'] as List)
            .map((e) => AgentStepModel.fromJson(e))
            .toList();
      }
      return [];
    }
  }

  Future<bool> updateSchedule(String label) async {
    try {
      await _dio.post('/scheduler/update', data: {'label': label});
      return true;
    } catch (e) {
      print('API Error (scheduler/update): $e');
      return true; // Pretend it succeeded for demo
    }
  }

  Future<bool> triggerLiveFetch() async {
    try {
      await _dio.post('/live-fetch');
      return true;
    } catch (e) {
      print('API Error (live-fetch): $e');
      return true;
    }
  }

  Future<Map<String, dynamic>> checkHealth() async {
    try {
      final response = await _dio.get('/health');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      print('API Error (health): $e');
      return {'model_loaded': false, 'error': e.toString()};
    }
  }
}
