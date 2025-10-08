import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  final _authService = AuthService();
  final _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    Widget targetScreen = const LoginScreen();

    // refreshToken이 있으면 자동 로그인 시도
    final refreshToken = await _authService.getRefreshToken();
    if (refreshToken != null) {
      try {
        // refreshToken으로 새 accessToken 발급
        final response = await _apiService.refreshAccessToken(refreshToken);

        // 새 토큰 저장
        await _authService.saveToken(response['accessToken']!);
        await _authService.saveRefreshToken(response['refreshToken']!);

        // 자동 로그인 성공 - HomeScreen으로 이동
        targetScreen = const HomeScreen();
      } catch (e) {
        // refreshToken이 만료되었거나 유효하지 않음 - 로그아웃 처리
        await _authService.logout();
        targetScreen = const LoginScreen();
      }
    } else {
      // refreshToken이 없으면 일반 accessToken 확인
      final token = await _authService.getToken();
      if (token != null) {
        targetScreen = const HomeScreen();
      }
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    children: [
                      Icon(
                        Icons.directions_car_rounded,
                        size: 120,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'DRV-LG',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '당신의 차량 관리 파트너',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withAlpha(230),
                              letterSpacing: 1,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),
              FadeTransition(
                opacity: _fadeAnimation,
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
