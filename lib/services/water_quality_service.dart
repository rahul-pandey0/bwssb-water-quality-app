import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/water_quality_models.dart';
import 'bwssb_api_service.dart';

class WaterQualityService {
  final BWSSBApiService _apiService = BWSSBApiService();
  
  // Get all service stations from API
  Future<List<Map<String, dynamic>>> getServiceStations(String token) async {
    try {
      final response = await _apiService.getServiceStations(token);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) print('Error fetching service stations: $e');
      // Return mock data on error
      return _getMockServiceStations();
    }
  }

  // Get parameters for service station
  Future<List<Map<String, dynamic>>> getServiceStationParameters(String token) async {
    try {
      final response = await _apiService.getParametersForServiceStation(token: token);
      if (response['success'] == true && response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      return [];
    } catch (e) {
      if (kDebugMode) print('Error fetching service station parameters: $e');
      return [];
    }
  }

  // Submit service station sample data
  Future<bool> submitServiceStationSample({
    required String token,
    required String sampleId,
    required String sampleDate,
    required String analysisStartDate,
    required String analysisCompleteDate,
    required String address,
    required int serviceStationId,
    required int userId,
    required double latitude,
    required double longitude,
    required List<Map<String, dynamic>> parameterData,
  }) async {
    try {
      final data = {
        'SampleId': sampleId,
        'SampleDate': sampleDate,
        'AnalysisStartDate': analysisStartDate,
        'AnalysisCompleteDate': analysisCompleteDate,
        'Address': address,
        'ServiceStationId': serviceStationId,
        'UserId': userId,
        'Latitude': latitude,
        'Longitude': longitude,
        'ParameterData': parameterData,
      };

      final response = await _apiService.saveServiceStationData(
        token: token,
        data: data,
      );
      
      return response != null;
    } catch (e) {
      if (kDebugMode) print('Error submitting service station sample: $e');
      return false;
    }
  }

  // Get WTP list
  Future<List<Map<String, dynamic>>> getWTPList(String token) async {
    try {
      final response = await _apiService.getWTP(token);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) print('Error fetching WTP list: $e');
      return [];
    }
  }

  // Get WTP parameters
  Future<List<Map<String, dynamic>>> getWTPParameters(String token) async {
    try {
      final response = await _apiService.getParametersForWTP(token);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) print('Error fetching WTP parameters: $e');
      return [];
    }
  }

  // Submit WTP data
  Future<bool> submitWTPSample({
    required String token,
    required String sampleDate,
    required String analysisStartDate,
    required String analysisCompleteDate,
    required String address,
    required int userId,
    required int wtpId,
    required List<Map<String, dynamic>> parameterData,
  }) async {
    try {
      final data = {
        'SampleDate': sampleDate,
        'AnalysisStartDate': analysisStartDate,
        'AnalysisCompleteDate': analysisCompleteDate,
        'Address': address,
        'UserId': userId,
        'WTPId': wtpId,
        'ParameterData': parameterData,
      };

      final response = await _apiService.saveWTPData(
        token: token,
        data: data,
      );
      
      return response != null;
    } catch (e) {
      if (kDebugMode) print('Error submitting WTP sample: $e');
      return false;
    }
  }

  // Get STP list
  Future<List<Map<String, dynamic>>> getSTPList(String token) async {
    try {
      final response = await _apiService.getSTP(token);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) print('Error fetching STP list: $e');
      return [];
    }
  }

  // Get STP parameters
  Future<List<Map<String, dynamic>>> getSTPParameters(String token) async {
    try {
      final response = await _apiService.getParametersForSTP(token);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) print('Error fetching STP parameters: $e');
      return [];
    }
  }

  // Submit STP data
  Future<bool> submitSTPSample({
    required String token,
    required String sampleDate,
    required String analysisStartDate,
    required String analysisCompleteDate,
    required int stpId,
    required int userId,
    required String address,
    required List<Map<String, dynamic>> parameterData,
  }) async {
    try {
      final data = {
        'SampleDate': sampleDate,
        'AnalysisStartDate': analysisStartDate,
        'AnalysisCompleteDate': analysisCompleteDate,
        'STPId': stpId,
        'UserId': userId,
        'Address': address,
        'ParameterData': parameterData,
      };

      final response = await _apiService.saveSTPData(
        token: token,
        data: data,
      );
      
      return response != null;
    } catch (e) {
      if (kDebugMode) print('Error submitting STP sample: $e');
      return false;
    }
  }

  // Get service station reports
  Future<List<Map<String, dynamic>>> getServiceStationReports({
    required String token,
    required int divisionId,
    required int subDivisionId,
    required int serviceStationId,
    required String reportDate,
  }) async {
    try {
      final response = await _apiService.getServiceStationReportList(
        token: token,
        divisionId: divisionId,
        subDivisionId: subDivisionId,
        serviceStationId: serviceStationId,
        reportDate: reportDate,
      );
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) print('Error fetching service station reports: $e');
      return [];
    }
  }

  // Get service station detailed report
  Future<Map<String, dynamic>?> getServiceStationDetailReport({
    required String token,
    required int sampleId,
  }) async {
    try {
      final response = await _apiService.getServiceStationReportData(
        token: token,
        sampleId: sampleId,
      );
      return response;
    } catch (e) {
      if (kDebugMode) print('Error fetching service station detail report: $e');
      return null;
    }
  }

  // Mock data for development/fallback
  List<Map<String, dynamic>> _getMockServiceStations() {
    return [
      {
        'DivisionId': 1,
        'DivisionName': 'Central',
        'SubDivisions': [
          {
            'SubDivisionId': 1,
            'SubDivisionName': 'Central Sub Div 1',
            'ServiceStations': [
              {
                'ServiceStationId': 1,
                'ServiceStationName': 'Central Station A',
                'Address': 'Central Bangalore',
                'Latitude': 12.9716,
                'Longitude': 77.5946,
              },
              {
                'ServiceStationId': 2,
                'ServiceStationName': 'Central Station B',
                'Address': 'Central Bangalore',
                'Latitude': 12.9716,
                'Longitude': 77.5946,
              },
            ],
          },
        ],
      },
      {
        'DivisionId': 2,
        'DivisionName': 'East-1',
        'SubDivisions': [
          {
            'SubDivisionId': 2,
            'SubDivisionName': 'East-1 Sub Div 1',
            'ServiceStations': [
              {
                'ServiceStationId': 3,
                'ServiceStationName': 'East Station A',
                'Address': 'East Bangalore',
                'Latitude': 12.9716,
                'Longitude': 77.6946,
              },
            ],
          },
        ],
      },
    ];
  }
}