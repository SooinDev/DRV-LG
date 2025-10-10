import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/vehicle.dart';
import '../theme/app_theme.dart';

class VehicleRegisterScreen extends StatefulWidget {
  final Vehicle? vehicle;

  const VehicleRegisterScreen({super.key, this.vehicle});

  @override
  State<VehicleRegisterScreen> createState() => _VehicleRegisterScreenState();
}

class _VehicleRegisterScreenState extends State<VehicleRegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _makerController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _nickNameController = TextEditingController();
  final _initOdoController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();

    // 수정 모드인 경우 기존 값 설정
    if (widget.vehicle != null) {
      _numberController.text = widget.vehicle!.number;
      _makerController.text = widget.vehicle!.maker;
      _modelController.text = widget.vehicle!.model;
      _yearController.text = widget.vehicle!.year.toString();
      _nickNameController.text = widget.vehicle!.nickName ?? '';
      _initOdoController.text = widget.vehicle!.initOdo.toString();
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _makerController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _nickNameController.dispose();
    _initOdoController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _saveVehicle() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final vehicle = Vehicle(
        vehicleId: widget.vehicle?.vehicleId,
        number: _numberController.text,
        maker: _makerController.text,
        model: _modelController.text,
        year: int.parse(_yearController.text),
        nickName: _nickNameController.text.isEmpty
            ? null
            : _nickNameController.text,
        initOdo: int.parse(_initOdoController.text),
      );

      if (widget.vehicle != null) {
        // 수정 모드
        await _apiService.updateVehicle(widget.vehicle!.vehicleId!, vehicle);
      } else {
        // 등록 모드
        await _apiService.registerVehicle(vehicle);
      }

      if (mounted) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final message = widget.vehicle != null ? '차량 정보가 수정되었습니다' : '차량이 등록되었습니다';
        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.successSnackBar(message, isDark: isDark),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = widget.vehicle != null ? '차량 정보 수정에 실패했습니다.' : '차량 등록에 실패했습니다.';
        if (e.toString().contains('Exception:')) {
          errorMessage = e.toString().replaceAll('Exception: ', '');
        }
        final isDark = Theme.of(context).brightness == Brightness.dark;
        ScaffoldMessenger.of(context).showSnackBar(
          AppTheme.errorSnackBar(errorMessage, isDark: isDark),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 프리미엄 앱바
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppTheme.darkCard.withOpacity(0.5)
                      : Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: isDark
                        ? AppTheme.darkTextPrimary
                        : AppTheme.lightTextPrimary,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                Icons.directions_car_filled_rounded,
                                color:
                                    isDark ? AppTheme.darkBackground : Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.vehicle != null ? '차량 정보 수정' : '새 차량 등록',
                                    style: TextStyle(
                                      color:
                                          isDark ? AppTheme.darkBackground : Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.8,
                                      height: 1.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.vehicle != null ? '차량 정보를 수정해주세요' : '차량 정보를 입력해주세요',
                                    style: TextStyle(
                                      color: (isDark
                                              ? AppTheme.darkBackground
                                              : Colors.white)
                                          .withOpacity(0.85),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      height: 1.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 폼 컨텐츠
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _animationController,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeOut,
                )),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 차량 번호
                        _buildInputCard(
                          icon: Icons.confirmation_number_rounded,
                          label: '차량 번호',
                          child: TextFormField(
                            controller: _numberController,
                            decoration: InputDecoration(
                              hintText: '예: 12가 3456',
                              prefixIcon: Icon(
                                Icons.confirmation_number_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '차량 번호를 입력하세요';
                              }
                              return null;
                            },
                          ),
                          isDark: isDark,
                        ),
                        const SizedBox(height: 16),

                        // 제조사 & 모델
                        Row(
                          children: [
                            Expanded(
                              child: _buildInputCard(
                                icon: Icons.business_rounded,
                                label: '제조사',
                                child: TextFormField(
                                  controller: _makerController,
                                  decoration: InputDecoration(
                                    hintText: '예: 현대',
                                    prefixIcon: Icon(
                                      Icons.business_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '제조사를 입력하세요';
                                    }
                                    return null;
                                  },
                                ),
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInputCard(
                                icon: Icons.drive_eta_rounded,
                                label: '모델',
                                child: TextFormField(
                                  controller: _modelController,
                                  decoration: InputDecoration(
                                    hintText: '예: 소나타',
                                    prefixIcon: Icon(
                                      Icons.drive_eta_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '모델을 입력하세요';
                                    }
                                    return null;
                                  },
                                ),
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // 연식 & 주행거리
                        Row(
                          children: [
                            Expanded(
                              child: _buildInputCard(
                                icon: Icons.calendar_today_rounded,
                                label: '연식',
                                child: TextFormField(
                                  controller: _yearController,
                                  decoration: InputDecoration(
                                    hintText: '예: 2023',
                                    prefixIcon: Icon(
                                      Icons.calendar_today_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '연식을 입력하세요';
                                    }
                                    return null;
                                  },
                                ),
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInputCard(
                                icon: Icons.speed_rounded,
                                label: '초기 주행거리',
                                child: TextFormField(
                                  controller: _initOdoController,
                                  decoration: InputDecoration(
                                    hintText: '예: 50000',
                                    prefixIcon: Icon(
                                      Icons.speed_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    suffixText: 'km',
                                  ),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '주행거리를 입력하세요';
                                    }
                                    return null;
                                  },
                                ),
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // 차량 별칭
                        _buildInputCard(
                          icon: Icons.label_rounded,
                          label: '차량 별칭 (선택사항)',
                          child: TextFormField(
                            controller: _nickNameController,
                            decoration: InputDecoration(
                              hintText: '예: 내 애마',
                              prefixIcon: Icon(
                                Icons.label_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                          ),
                          isDark: isDark,
                        ),
                        const SizedBox(height: 32),

                        // 등록 버튼
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: isDark
                                  ? [
                                      AppTheme.darkPrimary,
                                      AppTheme.darkSecondary
                                    ]
                                  : [
                                      AppTheme.lightPrimary,
                                      AppTheme.lightSecondary
                                    ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (isDark
                                        ? AppTheme.darkPrimary
                                        : AppTheme.lightPrimary)
                                    .withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _isLoading ? null : _saveVehicle,
                              borderRadius: BorderRadius.circular(16),
                              child: Center(
                                child: _isLoading
                                    ? SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            isDark
                                                ? AppTheme.darkBackground
                                                : Colors.white,
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            widget.vehicle != null ? Icons.check_circle_rounded : Icons.add_circle_rounded,
                                            color: isDark
                                                ? AppTheme.darkBackground
                                                : Colors.white,
                                            size: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            widget.vehicle != null ? '수정 완료' : '차량 등록하기',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.3,
                                              color: isDark
                                                  ? AppTheme.darkBackground
                                                  : Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard({
    required IconData icon,
    required String label,
    required Widget child,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.lightTextSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppTheme.darkTextSecondary
                      : AppTheme.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
        child,
      ],
    );
  }
}
