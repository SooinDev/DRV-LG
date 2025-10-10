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
  bool _isRefreshing = false;

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

  // 토큰 갱신 (public - SplashScreen에서도 사용)
  Future<Map<String, String>> refreshAccessToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/reissue'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'accessToken': data['accessToken'] as String,
        'refreshToken': data['refreshToken'] as String,
      };
    } else {
      throw Exception('토큰 갱신 실패');
    }
  }

  // 토큰 갱신 (내부용)
  Future<bool> _refreshToken() async {
    if (_isRefreshing) return false;
    _isRefreshing = true;

    try {
      final refreshToken = await _authService.getRefreshToken();
      if (refreshToken == null) return false;

      final tokens = await refreshAccessToken(refreshToken);
      await _authService.saveToken(tokens['accessToken']!);
      await _authService.saveRefreshToken(tokens['refreshToken']!);
      return true;
    } catch (e) {
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  // HTTP 요청 래퍼 (자동 토큰 갱신)
  Future<http.Response> _requestWithAuth(
    Future<http.Response> Function() request,
  ) async {
    var response = await request();

    // 401 에러 시 토큰 갱신 후 재시도
    if (response.statusCode == 401) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        response = await request();
      } else {
        // 토큰 갱신 실패 시 로그아웃
        await _authService.logout();
        throw Exception('인증이 만료되었습니다. 다시 로그인해주세요.');
      }
    }

    return response;
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

  Future<Map<String, String>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: await _getHeaders(includeAuth: false),
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'accessToken': data['accessToken'] as String,
          'refreshToken': data['refreshToken'] as String,
        };
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

  // 현재 사용자 정보 조회
  Future<User> getCurrentUser() async {
    try {
      final headers = await _getHeaders();
      final response = await _requestWithAuth(() => http.get(
            Uri.parse('$baseUrl/users/me'),
            headers: headers,
          ));

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 403) {
        throw Exception('권한이 없습니다.');
      } else {
        throw Exception('사용자 정보를 불러올 수 없습니다.');
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
      final headers = await _getHeaders();
      final response = await _requestWithAuth(() => http.post(
            Uri.parse('$baseUrl/vehicles'),
            headers: headers,
            body: jsonEncode(vehicle.toJson()),
          ));

      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 400) {
        if (response.body.contains('Duplicate entry') &&
            response.body.contains('UK_vehicle_license_plate')) {
          throw Exception('이미 등록된 차량 번호입니다.');
        }
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
      final headers = await _getHeaders();
      final response = await _requestWithAuth(() => http.get(
            Uri.parse('$baseUrl/vehicles'),
            headers: headers,
          ));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Vehicle.fromJson(json)).toList();
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

  Future<String> updateVehicle(int vehicleId, Vehicle vehicle) async {
    try {
      final headers = await _getHeaders();
      final response = await _requestWithAuth(() => http.put(
            Uri.parse('$baseUrl/vehicles/$vehicleId'),
            headers: headers,
            body: jsonEncode(vehicle.toJson()),
          ));

      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 403) {
        throw Exception('수정할 권한이 없습니다.');
      } else {
        throw Exception('차량 정보 수정에 실패했습니다.');
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
      final headers = await _getHeaders();
      final response = await _requestWithAuth(() => http.delete(
            Uri.parse('$baseUrl/vehicles/$vehicleId'),
            headers: headers,
          ));

      if (response.statusCode == 200) {
        return response.body;
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
    try {
      final headers = await _getHeaders();
      final response = await _requestWithAuth(() => http.get(
            Uri.parse('$baseUrl/vehicles/$vehicleId/alerts'),
            headers: headers,
          ));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Alert.fromJson(json)).toList();
      } else if (response.statusCode == 403) {
        throw Exception('권한이 없습니다.');
      } else {
        throw Exception('알림 조회 실패: ${response.body}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('서버와 연결할 수 없습니다.');
    }
  }

  // Fuel Record APIs
  Future<String> createFuelRecord(int vehicleId, FuelRecord record) async {
    try {
      final headers = await _getHeaders();
      final response = await _requestWithAuth(() => http.post(
            Uri.parse('$baseUrl/vehicles/$vehicleId/fuel-records'),
            headers: headers,
            body: jsonEncode(record.toJson()),
          ));

      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 403) {
        throw Exception('권한이 없습니다.');
      } else {
        throw Exception('주유 기록 등록 실패: ${response.body}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('서버와 연결할 수 없습니다.');
    }
  }

  Future<List<FuelRecord>> getFuelRecords(int vehicleId) async {
    try {
      final headers = await _getHeaders();
      final response = await _requestWithAuth(() => http.get(
            Uri.parse('$baseUrl/vehicles/$vehicleId/fuel-records'),
            headers: headers,
          ));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => FuelRecord.fromJson(json)).toList();
      } else if (response.statusCode == 403) {
        throw Exception('권한이 없습니다.');
      } else {
        throw Exception('주유 기록 조회 실패: ${response.body}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('서버와 연결할 수 없습니다.');
    }
  }

  Future<FuelRecord> getFuelRecord(int vehicleId, int recordId) async {
    try {
      final headers = await _getHeaders();
      final response = await _requestWithAuth(() => http.get(
            Uri.parse('$baseUrl/vehicles/$vehicleId/fuel-records/$recordId'),
            headers: headers,
          ));

      if (response.statusCode == 200) {
        return FuelRecord.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 403) {
        throw Exception('권한이 없습니다.');
      } else {
        throw Exception('주유 기록 조회 실패: ${response.body}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('서버와 연결할 수 없습니다.');
    }
  }

  Future<String> updateFuelRecord(
      int vehicleId, int recordId, FuelRecord record) async {
    try {
      final headers = await _getHeaders();
      final response = await _requestWithAuth(() => http.put(
            Uri.parse('$baseUrl/vehicles/$vehicleId/fuel-records/$recordId'),
            headers: headers,
            body: jsonEncode(record.toJson()),
          ));

      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 403) {
        throw Exception('권한이 없습니다.');
      } else {
        throw Exception('주유 기록 수정 실패: ${response.body}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('서버와 연결할 수 없습니다.');
    }
  }

  Future<String> deleteFuelRecord(int vehicleId, int recordId) async {
    try {
      final headers = await _getHeaders();
      final response = await _requestWithAuth(() => http.delete(
            Uri.parse('$baseUrl/vehicles/$vehicleId/fuel-records/$recordId'),
            headers: headers,
          ));

      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 403) {
        throw Exception('권한이 없습니다.');
      } else {
        throw Exception('주유 기록 삭제 실패: ${response.body}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('서버와 연결할 수 없습니다.');
    }
  }

  // Maintenance Record APIs
  Future<String> createMaintenanceRecord(
      int vehicleId, MaintenanceRecord record) async {
    try {
      final headers = await _getHeaders();
      final response = await _requestWithAuth(() => http.post(
            Uri.parse('$baseUrl/vehicles/$vehicleId/maintenance-records'),
            headers: headers,
            body: jsonEncode(record.toJson()),
          ));

      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 403) {
        throw Exception('권한이 없습니다.');
      } else {
        throw Exception('정비 기록 등록 실패: ${response.body}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('서버와 연결할 수 없습니다.');
    }
  }

  Future<List<MaintenanceRecord>> getMaintenanceRecords(int vehicleId) async {
    try {
      final headers = await _getHeaders();
      final response = await _requestWithAuth(() => http.get(
            Uri.parse('$baseUrl/vehicles/$vehicleId/maintenance-records'),
            headers: headers,
          ));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => MaintenanceRecord.fromJson(json)).toList();
      } else if (response.statusCode == 403) {
        throw Exception('권한이 없습니다.');
      } else {
        throw Exception('정비 기록 조회 실패: ${response.body}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('서버와 연결할 수 없습니다.');
    }
  }

  Future<MaintenanceRecord> getMaintenanceRecord(
      int vehicleId, int recordId) async {
    try {
      final headers = await _getHeaders();
      final response = await _requestWithAuth(() => http.get(
            Uri.parse('$baseUrl/vehicles/$vehicleId/maintenance-records/$recordId'),
            headers: headers,
          ));

      if (response.statusCode == 200) {
        return MaintenanceRecord.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 403) {
        throw Exception('권한이 없습니다.');
      } else {
        throw Exception('정비 기록 조회 실패: ${response.body}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('서버와 연결할 수 없습니다.');
    }
  }

  Future<String> updateMaintenanceRecord(
      int vehicleId, int recordId, MaintenanceRecord record) async {
    try {
      final headers = await _getHeaders();
      final response = await _requestWithAuth(() => http.put(
            Uri.parse('$baseUrl/vehicles/$vehicleId/maintenance-records/$recordId'),
            headers: headers,
            body: jsonEncode(record.toJson()),
          ));

      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 403) {
        throw Exception('권한이 없습니다.');
      } else {
        throw Exception('정비 기록 수정 실패: ${response.body}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('서버와 연결할 수 없습니다.');
    }
  }

  Future<String> deleteMaintenanceRecord(int vehicleId, int recordId) async {
    try {
      final headers = await _getHeaders();
      final response = await _requestWithAuth(() => http.delete(
            Uri.parse('$baseUrl/vehicles/$vehicleId/maintenance-records/$recordId'),
            headers: headers,
          ));

      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 403) {
        throw Exception('권한이 없습니다.');
      } else {
        throw Exception('정비 기록 삭제 실패: ${response.body}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('서버와 연결할 수 없습니다.');
    }
  }

  // Statistics APIs
  Future<Stats> getMonthlySummary(
      int vehicleId, int year, int month) async {
    try {
      final headers = await _getHeaders();
      final response = await _requestWithAuth(() => http.get(
            Uri.parse(
                '$baseUrl/stats/summary/monthly?vehicleId=$vehicleId&year=$year&month=$month'),
            headers: headers,
          ));

      if (response.statusCode == 200) {
        return Stats.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 403) {
        throw Exception('권한이 없습니다.');
      } else {
        throw Exception('통계 조회 실패: ${response.body}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('서버와 연결할 수 없습니다.');
    }
  }
}
