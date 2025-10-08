import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../models/vehicle.dart';
import 'vehicle_register_screen.dart';
import 'fuel_records_screen.dart';
import 'maintenance_records_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  final _apiService = ApiService();
  String _userNickname = '';
  List<Vehicle> _vehicles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final nickname = await _authService.getUserNickname();
      setState(() {
        _userNickname = nickname ?? '';
      });

      // 차량 목록 조회 시도
      try {
        final vehicles = await _apiService.getMyVehicles();
        setState(() {
          _vehicles = vehicles;
        });
      } catch (vehicleError) {
        // 차량 조회 실패 시 빈 리스트로 처리 (등록된 차량이 없을 수 있음)
        setState(() {
          _vehicles = [];
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('차량 목록을 불러올 수 없습니다. 차량을 먼저 등록해주세요.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('데이터를 불러오는 중 오류가 발생했습니다.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _logout() async {
    await _authService.logout();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('환영합니다, $_userNickname님'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '내 차량',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const VehicleRegisterScreen(),
                            ),
                          );
                          _loadData();
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('차량 등록'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _vehicles.isEmpty
                        ? const Center(
                            child: Text('등록된 차량이 없습니다.'),
                          )
                        : ListView.builder(
                            itemCount: _vehicles.length,
                            itemBuilder: (context, index) {
                              final vehicle = _vehicles[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: const Icon(Icons.directions_car,
                                      size: 40),
                                  title: Text(
                                    vehicle.nickName ??
                                        '${vehicle.maker} ${vehicle.model}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${vehicle.maker} ${vehicle.model} (${vehicle.year})\n차량번호: ${vehicle.number}',
                                  ),
                                  trailing: PopupMenuButton(
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'fuel',
                                        child: Text('주유 기록'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'maintenance',
                                        child: Text('정비 기록'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'alerts',
                                        child: Text('알림'),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      if (vehicle.vehicleId == null) return;

                                      switch (value) {
                                        case 'fuel':
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FuelRecordsScreen(
                                                      vehicleId:
                                                          vehicle.vehicleId!),
                                            ),
                                          );
                                          break;
                                        case 'maintenance':
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MaintenanceRecordsScreen(
                                                      vehicleId:
                                                          vehicle.vehicleId!),
                                            ),
                                          );
                                          break;
                                        case 'alerts':
                                          _showAlerts(vehicle.vehicleId!);
                                          break;
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  void _showAlerts(int vehicleId) async {
    try {
      final alerts = await _apiService.getAlerts(vehicleId);
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('차량 알림'),
          content: SizedBox(
            width: double.maxFinite,
            child: alerts.isEmpty
                ? const Text('알림이 없습니다.')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: alerts.length,
                    itemBuilder: (context, index) {
                      final alert = alerts[index];
                      Color statusColor;
                      switch (alert.status.name) {
                        case 'GOOD':
                          statusColor = Colors.green;
                          break;
                        case 'WARN':
                          statusColor = Colors.orange;
                          break;
                        case 'DANGER':
                          statusColor = Colors.red;
                          break;
                        default:
                          statusColor = Colors.grey;
                      }
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(
                            Icons.warning,
                            color: statusColor,
                          ),
                          title: Text(alert.itemName),
                          subtitle: Text(alert.message),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('알림을 불러올 수 없습니다.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
