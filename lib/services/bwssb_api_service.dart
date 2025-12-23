import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class BWSSBApiService {
  static const String baseUrl = 'http://wqms.bwssb.gov.in/api';
  
  // Helper method to get headers with token
  Map<String, String> _getHeaders(String? token) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  // Helper method to handle API responses
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }

  // 1. Login API
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final data = {
        'username': username,
        'password': password,
        'grant_type': 'password'
      };

      List<String> formBody = [];
      data.forEach((key, value) {
        String encodedKey = Uri.encodeComponent(key);
        String encodedValue = Uri.encodeComponent(value);
        formBody.add('$encodedKey=$encodedValue');
      });

      final response = await http.post(
        Uri.parse('$baseUrl/Useraccess'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
        },
        body: formBody.join('&'),
      );

      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('Login API Error: $e');
      rethrow;
    }
  }

  // 2. Get Service Stations
  Future<List<dynamic>> getServiceStations(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/GetServiceStation'),
        headers: _getHeaders(token),
      );
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('Get Service Stations Error: $e');
      rethrow;
    }
  }

  // 3. Get Parameters for Service Station
  Future<Map<String, dynamic>> getParametersForServiceStation({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/GetParametersForServiceStation'),
        headers: _getHeaders(token),
      );
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('Get Service Station Parameters Error: $e');
      rethrow;
    }
  }

  // 4. Save Service Station Data
  Future<Map<String, dynamic>> saveServiceStationData({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/SaveServiceStationData'),
        headers: _getHeaders(token),
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('Save Service Station Data Error: $e');
      rethrow;
    }
  }

  // 5. Get WTP List
  Future<List<dynamic>> getWTP(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/GetWTP'),
        headers: _getHeaders(token),
      );
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('Get WTP Error: $e');
      rethrow;
    }
  }

  // 6. Get Parameters for WTP
  Future<List<dynamic>> getParametersForWTP(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/GetParametersForWTP'),
        headers: _getHeaders(token),
      );
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('Get WTP Parameters Error: $e');
      rethrow;
    }
  }

  // 7. Save WTP Data
  Future<Map<String, dynamic>> saveWTPData({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/SaveWTPData'),
        headers: _getHeaders(token),
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('Save WTP Data Error: $e');
      rethrow;
    }
  }

  // 8. Get STP List
  Future<List<dynamic>> getSTP(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/GetSTP'),
        headers: _getHeaders(token),
      );
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('Get STP Error: $e');
      rethrow;
    }
  }

  // 9. Get Parameters for STP
  Future<List<dynamic>> getParametersForSTP(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/GetParametersForSTP'),
        headers: _getHeaders(token),
      );
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('Get STP Parameters Error: $e');
      rethrow;
    }
  }

  // 10. Save STP Data
  Future<Map<String, dynamic>> saveSTPData({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/SaveSTPData'),
        headers: _getHeaders(token),
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('Save STP Data Error: $e');
      rethrow;
    }
  }

  // 11. Get Service Station Report List
  Future<List<dynamic>> getServiceStationReportList({
    required String token,
    required int divisionId,
    required int subDivisionId,
    required int serviceStationId,
    required String reportDate,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/GetServiceStationReportList').replace(
        queryParameters: {
          'divisionId': divisionId.toString(),
          'subDivisionId': subDivisionId.toString(),
          'serviceStationId': serviceStationId.toString(),
          'reportDate': reportDate,
        },
      );

      final response = await http.get(uri, headers: _getHeaders(token));
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('Get Service Station Report List Error: $e');
      rethrow;
    }
  }

  // 12. Get Service Station Detail Report
  Future<Map<String, dynamic>> getServiceStationReportData({
    required String token,
    required int sampleId,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/GetServiceStationReportData').replace(
        queryParameters: {'sampleId': sampleId.toString()},
      );

      final response = await http.get(uri, headers: _getHeaders(token));
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('Get Service Station Report Data Error: $e');
      rethrow;
    }
  }

  // 13. Get WTP Report List
  Future<List<dynamic>> getWTPReportList({
    required String token,
    required String reportStartDate,
    required String reportEndDate,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/GetWTPReportList').replace(
        queryParameters: {
          'reportStartDate': reportStartDate,
          'reportEndDate': reportEndDate,
        },
      );

      final response = await http.get(uri, headers: _getHeaders(token));
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('Get WTP Report List Error: $e');
      rethrow;
    }
  }

  // 14. Get WTP Detail Report
  Future<Map<String, dynamic>> getWTPReportData({
    required String token,
    required String sampleDate,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/GetWTPReportData').replace(
        queryParameters: {'sampleDate': sampleDate},
      );

      final response = await http.get(uri, headers: _getHeaders(token));
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('Get WTP Report Data Error: $e');
      rethrow;
    }
  }

  // 15. Get STP Report List
  Future<List<dynamic>> getSTPReportList({
    required String token,
    required String reportStartDate,
    required String reportEndDate,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/GetSTPReportList').replace(
        queryParameters: {
          'reportStartDate': reportStartDate,
          'reportEndDate': reportEndDate,
        },
      );

      final response = await http.get(uri, headers: _getHeaders(token));
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('Get STP Report List Error: $e');
      rethrow;
    }
  }

  // 16. Get STP Detail Report
  Future<Map<String, dynamic>> getSTPReportData({
    required String token,
    required int sampleId,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/GetSTPReportData').replace(
        queryParameters: {'sampleId': sampleId.toString()},
      );

      final response = await http.get(uri, headers: _getHeaders(token));
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('Get STP Report Data Error: $e');
      rethrow;
    }
  }

  // 17. Get Service Station Data for Dropdowns
  Future<Map<String, dynamic>> getServiceStation({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/GetServiceStation'),
        headers: _getHeaders(token),
      );
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('Get Service Station Error: $e');
      rethrow;
    }
  }

  // 18. Generate Sample ID based on Service Station
  Future<Map<String, dynamic>> generateSampleId({
    required String token,
    required String serviceStationId,
    int type = 0,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/GenerateSampleId').replace(
        queryParameters: {
          'id': serviceStationId,
          'type': type.toString(),
        },
      );
      
      final response = await http.get(uri, headers: _getHeaders(token));
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('Generate Sample ID Error: $e');
      rethrow;
    }
  }

  // Helper methods for filtering dropdown data
  List<Map<String, dynamic>> filterDivisions(List<dynamic> data) {
    final Set<String> uniqueDivisions = {};
    final List<Map<String, dynamic>> divisions = [];
    
    for (var item in data) {
      if (item is Map<String, dynamic> && item['s_DivisionName'] != null) {
        final divisionName = item['s_DivisionName'].toString();
        if (uniqueDivisions.add(divisionName)) {
          divisions.add({
            'name': divisionName,
            'value': divisionName,
          });
        }
      }
    }
    
    return divisions;
  }

  List<Map<String, dynamic>> filterSubDivisions(
    List<dynamic> data,
    String selectedDivision,
  ) {
    final Set<String> uniqueSubDivisions = {};
    final List<Map<String, dynamic>> subDivisions = [];
    
    for (var item in data) {
      if (item is Map<String, dynamic> &&
          item['s_DivisionName'] == selectedDivision &&
          item['s_SubDivisionName'] != null) {
        final subDivisionName = item['s_SubDivisionName'].toString();
        if (uniqueSubDivisions.add(subDivisionName)) {
          subDivisions.add({
            'name': subDivisionName,
            'value': subDivisionName,
          });
        }
      }
    }
    
    return subDivisions;
  }

  List<Map<String, dynamic>> filterServiceStations(
    List<dynamic> data,
    String selectedDivision,
    String selectedSubDivision,
  ) {
    final List<Map<String, dynamic>> serviceStations = [];
    
    for (var item in data) {
      if (item is Map<String, dynamic> &&
          item['s_DivisionName'] == selectedDivision &&
          item['s_SubDivisionName'] == selectedSubDivision &&
          item['s_ServiceStationName'] != null) {
        serviceStations.add({
          'id': item['ServiceStationId'] ?? item['id'],
          'name': item['s_ServiceStationName'].toString(),
          'value': item['s_ServiceStationName'].toString(),
        });
      }
    }
    
    return serviceStations;
  }

  // Static Laboratory Data
  List<Map<String, dynamic>> getLaboratoryOptions() {
    return [
      {'label': 'WTL High Grounds', 'value': '1'},
      {'label': 'WTL Jayanagar', 'value': '2'},
    ];
  }

  // Check if parameter requires form display (Residual Chlorine)
  bool shouldDisplayForm(String parameterName) {
    return parameterName == 'Residual Chlorine';
  }
}