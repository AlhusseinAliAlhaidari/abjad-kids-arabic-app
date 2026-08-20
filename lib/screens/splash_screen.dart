import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/database_service.dart';
import 'welcome_screen.dart';
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
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    // الانتقال للشاشة التالية بعد 3 ثواني
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _navigateToNextScreen();
      }
    });
  }

  void _navigateToNextScreen() {
    // التحقق من وجود ملف محفوظ
    final hasProfile = DatabaseService.hasProfile();
    final profile = DatabaseService.getChildProfile();

    print('🔍 فحص الملف المحفوظ:');
    print('   - hasProfile: $hasProfile');
    print('   - profile: ${profile?.name ?? "null"}');
    print('   - hasCompletedPlacementTest: ${profile?.hasCompletedPlacementTest ?? false}');

    Widget nextScreen;

    if (hasProfile && profile != null) {
      // المستخدم لديه ملف - الانتقال للصفحة الرئيسية
      print('✅ تم العثور على ملف محفوظ - الانتقال للصفحة الرئيسية');
      nextScreen = const HomeScreen();
    } else {
      // مستخدم جديد - الانتقال لشاشة الترحيب
      print('❌ لا يوجد ملف محفوظ - الانتقال لشاشة الترحيب');
      nextScreen = const WelcomeScreen();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
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
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF4A90E2),
              Color(0xFF87CEEB),
              Color(0xFFB0E0E6),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              child: Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // أيقونة التطبيق مع تأثير دوران
                        RotationTransition(
                          turns: _rotateAnimation,
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                                BoxShadow(
                                  color: AppTheme.primarySkyBlue.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/images/ui/app_logo.png',
                                width: 140,
                                height: 140,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // اسم التطبيق
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                          ),
                          child: Text(
                            'أبجد للأطفال',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(2, 2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // شعار التطبيق
                        Text(
                          '✨ رحلة ممتعة في عالم الحروف ✨',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.95),
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(1, 1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 50),

                        // مؤشر التحميل
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStars() {
    return List.generate(15, (index) {
      final random = index * 37; // رقم شبه عشوائي
      return Positioned(
        top: (random % 600).toDouble(),
        right: ((random * 3) % 800).toDouble(),
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 1000 + (random % 1000)),
          curve: Curves.easeInOut,
          builder: (context, double value, child) {
            return Opacity(
              opacity: (value * 0.7).clamp(0.3, 0.7),
              child: Icon(
                Icons.star,
                color: Colors.yellow[200],
                size: 20 + (random % 20).toDouble(),
              ),
            );
          },
          onEnd: () {
            // تكرار الرسوم المتحركة
            if (mounted) {
              setState(() {});
            }
          },
        ),
      );
    });
  }
}
