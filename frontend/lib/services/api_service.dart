import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/vehicle.dart';
import '../models/fuel_record.dart';
import '../models/maintenance_record.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  // User APIs
  Future<String> register(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('회원가입 실패: ${response.body}');
    }
  }

  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('로그인 실패: ${response.body}');
    }
  }

  // Vehicle APIs
  Future<String> registerVehicle(Vehicle vehicle) async {
    final response = await http.post(
      Uri.parse('$baseUrl/vehicles/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehicle.toJson()),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('차량 등록 실패: ${response.body}');
    }
  }

  // Fuel Record APIs
  Future<String> createFuelRecord(int vehicleId, FuelRecord record) async {
    final response = await http.post(
      Uri.parse('$baseUrl/vehicles/$vehicleId/fuel-records'),
      headers: {'Content-Type': 'application/json'},
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
      headers: {'Content-Type': 'application/json'},
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
      headers: {'Content-Type': 'application/json'},
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
      headers: {'Content-Type': 'application/json'},
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
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('정비 기록 삭제 실패: ${response.body}');
    }
  }
}
