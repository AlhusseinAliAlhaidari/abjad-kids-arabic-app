import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'placement_test_screen.dart';
import 'home_screen.dart';

class TestIntroductionScreen extends StatelessWidget {
  final String childName;
  final int childAge;

  const TestIntroductionScreen({
    super.key,
    required this.childName,
    required this.childAge,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/backgrounds/background_clouds_sky_1764934265527.png'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE3F2FD),
              Color(0xFFFFF9C4),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(screenHeight * 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // الشخصية العربية
                Image.asset(
                  'assets/images/characters/arab_boy_happy_1764934023454.png',
                  height: screenHeight * 0.25,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.child_care,
                    size: screenHeight * 0.2,
                    color: AppTheme.primarySkyBlue,
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),

                // الرسالة الرئيسية
                Container(
                  padding: EdgeInsets.all(screenHeight * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'مرحباً $childName! 👋',
                        style: TextStyle(
                          fontSize: screenHeight * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'سنبدأ باختبار بسيط لنعرف مستواك\nفي اللغة العربية 📚',
                        style: TextStyle(
                          fontSize: screenHeight * 0.028,
                          color: Color(0xFF546E7A),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      Container(
                        padding: EdgeInsets.all(screenHeight * 0.02),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF9C4),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(Icons.timer,
                                'الاختبار سريع (5 دقائق)', screenHeight),
                            SizedBox(height: 8),
                            _buildInfoRow(Icons.emoji_events,
                                'لا توجد درجات، فقط تعلم!', screenHeight),
                            SizedBox(height: 8),
                            _buildInfoRow(Icons.rocket_launch,
                                'يمكنك التخطي والبدء مباشرة', screenHeight),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.04),

                // الأزرار
                Row(
                  children: [
                    // زر التخطي
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.022),
                          side: BorderSide(color: Color(0xFFFF6B6B), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'تخطي',
                          style: TextStyle(
                            fontSize: screenHeight * 0.024,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B6B),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: screenWidth * 0.03),

                    // زر البدء
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacementTestScreen(
                                childName: childName,
                                childAge: childAge,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4CAF50),
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.022),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'هيا نبدأ!',
                              style: TextStyle(
                                fontSize: screenHeight * 0.028,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_back,
                                color: Colors.white, size: screenHeight * 0.03),
                          ],
                        ),
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

  Widget _buildInfoRow(IconData icon, String text, double screenHeight) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFFFF9800), size: screenHeight * 0.025),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: screenHeight * 0.02,
              color: Color(0xFF2C3E50),
            ),
          ),
        ),
      ],
    );
  }
}
