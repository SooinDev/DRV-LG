import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../services/theme_service.dart';
import '../models/vehicle.dart';
import '../models/alert.dart';
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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _authService = AuthService();
  final _apiService = ApiService();
  String _userNickname = '';
  List<Vehicle> _vehicles = [];
  bool _isLoading = true;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _loadData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final nickname = await _authService.getUserNickname();
      setState(() {
        _userNickname = nickname ?? '';
      });

      try {
        final vehicles = await _apiService.getMyVehicles();
        setState(() {
          _vehicles = vehicles;
        });
      } catch (vehicleError) {
        setState(() {
          _vehicles = [];
        });
      }
    } catch (e) {
      if (mounted) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.errorSnackBar('데이터를 불러오는 중 오류가 발생했습니다.', isDark: isDark),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        _fadeController.forward();
        _slideController.forward();
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '데이터를 불러오는 중...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary,
                        ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              color: Theme.of(context).colorScheme.primary,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // 프리미엄 헤더
                  SliverToBoxAdapter(
                    child: FadeTransition(
                      opacity: _fadeController,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                                ? [AppTheme.darkPrimary, AppTheme.darkSecondary]
                                : [AppTheme.lightPrimary, AppTheme.lightSecondary],
                          ),
                        ),
                        child: SafeArea(
                          bottom: false,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 상단 바 (로고, 다크모드, 로그아웃)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.directions_car_rounded,
                                            color: isDark
                                                ? AppTheme.darkBackground
                                                : Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'DRV-LG',
                                          style: TextStyle(
                                            color: isDark
                                                ? AppTheme.darkBackground
                                                : Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        // 다크모드 토글
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: IconButton(
                                            onPressed: () => themeService.toggleTheme(),
                                            icon: Icon(
                                              isDark
                                                  ? Icons.light_mode_rounded
                                                  : Icons.dark_mode_rounded,
                                              color: isDark
                                                  ? AppTheme.darkBackground
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // 새로고침
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: IconButton(
                                            onPressed: _loadData,
                                            icon: Icon(
                                              Icons.refresh_rounded,
                                              color: isDark
                                                  ? AppTheme.darkBackground
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // 로그아웃
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: IconButton(
                                            onPressed: _logout,
                                            icon: Icon(
                                              Icons.logout_rounded,
                                              color: isDark
                                                  ? AppTheme.darkBackground
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                // 환영 메시지
                                Text(
                                  '안녕하세요,',
                                  style: TextStyle(
                                    color: (isDark
                                            ? AppTheme.darkBackground
                                            : Colors.white)
                                        .withOpacity(0.9),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$_userNickname님',
                                  style: TextStyle(
                                    color: isDark
                                        ? AppTheme.darkBackground
                                        : Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -1,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // 차량 통계
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '등록된 차량',
                                              style: TextStyle(
                                                color: (isDark
                                                        ? AppTheme.darkBackground
                                                        : Colors.white)
                                                    .withOpacity(0.8),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '${_vehicles.length}대',
                                              style: TextStyle(
                                                color: isDark
                                                    ? AppTheme.darkBackground
                                                    : Colors.white,
                                                fontSize: 28,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Icon(
                                          Icons.directions_car_filled_rounded,
                                          color: isDark
                                              ? AppTheme.darkBackground
                                              : Colors.white,
                                          size: 32,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 차량 추가 버튼
                  SliverToBoxAdapter(
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _slideController,
                        curve: Curves.easeOut,
                      )),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const VehicleRegisterScreen(),
                              ),
                            );
                            _loadData();
                          },
                          icon: const Icon(Icons.add_rounded, size: 24),
                          label: const Text('새 차량 등록'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 20),
                            elevation: 0,
                            shadowColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 차량 목록
                  if (_vehicles.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: FadeTransition(
                          opacity: _fadeController,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppTheme.darkPrimary.withOpacity(0.1)
                                      : AppTheme.lightPrimary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.directions_car_outlined,
                                  size: 80,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                '등록된 차량이 없습니다',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '새 차량을 등록해보세요',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: isDark
                                          ? AppTheme.darkTextSecondary
                                          : AppTheme.lightTextSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(0, 0.1 * (index + 1)),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: _slideController,
                                curve: Interval(
                                  index * 0.1,
                                  1.0,
                                  curve: Curves.easeOut,
                                ),
                              )),
                              child: FadeTransition(
                                opacity: _fadeController,
                                child: _buildPremiumVehicleCard(
                                    _vehicles[index], isDark),
                              ),
                            );
                          },
                          childCount: _vehicles.length,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildPremiumVehicleCard(Vehicle vehicle, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : AppTheme.lightPrimary)
                .withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            if (vehicle.vehicleId != null) {
              _showVehicleOptions(vehicle.vehicleId!, isDark);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 헤더
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [AppTheme.darkPrimary, AppTheme.darkSecondary]
                              : [
                                  AppTheme.lightPrimary,
                                  AppTheme.lightSecondary
                                ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: (isDark
                                    ? AppTheme.darkPrimary
                                    : AppTheme.lightPrimary)
                                .withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.directions_car_filled_rounded,
                        color: isDark ? AppTheme.darkBackground : Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.nickName ?? '${vehicle.maker} ${vehicle.model}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${vehicle.maker} ${vehicle.model} (${vehicle.year})',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: isDark
                                      ? AppTheme.darkTextSecondary
                                      : AppTheme.lightTextSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: isDark
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary,
                        ),
                        onPressed: () {
                          if (vehicle.vehicleId != null) {
                            _showVehicleOptions(vehicle.vehicleId!, isDark);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 정보 카드
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppTheme.darkBackground.withOpacity(0.5)
                        : AppTheme.lightBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.confirmation_number_rounded,
                        size: 20,
                        color: isDark
                            ? AppTheme.darkTextSecondary
                            : AppTheme.lightTextSecondary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        vehicle.number,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.speed_rounded,
                        size: 20,
                        color: isDark
                            ? AppTheme.darkTextSecondary
                            : AppTheme.lightTextSecondary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${vehicle.currentOdometer ?? vehicle.initOdo} km',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 액션 버튼들
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.local_gas_station_rounded,
                        label: '주유',
                        color: isDark
                            ? AppTheme.darkAccent
                            : AppTheme.lightAccent,
                        isDark: isDark,
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.build_rounded,
                        label: '정비',
                        color: isDark
                            ? AppTheme.darkWarning
                            : AppTheme.lightWarning,
                        isDark: isDark,
                        onTap: () {
                          if (vehicle.vehicleId != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MaintenanceRecordsScreen(
                                    vehicleId: vehicle.vehicleId!),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.notifications_rounded,
                        label: '알림',
                        color: isDark
                            ? AppTheme.darkSuccess
                            : AppTheme.lightSuccess,
                        isDark: isDark,
                        onTap: () {
                          if (vehicle.vehicleId != null) {
                            _showAlerts(vehicle.vehicleId!, isDark);
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: color,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVehicleOptions(int vehicleId, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.2)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.lightAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.local_gas_station_rounded,
                    color: isDark
                        ? AppTheme.darkAccent
                        : AppTheme.lightAccent),
              ),
              title: const Text('주유 기록',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              trailing: const Icon(Icons.chevron_right_rounded),
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
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.lightWarning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.build_rounded,
                    color: isDark
                        ? AppTheme.darkWarning
                        : AppTheme.lightWarning),
              ),
              title: const Text('정비 기록',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        MaintenanceRecordsScreen(vehicleId: vehicleId),
                  ),
                );
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.lightSuccess.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.notifications_rounded,
                    color: isDark
                        ? AppTheme.darkSuccess
                        : AppTheme.lightSuccess),
              ),
              title: const Text('알림',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(context);
                _showAlerts(vehicleId, isDark);
              },
            ),
            const Divider(height: 32),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.lightError.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.delete_rounded,
                    color:
                        isDark ? AppTheme.darkError : AppTheme.lightError),
              ),
              title: Text('차량 삭제',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppTheme.darkError
                          : AppTheme.lightError)),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteVehicle(vehicleId, isDark);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteVehicle(int vehicleId, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('차량 삭제',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content:
            const Text('이 차량을 삭제하시겠습니까?\n관련된 모든 기록이 함께 삭제됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteVehicle(vehicleId, isDark);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDark ? AppTheme.darkError : AppTheme.lightError,
              foregroundColor:
                  isDark ? AppTheme.darkBackground : Colors.white,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteVehicle(int vehicleId, bool isDark) async {
    try {
      await _apiService.deleteVehicle(vehicleId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.successSnackBar('차량이 삭제되었습니다.', isDark: isDark),
        );
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = '차량 삭제에 실패했습니다.';
        if (e.toString().contains('Exception:')) {
          errorMessage = e.toString().replaceAll('Exception: ', '');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.errorSnackBar(errorMessage, isDark: isDark),
        );
      }
    }
  }

  void _showAlerts(int vehicleId, bool isDark) async {
    try {
      final alerts = await _apiService.getAlerts(vehicleId);
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('차량 알림',
              style: TextStyle(fontWeight: FontWeight.w700)),
          content: SizedBox(
            width: double.maxFinite,
            child: alerts.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: Text('알림이 없습니다.',
                          style: TextStyle(fontSize: 16)),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: alerts.length,
                    itemBuilder: (context, index) {
                      final alert = alerts[index];
                      Color statusColor;
                      switch (alert.status.name) {
                        case 'GOOD':
                          statusColor = isDark
                              ? AppTheme.darkSuccess
                              : AppTheme.lightSuccess;
                          break;
                        case 'WARN':
                          statusColor = isDark
                              ? AppTheme.darkWarning
                              : AppTheme.lightWarning;
                          break;
                        case 'DANGER':
                          statusColor =
                              isDark ? AppTheme.darkError : AppTheme.lightError;
                          break;
                        default:
                          statusColor = isDark
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary;
                      }
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: statusColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.warning_rounded,
                                color: statusColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    alert.itemName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    alert.message,
                                    style: TextStyle(
                                      color: isDark
                                          ? AppTheme.darkTextSecondary
                                          : AppTheme.lightTextSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
        AppTheme.errorSnackBar('알림을 불러올 수 없습니다.', isDark: isDark),
      );
    }
  }
}
