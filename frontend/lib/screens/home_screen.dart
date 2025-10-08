import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../models/vehicle.dart';
import '../theme/app_theme.dart';
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
            AppTheme.infoSnackBar('차량 목록을 불러올 수 없습니다. 차량을 먼저 등록해주세요.'),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.errorSnackBar('데이터를 불러오는 중 오류가 발생했습니다.'),
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
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'DRV-LG',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              '환영합니다, $_userNickname님',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadData,
            tooltip: '새로고침',
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: _logout,
            tooltip: '로그아웃',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    '데이터를 불러오는 중...',
                    style: TextStyle(color: AppTheme.textSecondaryColor),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.primaryColor.withAlpha(15),
                      Colors.white,
                    ],
                    stops: const [0.0, 0.3],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 헤더 섹션
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '내 차량',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '총 ${_vehicles.length}대',
                                style: TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withAlpha(60),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const VehicleRegisterScreen(),
                                  ),
                                );
                                _loadData();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('차량 등록'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 차량 리스트
                    Expanded(
                      child: _vehicles.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.directions_car_outlined,
                                    size: 80,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    '등록된 차량이 없습니다',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppTheme.textSecondaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '새 차량을 등록해보세요',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _vehicles.length,
                              itemBuilder: (context, index) {
                                final vehicle = _vehicles[index];
                                return _buildVehicleCard(vehicle);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildVehicleCard(Vehicle vehicle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade50],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (vehicle.vehicleId != null) {
              _showVehicleOptions(vehicle.vehicleId!);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.directions_car_rounded,
                        color: AppTheme.primaryColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.nickName ?? '${vehicle.maker} ${vehicle.model}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${vehicle.maker} ${vehicle.model} (${vehicle.year})',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        if (vehicle.vehicleId != null) {
                          _showVehicleOptions(vehicle.vehicleId!);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.pin, size: 16, color: AppTheme.textSecondaryColor),
                      const SizedBox(width: 8),
                      Text(
                        vehicle.number,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.speed, size: 16, color: AppTheme.textSecondaryColor),
                      const SizedBox(width: 8),
                      Text(
                        '${vehicle.initOdo} km',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionButton(
                        icon: Icons.local_gas_station_rounded,
                        label: '주유',
                        color: AppTheme.accentColor,
                        onTap: () {
                          if (vehicle.vehicleId != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    FuelRecordsScreen(vehicleId: vehicle.vehicleId!),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildQuickActionButton(
                        icon: Icons.build_rounded,
                        label: '정비',
                        color: AppTheme.warningColor,
                        onTap: () {
                          if (vehicle.vehicleId != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    MaintenanceRecordsScreen(vehicleId: vehicle.vehicleId!),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildQuickActionButton(
                        icon: Icons.notifications_rounded,
                        label: '알림',
                        color: AppTheme.successColor,
                        onTap: () {
                          if (vehicle.vehicleId != null) {
                            _showAlerts(vehicle.vehicleId!);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withAlpha(25),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVehicleOptions(int vehicleId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.local_gas_station_rounded, color: AppTheme.accentColor),
              title: const Text('주유 기록'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FuelRecordsScreen(vehicleId: vehicleId),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.build_rounded, color: AppTheme.warningColor),
              title: const Text('정비 기록'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MaintenanceRecordsScreen(vehicleId: vehicleId),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications_rounded, color: AppTheme.successColor),
              title: const Text('알림'),
              onTap: () {
                Navigator.pop(context);
                _showAlerts(vehicleId);
              },
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
        AppTheme.errorSnackBar('알림을 불러올 수 없습니다.'),
      );
    }
  }
}
