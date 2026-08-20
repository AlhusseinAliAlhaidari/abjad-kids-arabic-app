import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // الألوان الأساسية - السماوي
  static const Color primarySkyBlue = Color(0xFF87CEEB);
  static const Color lightSkyBlue = Color(0xFFB0E0E6);
  static const Color darkSkyBlue = Color(0xFF4A90E2);
  
  // ألوان إضافية للأطفال
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFE57373);
  static const Color starYellow = Color(0xFFFFD700);
  static const Color coinGold = Color(0xFFFFB300);
  
  // ألوان الخلفية
  static const Color backgroundColor = Color(0xFFF5F9FF);
  static const Color cardBackground = Colors.white;
  
  // ألوان النصوص
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textLight = Color(0xFF7F8C8D);
  
  // الثيم الأساسي
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primarySkyBlue,
        secondary: lightSkyBlue,
        tertiary: darkSkyBlue,
        surface: cardBackground,
        background: backgroundColor,
        error: errorRed,
      ),
      
      // الخطوط العربية
      textTheme: GoogleFonts.cairoTextTheme().copyWith(
        displayLarge: GoogleFonts.cairo(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        displayMedium: GoogleFonts.cairo(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        displaySmall: GoogleFonts.cairo(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        headlineLarge: GoogleFonts.cairo(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        headlineMedium: GoogleFonts.cairo(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        headlineSmall: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        titleLarge: GoogleFonts.cairo(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
        titleMedium: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
        titleSmall: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
        bodyLarge: GoogleFonts.cairo(
          fontSize: 18,
          color: textDark,
        ),
        bodyMedium: GoogleFonts.cairo(
          fontSize: 16,
          color: textDark,
        ),
        bodySmall: GoogleFonts.cairo(
          fontSize: 14,
          color: textLight,
        ),
      ),
      
      // أنماط الأزرار
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primarySkyBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
          textStyle: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // أنماط البطاقات
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      // أنماط AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: primarySkyBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      
      // أنماط الأيقونات
      iconTheme: const IconThemeData(
        color: primarySkyBlue,
        size: 32,
      ),
      
      // أنماط FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primarySkyBlue,
        foregroundColor: Colors.white,
        elevation: 6,
      ),
    );
  }
  
  // تدرجات لونية جميلة للخلفيات
  static LinearGradient get skyGradient {
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF87CEEB),
        Color(0xFFB0E0E6),
        Color(0xFFE0F6FF),
      ],
    );
  }
  
  static LinearGradient get successGradient {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF4CAF50),
        Color(0xFF81C784),
      ],
    );
  }
  
  static LinearGradient get cardGradient {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white,
        lightSkyBlue.withOpacity(0.1),
      ],
    );
  }
  
  // ظلال للعناصر
  static List<BoxShadow> get cardShadow {
    return [
      BoxShadow(
        color: primarySkyBlue.withOpacity(0.2),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ];
  }
  
  static List<BoxShadow> get buttonShadow {
    return [
      BoxShadow(
        color: primarySkyBlue.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ];
  }
}
