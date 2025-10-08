import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/vehicle.dart';
import '../models/fuel_record.dart';
import '../models/maintenance_record.dart';
import '../models/alert.dart';
import '../models/stats.dart';
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';
  final AuthService _authService = AuthService();

  // 인증 헤더 생성
  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (includeAuth) {
      final token = await _authService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // User APIs
  Future<String> register(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: await _getHeaders(includeAuth: false),
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('회원가입 실패: ${response.body}');
    }
  }

  Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: await _getHeaders(includeAuth: false),
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'] as String;
        return token;
      } else {
        throw Exception('이메일 또는 비밀번호가 올바르지 않습니다.');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('서버와 연결할 수 없습니다.');
    }
  }

  // Vehicle APIs
  Future<String> registerVehicle(Vehicle vehicle) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/vehicles'),
        headers: await _getHeaders(),
        body: jsonEncode(vehicle.toJson()),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 401) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else if (response.statusCode == 400) {
        throw Exception('입력 정보를 확인해주세요.');
      } else if (response.statusCode == 403) {
        throw Exception('권한이 없습니다.');
      } else {
        throw Exception('차량 등록에 실패했습니다.');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('서버와 연결할 수 없습니다.');
    }
  }

  Future<List<Vehicle>> getMyVehicles() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/vehicles'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Vehicle.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else {
        throw Exception('차량 목록을 불러올 수 없습니다.');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('서버와 연결할 수 없습니다.');
    }
  }

  Future<String> deleteVehicle(int vehicleId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/vehicles/$vehicleId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 401) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else if (response.statusCode == 403) {
        throw Exception('삭제할 권한이 없습니다.');
      } else {
        throw Exception('차량 삭제에 실패했습니다.');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('서버와 연결할 수 없습니다.');
    }
  }

  // Alert APIs
  Future<List<Alert>> getAlerts(int vehicleId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/vehicles/$vehicleId/alerts'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Alert.fromJson(json)).toList();
    } else {
      throw Exception('알림 조회 실패: ${response.body}');
    }
  }

  // Fuel Record APIs
  Future<String> createFuelRecord(int vehicleId, FuelRecord record) async {
    final response = await http.post(
      Uri.parse('$baseUrl/vehicles/$vehicleId/fuel-records'),
      headers: await _getHeaders(),
      body: jsonEncode(record.toJson()),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('주유 기록 등록 실패: ${response.body}');
    }
  }

  Future<List<FuelRecord>> getFuelRecords(int vehicleId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/vehicles/$vehicleId/fuel-records'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => FuelRecord.fromJson(json)).toList();
    } else {
      throw Exception('주유 기록 조회 실패: ${response.body}');
    }
  }

  Future<FuelRecord> getFuelRecord(int vehicleId, int recordId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/vehicles/$vehicleId/fuel-records/$recordId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return FuelRecord.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('주유 기록 조회 실패: ${response.body}');
    }
  }

  Future<String> updateFuelRecord(
      int vehicleId, int recordId, FuelRecord record) async {
    final response = await http.put(
      Uri.parse('$baseUrl/vehicles/$vehicleId/fuel-records/$recordId'),
      headers: await _getHeaders(),
      body: jsonEncode(record.toJson()),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('주유 기록 수정 실패: ${response.body}');
    }
  }

  Future<String> deleteFuelRecord(int vehicleId, int recordId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/vehicles/$vehicleId/fuel-records/$recordId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('주유 기록 삭제 실패: ${response.body}');
    }
  }

  // Maintenance Record APIs
  Future<String> createMaintenanceRecord(
      int vehicleId, MaintenanceRecord record) async {
    final response = await http.post(
      Uri.parse('$baseUrl/vehicles/$vehicleId/maintenance-records'),
      headers: await _getHeaders(),
      body: jsonEncode(record.toJson()),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('정비 기록 등록 실패: ${response.body}');
    }
  }

  Future<List<MaintenanceRecord>> getMaintenanceRecords(int vehicleId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/vehicles/$vehicleId/maintenance-records'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => MaintenanceRecord.fromJson(json)).toList();
    } else {
      throw Exception('정비 기록 조회 실패: ${response.body}');
    }
  }

  Future<MaintenanceRecord> getMaintenanceRecord(
      int vehicleId, int recordId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/vehicles/$vehicleId/maintenance-records/$recordId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return MaintenanceRecord.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('정비 기록 조회 실패: ${response.body}');
    }
  }

  Future<String> updateMaintenanceRecord(
      int vehicleId, int recordId, MaintenanceRecord record) async {
    final response = await http.put(
      Uri.parse('$baseUrl/vehicles/$vehicleId/maintenance-records/$recordId'),
      headers: await _getHeaders(),
      body: jsonEncode(record.toJson()),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('정비 기록 수정 실패: ${response.body}');
    }
  }

  Future<String> deleteMaintenanceRecord(int vehicleId, int recordId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/vehicles/$vehicleId/maintenance-records/$recordId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('정비 기록 삭제 실패: ${response.body}');
    }
  }

  // Statistics APIs
  Future<Stats> getMonthlySummary(
      int vehicleId, int year, int month) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/stats/summary/monthly?vehicleId=$vehicleId&year=$year&month=$month'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return Stats.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('통계 조회 실패: ${response.body}');
    }
  }
}
