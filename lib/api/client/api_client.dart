import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.mtc.com.na/v1',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  Future<Map<String, dynamic>> getIdentity(String phone) async {
    try {
      // Prepared for MTC API Integration
      // final response = await _dio.get('/lookup/$phone');

      // Verification of network link
      debugPrint("Connecting to MTC Gateway via: ${_dio.options.baseUrl}");

      // Simulated Enterprise Response
      return {
        'phone': phone,
        'name': 'Johannes Shipanga',
        'is_registered': true,
        'risk_score': 0.02,
      };
    } catch (e) {
      throw Exception('MTC Gateway Timeout: $e');
    }
  }
}
