import 'package:flutter/material.dart';

class AppTheme {
  // 라이트 테마 색상 - 프리미엄 디자인 시스템
  static const Color lightPrimary = Color(0xFF6366F1); // Indigo 500 - 더 모던한 느낌
  static const Color lightSecondary = Color(0xFFA855F7); // Purple 500
  static const Color lightAccent = Color(0xFF06B6D4); // Cyan 500
  static const Color lightSuccess = Color(0xFF10B981); // Emerald 500
  static const Color lightWarning = Color(0xFFF59E0B); // Amber 500
  static const Color lightError = Color(0xFFEF4444); // Red 500
  static const Color lightBackground = Color(0xFFF8FAFC); // Slate 50
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF1F5F9); // Slate 100
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate 900
  static const Color lightTextSecondary = Color(0xFF64748B); // Slate 500
  static const Color lightBorder = Color(0xFFE2E8F0); // Slate 200
  static const Color lightDivider = Color(0xFFF1F5F9); // Slate 100

  // 추가 액센트 컬러
  static const Color lightInfo = Color(0xFF3B82F6); // Blue 500
  static const Color lightPink = Color(0xFFEC4899); // Pink 500
  static const Color lightOrange = Color(0xFFF97316); // Orange 500

  // 다크 테마 색상 - 프리미엄 다크 디자인
  static const Color darkPrimary = Color(0xFF818CF8); // Indigo 400
  static const Color darkSecondary = Color(0xFFC084FC); // Purple 400
  static const Color darkAccent = Color(0xFF22D3EE); // Cyan 400
  static const Color darkSuccess = Color(0xFF34D399); // Emerald 400
  static const Color darkWarning = Color(0xFFFBBF24); // Amber 400
  static const Color darkError = Color(0xFFF87171); // Red 400
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkCard = Color(0xFF1E293B); // Slate 800
  static const Color darkSurface = Color(0xFF334155); // Slate 700
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color darkBorder = Color(0xFF334155); // Slate 700
  static const Color darkDivider = Color(0xFF1E293B); // Slate 800

  // 추가 액센트 컬러
  static const Color darkInfo = Color(0xFF60A5FA); // Blue 400
  static const Color darkPink = Color(0xFFF472B6); // Pink 400
  static const Color darkOrange = Color(0xFFFB923C); // Orange 400

  // 라이트 테마
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        secondary: lightSecondary,
        tertiary: lightAccent,
        error: lightError,
        surface: lightCard,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextPrimary,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: lightBackground,

      // AppBar
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: lightBackground,
        foregroundColor: lightTextPrimary,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: lightTextPrimary, size: 24),
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
          height: 1.2,
        ),
      ),

      // Card - 프리미엄 디자인
      cardTheme: CardThemeData(
        elevation: 0,
        color: lightCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: lightBorder, width: 1.5),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shadowColor: lightPrimary.withOpacity(0.1),
      ),

      // ElevatedButton - 프리미엄 버튼
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
          shadowColor: lightPrimary.withOpacity(0.3),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: const BorderSide(color: lightPrimary, width: 2),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // InputDecoration - 프리미엄 입력 필드
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: lightBorder, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: lightBorder, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: lightPrimary, width: 3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: lightError, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: lightError, width: 3),
        ),
        labelStyle: const TextStyle(
          color: lightTextSecondary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        floatingLabelStyle: const TextStyle(
          color: lightPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        hintStyle: TextStyle(
          color: lightTextSecondary.withOpacity(0.5),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),

      // FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: lightPrimary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return lightPrimary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: lightTextPrimary,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
      ),

      // Text - 프리미엄 타이포그래피
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          color: lightTextPrimary,
          letterSpacing: -1.5,
          height: 1.1,
        ),
        displayMedium: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          color: lightTextPrimary,
          letterSpacing: -1.2,
          height: 1.1,
        ),
        displaySmall: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: lightTextPrimary,
          letterSpacing: -1,
          height: 1.2,
        ),
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: lightTextPrimary,
          letterSpacing: -0.8,
          height: 1.2,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: lightTextPrimary,
          letterSpacing: -0.5,
          height: 1.3,
        ),
        headlineSmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: lightTextPrimary,
          letterSpacing: -0.3,
          height: 1.3,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: lightTextPrimary,
          letterSpacing: -0.2,
          height: 1.3,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: lightTextPrimary,
          letterSpacing: 0,
          height: 1.4,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: lightTextPrimary,
          letterSpacing: 0,
          height: 1.4,
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: lightTextPrimary,
          height: 1.6,
          letterSpacing: 0.1,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: lightTextPrimary,
          height: 1.6,
          letterSpacing: 0.1,
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: lightTextSecondary,
          height: 1.5,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  // 다크 테마
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        secondary: darkSecondary,
        tertiary: darkAccent,
        error: darkError,
        surface: darkCard,
        onPrimary: darkBackground,
        onSecondary: darkBackground,
        onSurface: darkTextPrimary,
        onError: darkBackground,
      ),
      scaffoldBackgroundColor: darkBackground,

      // AppBar
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: darkBackground,
        foregroundColor: darkTextPrimary,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: darkTextPrimary, size: 24),
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),

      // Card - 다크 모드 글래스 효과
      cardTheme: CardThemeData(
        elevation: 0,
        color: darkCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: darkBorder, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shadowColor: Colors.black.withOpacity(0.4),
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: darkBackground,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          shadowColor: darkPrimary.withOpacity(0.3),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: const BorderSide(color: darkPrimary, width: 2),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // InputDecoration - 다크 모드 입력 필드
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: darkBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: darkBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: darkPrimary, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: darkError, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: darkError, width: 2.5),
        ),
        labelStyle: const TextStyle(
          color: darkTextSecondary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: const TextStyle(
          color: darkPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(
          color: darkTextSecondary.withOpacity(0.5),
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),

      // FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkPrimary,
        foregroundColor: darkBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkPrimary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(darkBackground),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: darkCard,
        contentTextStyle: const TextStyle(
          color: darkTextPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
      ),

      // Text - 프리미엄 타이포그래피
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          color: darkTextPrimary,
          letterSpacing: -1.5,
          height: 1.1,
        ),
        displayMedium: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          color: darkTextPrimary,
          letterSpacing: -1.2,
          height: 1.1,
        ),
        displaySmall: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: darkTextPrimary,
          letterSpacing: -1,
          height: 1.2,
        ),
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: darkTextPrimary,
          letterSpacing: -0.8,
          height: 1.2,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: darkTextPrimary,
          letterSpacing: -0.5,
          height: 1.3,
        ),
        headlineSmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: darkTextPrimary,
          letterSpacing: -0.3,
          height: 1.3,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: darkTextPrimary,
          letterSpacing: -0.2,
          height: 1.3,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
          letterSpacing: 0,
          height: 1.4,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
          letterSpacing: 0,
          height: 1.4,
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: darkTextPrimary,
          height: 1.6,
          letterSpacing: 0.1,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: darkTextPrimary,
          height: 1.6,
          letterSpacing: 0.1,
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: darkTextSecondary,
          height: 1.5,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  // 헬퍼 함수들 - 프리미엄 디자인 시스템
  static BoxDecoration premiumGradient({bool isDark = false}) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [darkPrimary, darkSecondary]
            : [lightPrimary, lightSecondary],
      ),
      borderRadius: BorderRadius.circular(24),
    );
  }

  static List<BoxShadow> premiumShadow({bool isDark = false}) {
    return [
      BoxShadow(
        color: (isDark ? Colors.black : lightPrimary).withOpacity(isDark ? 0.3 : 0.15),
        blurRadius: 24,
        offset: const Offset(0, 12),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: (isDark ? Colors.black : lightPrimary).withOpacity(isDark ? 0.15 : 0.08),
        blurRadius: 48,
        offset: const Offset(0, 24),
        spreadRadius: 0,
      ),
    ];
  }

  // 프리미엄 글래스모피즘 효과
  static BoxDecoration glassCard({bool isDark = false}) {
    return BoxDecoration(
      color: isDark
          ? darkCard.withOpacity(0.8)
          : lightCard.withOpacity(0.9),
      borderRadius: BorderRadius.circular(32),
      border: Border.all(
        color: isDark
            ? Colors.white.withOpacity(0.1)
            : Colors.white.withOpacity(0.6),
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: (isDark ? Colors.black : Colors.grey).withOpacity(isDark ? 0.3 : 0.12),
          blurRadius: 32,
          offset: const Offset(0, 16),
          spreadRadius: 0,
        ),
      ],
    );
  }

  // 프리미엄 네오모피즘 효과
  static BoxDecoration neomorphicCard({bool isDark = false}) {
    return BoxDecoration(
      color: isDark ? darkCard : lightCard,
      borderRadius: BorderRadius.circular(32),
      boxShadow: isDark
          ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 20,
                offset: const Offset(8, 8),
              ),
              BoxShadow(
                color: darkSurface.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(-8, -8),
              ),
            ]
          : [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 20,
                offset: const Offset(8, 8),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.9),
                blurRadius: 20,
                offset: const Offset(-8, -8),
              ),
            ],
    );
  }

  // 프리미엄 카드 스타일
  static BoxDecoration premiumCard({bool isDark = false}) {
    return BoxDecoration(
      color: isDark ? darkCard : lightCard,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(
        color: isDark ? darkBorder : lightBorder,
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: (isDark ? Colors.black : Colors.grey.shade300).withOpacity(isDark ? 0.4 : 0.15),
          blurRadius: 24,
          offset: const Offset(0, 12),
          spreadRadius: 0,
        ),
      ],
    );
  }

  // 그라데이션 배경
  static BoxDecoration gradientBackground({bool isDark = false}) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [
                const Color(0xFF1E293B),
                const Color(0xFF0F172A),
              ]
            : [
                const Color(0xFFF8FAFC),
                const Color(0xFFEFF6FF),
              ],
      ),
    );
  }

  static SnackBar successSnackBar(String message, {bool isDark = false}) {
    return SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle_rounded,
              color: isDark ? darkSuccess : lightSuccess),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? darkTextPrimary : lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isDark ? darkCard : lightCard,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      duration: const Duration(seconds: 3),
      elevation: 8,
    );
  }

  static SnackBar errorSnackBar(String message, {bool isDark = false}) {
    return SnackBar(
      content: Row(
        children: [
          Icon(Icons.error_rounded, color: isDark ? darkError : lightError),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? darkTextPrimary : lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isDark ? darkCard : lightCard,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      duration: const Duration(seconds: 3),
      elevation: 8,
    );
  }

  static SnackBar warningSnackBar(String message, {bool isDark = false}) {
    return SnackBar(
      content: Row(
        children: [
          Icon(Icons.warning_rounded,
              color: isDark ? darkWarning : lightWarning),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? darkTextPrimary : lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isDark ? darkCard : lightCard,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      duration: const Duration(seconds: 3),
      elevation: 8,
    );
  }

  static SnackBar infoSnackBar(String message, {bool isDark = false}) {
    return SnackBar(
      content: Row(
        children: [
          Icon(Icons.info_rounded, color: isDark ? darkAccent : lightAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? darkTextPrimary : lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isDark ? darkCard : lightCard,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      duration: const Duration(seconds: 3),
      elevation: 8,
    );
  }
}
