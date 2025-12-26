import 'dart:convert';
import 'package:http/http.dart' as http;
import '../session/session_manager.dart';
import '../models/service_station_model.dart';
import '../models/parameter_model.dart';

class ApiService {
  static const String baseUrl = 'http://wqms.bwssb.gov.in/api';

  // ===================== LOGIN API =====================
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Useraccess'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
      },
      body:
          'username=$username&password=$password&grant_type=password',
    );

    final data = jsonDecode(response.body);

    if (data['access_token'] != null) {
      await SessionManager.saveSession(
        token: data['access_token'],
        username: data['UserName'],
        userId: data['UserId'].toString(),
        roleId: data['RoleId'].toString(),
      );
    }

    return data;
  }

  // ===================== HOME MAP API =====================
  static Future<List<dynamic>> getGisView({
    required String startDate,
    required String endDate,
  }) async {
    final token = await SessionManager.getToken();

    final url = Uri.parse(
      '$baseUrl/GetGisView?reportStartDate=$startDate&reportEndDate=$endDate',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // API returns JSON string → decode twice
    final decoded = jsonDecode(response.body);
    final data = jsonDecode(decoded);

    return data['ServiceStation'];
  }

  /// SERVICE STATION LIST
  static Future<List<ServiceStation>> getServiceStations() async {
    final token = await SessionManager.getToken();

    final res = await http.get(
      Uri.parse('$baseUrl/GetServiceStation'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final List list = jsonDecode(jsonDecode(res.body));
    return list.map((e) => ServiceStation.fromJson(e)).toList();
  }

  /// PARAMETERS
  static Future<List<Parameter>> getParameters() async {
    final token = await SessionManager.getToken();

    final res = await http.get(
      Uri.parse('$baseUrl/GetParametersForServiceStation'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final List list = jsonDecode(jsonDecode(res.body));
    return list.map((e) => Parameter.fromJson(e)).toList();
  }

  /// SAMPLE ID
  static Future<String> generateSampleId(int stationId) async {
    final token = await SessionManager.getToken();

    final res = await http.get(
      Uri.parse('$baseUrl/GenerateSampleId?id=$stationId&type=0'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(jsonDecode(res.body));
    return data[0]['sampleid'];
  }

  /// SAVE DATA
  static Future<bool> saveServiceStationData(Map<String, dynamic> body) async {
    final token = await SessionManager.getToken();

    final res = await http.post(
      Uri.parse('$baseUrl/SaveServiceStationData'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    return res.statusCode == 200;
  }

  static Future<List<dynamic>> getServiceStationReports({
  required String startDate,
  required String endDate,
}) async {
  final token = await SessionManager.getToken();
  final url =
      '$baseUrl/GetServiceStationReportList?divisionId=0&subDivisionId=0&serviceStationId=0'
      '&reportStartDate=$startDate&reportEndDate=$endDate';

  final res = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );

  final decoded = jsonDecode(res.body);
  return jsonDecode(decoded);
}

static Future<Map<String, dynamic>> getServiceStationReportDetail(String sampleId) async {
  final token = await SessionManager.getToken();
  final res = await http.get(
    Uri.parse('$baseUrl/GetServiceStationReportData?sampleId=$sampleId'),
    headers: {'Authorization': 'Bearer $token'},
  );

  final decoded = jsonDecode(res.body); 
  return jsonDecode(decoded);
}

  // =====================================================
  // ======================= WTP =========================
  // =====================================================

  // ===================== WTP REPORT LIST =====================
  static Future<List<dynamic>> getWTPReports({
    required String startDate,
    required String endDate,
  }) async {
    final token = await SessionManager.getToken();

    final url =
        '$baseUrl/GetWTPReportList'
        '?reportStartDate=$startDate'
        '&reportEndDate=$endDate';

    final res = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    final decoded = jsonDecode(res.body);
    return jsonDecode(decoded);
  }

  // ===================== WTP REPORT DETAIL =====================
static Future<Map<String, dynamic>> getWtpReportDetail({
  required String wtpId,
  required String sampleDate,
}) async {
  final token = await SessionManager.getToken();

  final url =
      '$baseUrl/GetWTPReportData?wtpId=$wtpId&sampleDate=$sampleDate';

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to load WTP report detail');
  }

  // API returns JSON string → decode twice
  final decoded = jsonDecode(response.body);
  return jsonDecode(decoded);
}


 // ===================== WTP REPORT DETAIL =====================
  static Future<Map<String, dynamic>> getWTPReportDetail({
    required String wtpName,
    required String sampleDate,
  }) async {
    final token = await SessionManager.getToken();

    final int wtpId = _mapWtpNameToId(wtpName);

    final String formattedDate =
        sampleDate.replaceAll('T', ' ').substring(0, 16);

    final url =
        '$baseUrl/GetWTPReportData'
        '?wtpId=$wtpId'
        '&sampleDate=$formattedDate';

    final res = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    final decoded = jsonDecode(res.body);
    return jsonDecode(decoded);
  }

  // ===================== WTP NAME → ID =====================
  static int _mapWtpNameToId(String name) {
    switch (name) {
      case 'WTP Stage 1':
        return 1;
      case 'WTP Stage 2':
        return 2;
      case 'WTP Stage 3':
        return 3;
      case 'WTP Stage 4 - Phase 1':
        return 4;
      case 'WTP Stage 4 - Phase 2':
        return 5;
      default:
        throw Exception('Invalid WTP name');
    }
  }

  /// STP LIST
static Future<List<dynamic>> getStpList() async {
  final token = await SessionManager.getToken();
  final res = await http.get(
    Uri.parse('$baseUrl/GetSTP'),
    headers: {'Authorization': 'Bearer $token'},
  );
  return jsonDecode(jsonDecode(res.body));
}

/// STP REPORT LIST
static Future<List<dynamic>> getStpReports({
  required int stpId,
  required String startDate,
  required String endDate,
}) async {
  final token = await SessionManager.getToken();
  final res = await http.get(
    Uri.parse(
        '$baseUrl/GetSTPReportList?stpId=$stpId&reportStartDate=$startDate&reportEndDate=$endDate'),
    headers: {'Authorization': 'Bearer $token'},
  );
  return jsonDecode(jsonDecode(res.body));
}

/// STP REPORT DETAIL
static Future<Map<String, dynamic>> getStpReportDetail(
    String sampleId) async {
  final token = await SessionManager.getToken();
  final res = await http.get(
    Uri.parse('$baseUrl/GetSTPReportData?sampleId=$sampleId'),
    headers: {'Authorization': 'Bearer $token'},
  );
  return jsonDecode(jsonDecode(res.body));
}

// ================= WTP LIST =================
 // ================= WTP LIST =================
static Future<List<dynamic>> getWtpList() async {
  final token = await SessionManager.getToken();

  final res = await http.get(
    Uri.parse('$baseUrl/GetWTP'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (res.statusCode == 200) {
    // 🔴 API RETURNS STRING → DECODE TWICE
    final decoded = jsonDecode(res.body);   // String → dynamic
    final List list = jsonDecode(decoded);  // String → List
    return list;
  } else {
    throw Exception('Failed to load WTP list');
  }
}


// ================= WTP PARAMETERS =================
static Future<List<dynamic>> getWtpParameters() async {
  final token = await SessionManager.getToken();

  final res = await http.get(
    Uri.parse('$baseUrl/GetParametersForWTP'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (res.statusCode == 200) {
    // 🔴 API RETURNS STRING → DECODE TWICE
    final decoded = jsonDecode(res.body);   // String
    final List list = jsonDecode(decoded);  // List<dynamic>
    return list;
  } else {
    throw Exception('Failed to load WTP parameters');
  }
}

    // ================= GENERATE SAMPLE ID =================
  // ================= GENERATE SAMPLE ID =================
static Future<String> generateSampleIdWTP({
  required int id,
  required int type,
}) async {
  final token = await SessionManager.getToken();

  final res = await http.get(
    Uri.parse('$baseUrl/GenerateSampleId?id=$id&type=$type'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (res.statusCode == 200) {
    // 🔴 API RETURNS STRING → DECODE TWICE
    final decoded = jsonDecode(res.body);      // String
    final List list = jsonDecode(decoded);     // List<dynamic>

    return list[0]['sampleid'].toString();
  } else {
    throw Exception('Failed to generate sample id');
  }
}


  
  // ================= SAVE WTP DATA =================
  static Future<void> saveWtpData({required Map<String, dynamic> data}) async {
    final token = await SessionManager.getToken();

    final res = await http.post(
      Uri.parse('$baseUrl/SaveWTPData'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to save WTP data');
    }
  }

    // =====================================================
  // ====================== STP ==========================
  // =====================================================

    /// STP PARAMETERS
  static Future<List<dynamic>> getStpParameters() async {
    final token = await SessionManager.getToken();
    final res = await http.get(
      Uri.parse('$baseUrl/GetParametersForSTP'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load STP parameters');
    }

    return jsonDecode(res.body);
  }
   /// SAVE STP DATA
  static Future<void> saveStpData({
    required Map<String, dynamic> data,
  }) async {
    final token = await SessionManager.getToken();

    final res = await http.post(
      Uri.parse('$baseUrl/SaveSTPData'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to save STP data');
    }
  }

  static Future<String> generateSampleIdSTP({
  required int stpId,
}) async {
  final token = await SessionManager.getToken();

  final res = await http.get(
    Uri.parse(
      '$baseUrl/GenerateSampleId?id=$stpId&type=2', // ✅ type=2 for STP
    ),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (res.statusCode != 200) {
    throw Exception('Failed to generate STP sample id');
  }

  // API returns: [{ "sampleid": "STP/2024/0001" }]
  final List data = jsonDecode(res.body);

  return data.first['sampleid'].toString();
}


 
}
