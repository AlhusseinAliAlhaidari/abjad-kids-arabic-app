import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../services/database_service.dart';
import '../models/child_profile.dart';
import 'test_introduction_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  int _selectedAge = 6;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('من فضلك أدخل اسمك'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }

    // إنشاء ملف جديد للطفل
    final profile = ChildProfile(
      name: _nameController.text.trim(),
      age: _selectedAge,
      createdAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    );

    print('👤 إنشاء ملف طفل جديد: ${profile.name}, العمر: ${profile.age}');
    
    // حفظ الملف في قاعدة البيانات
    await DatabaseService.saveChildProfile(profile);
    
    print('✅ تم حفظ ملف الطفل بنجاح');
    
    // التحقق من الحفظ
    final savedProfile = DatabaseService.getChildProfile();
    if (savedProfile != null) {
      print('✅ تم التحقق: الملف محفوظ - ${savedProfile.name}');
    } else {
      print('❌ خطأ: الملف لم يُحفظ!');
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TestIntroductionScreen(
          childName: _nameController.text.trim(),
          childAge: _selectedAge,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF87CEEB),
              Color(0xFFB0E0E6),
              Color(0xFFE0F6FF),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.02,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // الجزء الأيمن - الشعار والترحيب
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: screenHeight * 0.18,
                            height: screenHeight * 0.18,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: AppTheme.cardShadow,
                            ),
                            padding: EdgeInsets.all(screenHeight * 0.02),
                            child: Image.asset(
                              'assets/images/ui/app_logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          Text(
                            '🌟 أهلاً بك في\nرحلة التعلم 🌟',
                            style: TextStyle(
                              fontSize: screenHeight * 0.04,
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
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: screenWidth * 0.03),

                    // الجزء الأيسر - بطاقة الإدخال
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.all(screenHeight * 0.035),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: AppTheme.cardShadow,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'ما اسمك؟',
                              style: TextStyle(
                                fontSize: screenHeight * 0.032,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            TextField(
                              controller: _nameController,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: screenHeight * 0.028,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primarySkyBlue,
                              ),
                              decoration: InputDecoration(
                                hintText: 'اكتب اسمك هنا',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: screenHeight * 0.025,
                                ),
                                filled: true,
                                fillColor:
                                    AppTheme.lightSkyBlue.withOpacity(0.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.03,
                                  vertical: screenHeight * 0.02,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.035),
                            Text(
                              'كم عمرك؟',
                              style: TextStyle(
                                fontSize: screenHeight * 0.032,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Wrap(
                              spacing: screenWidth * 0.015,
                              runSpacing: screenHeight * 0.015,
                              alignment: WrapAlignment.center,
                              children: List.generate(9, (index) {
                                final age = index + 4;
                                final isSelected = age == _selectedAge;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedAge = age;
                                    });
                                  },
                                  child: Container(
                                    width: screenHeight * 0.08,
                                    height: screenHeight * 0.08,
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                          ? LinearGradient(
                                              colors: [
                                                AppTheme.primarySkyBlue,
                                                AppTheme.darkSkyBlue,
                                              ],
                                            )
                                          : null,
                                      color:
                                          isSelected ? null : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppTheme.primarySkyBlue
                                            : Colors.grey[300]!,
                                        width: 2,
                                      ),
                                      boxShadow: isSelected
                                          ? AppTheme.buttonShadow
                                          : [],
                                    ),
                                    child: Center(
                                      child: Text(
                                        age.toString(),
                                        style: TextStyle(
                                          fontSize: screenHeight * 0.032,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            SizedBox(height: screenHeight * 0.035),
                            Center(
                              child: CustomButton(
                                text: 'هيا نبدأ! 🚀',
                                onPressed: _continue,
                                width: screenWidth * 0.25,
                                height: screenHeight * 0.09,
                                icon: Icons.arrow_back,
                              ),
                            ),
                          ],
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
    );
  }
}
