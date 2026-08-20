import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/database_service.dart';
import '../widgets/coin_display.dart';
import '../data/levels_data.dart';
import 'levels_screen.dart';
import 'store_screen.dart';
import 'settings_screen.dart';
import '../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final profile = DatabaseService.getChildProfile();

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  themeProvider.primaryColor,
                  themeProvider.secondaryColor,
                  themeProvider.secondaryColor.withOpacity(0.7),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildProfileSection(
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height,
                            themeProvider,
                          ),
                          _buildStagesScroll(context, profile),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(
      BuildContext context, profile, ThemeProvider themeProvider) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: 8),
      child: Row(
        children: [
          // أيقونة الإعدادات
          Container(
            width: screenWidth * 0.055,
            height: screenWidth * 0.055,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.settings,
                color: AppTheme.primarySkyBlue, size: screenWidth * 0.028),
          ),

          SizedBox(width: screenWidth * 0.02),

          // معلومات الطفل
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school,
                    color: AppTheme.starYellow, size: screenWidth * 0.025),
                SizedBox(width: 5),
                Text(
                  'المستوى ${profile?.currentLevel ?? 1}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.022,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: screenWidth * 0.02),

          // زر الإعدادات
          _TopButton(
            icon: Icons.settings,
            label: '',
            color: Colors.white.withOpacity(0.9),
            screenWidth: screenWidth,
            onTap: () {},
          ),

          SizedBox(width: screenWidth * 0.015),

          // صورة الطفل
          Container(
            width: screenWidth * 0.065,
            height: screenWidth * 0.065,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppTheme.primarySkyBlue, AppTheme.lightSkyBlue],
              ),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Text(
                '👦',
                style: TextStyle(fontSize: screenWidth * 0.038),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStagesScroll(BuildContext context, profile) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final stages = LevelsData.allStages;
    final currentLevel = profile?.currentLevel ?? 1;

    final stageIcons = [
      'assets/images/ui/stage_1.png',
      'assets/images/ui/stage_2.png',
      'assets/images/ui/stage_3.png',
      'assets/images/ui/stage_4.png',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Row(
        children: List.generate(4, (index) {
          final isUnlocked = index < currentLevel;
          final stage = index < stages.length ? stages[index] : null;

          // حساب النجوم الفعلية للمرحلة
          int stageStars = 0;
          int stageTotalStars = 0;

          if (stage != null) {
            stageTotalStars = stage.levels.length * 3; // كل مستوى له 3 نجوم

            // حساب النجوم المكتسبة
            for (var level in stage.levels) {
              // تحديد نوع الدرس بناءً على المرحلة
              final lessonId = stage.id == 'basic'
                  ? 'pronunciation_${level.id}_lesson'
                  : 'level_${level.id}_lesson';

              final progress = DatabaseService.getLessonProgress(lessonId);
              if (progress != null) {
                stageStars += progress.stars;
              }
            }
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.015),
            child: _StageCard(
              stageNumber: index + 1,
              stageName: _getStageName(index),
              iconPath: stageIcons[index],
              isUnlocked: isUnlocked,
              stars: stageStars,
              totalStars: stageTotalStars,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              onTap: () {
                if (isUnlocked && stage != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LevelsScreen(
                        stageId: stage.id,
                        stageName: _getStageName(index),
                      ),
                    ),
                  ).then((_) {
                    // تحديث الشاشة عند الرجوع
                    if (mounted) {
                      setState(() {
                        print('🔄 تحديث الشاشة الرئيسية');
                      });
                    }
                  });
                }
              },
            ),
          );
        }),
      ),
    );
  }

  String _getStageName(int index) {
    switch (index) {
      case 0:
        return 'مرحلة التمهيد';
      case 1:
        return 'مرحلة الأساسي';
      case 2:
        return 'مرحلة المتقدم';
      case 3:
        return 'مرحلة المتقن';
      default:
        return '';
    }
  }

  Widget _buildProfileSection(
      double screenWidth, double screenHeight, ThemeProvider themeProvider) {
    final profile = DatabaseService.getChildProfile();
    if (profile == null) return SizedBox.shrink();

    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [themeProvider.primaryColor, themeProvider.secondaryColor],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: themeProvider.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // الشخصية المختارة
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StoreScreen()),
              ).then((_) {
                if (mounted) setState(() {});
              });
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/animals/${profile.selectedCharacter}.jpg',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.pets,
                        size: 40, color: themeProvider.primaryColor);
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 15),

          // المعلومات
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.monetization_on,
                        color: AppTheme.starYellow, size: 20),
                    SizedBox(width: 5),
                    Text(
                      '${profile.totalPoints}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 15),
                    Icon(Icons.star, color: AppTheme.starYellow, size: 20),
                    SizedBox(width: 5),
                    Text(
                      '${profile.totalStars}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // زر المتجر
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StoreScreen()),
              ).then((_) {
                if (mounted) setState(() {});
              });
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(Icons.store,
                  color: themeProvider.primaryColor, size: 28),
            ),
          ),

          SizedBox(width: 10),

          // زر الإعدادات
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(Icons.settings,
                  color: themeProvider.primaryColor, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final double screenWidth;
  final VoidCallback onTap;

  const _TopButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.screenWidth,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02,
          vertical: screenWidth * 0.008,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: screenWidth * 0.028),
            SizedBox(width: screenWidth * 0.006),
            Text(
              label,
              style: TextStyle(
                fontSize: screenWidth * 0.02,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StageCard extends StatelessWidget {
  final int stageNumber;
  final String stageName;
  final String iconPath;
  final bool isUnlocked;
  final int stars;
  final int totalStars;
  final double screenWidth;
  final double screenHeight;
  final VoidCallback onTap;

  const _StageCard({
    required this.stageNumber,
    required this.stageName,
    required this.iconPath,
    required this.isUnlocked,
    required this.stars,
    required this.totalStars,
    required this.screenWidth,
    required this.screenHeight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: Container(
        width: screenWidth * 0.26,
        padding: EdgeInsets.all(screenWidth * 0.018),
        decoration: BoxDecoration(
          gradient: isUnlocked
              ? LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.white,
                    AppTheme.lightSkyBlue.withOpacity(0.3),
                  ],
                )
              : null,
          color: isUnlocked ? null : Colors.grey[300],
          borderRadius: BorderRadius.circular(18),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: AppTheme.primarySkyBlue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [],
          border: Border.all(
            color: isUnlocked ? AppTheme.primarySkyBlue : Colors.grey,
            width: 2.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة المرحلة
            Container(
              width: screenWidth * 0.12,
              height: screenWidth * 0.12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: isUnlocked
                        ? AppTheme.primarySkyBlue.withOpacity(0.25)
                        : Colors.grey.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(screenWidth * 0.015),
              child: isUnlocked
                  ? Image.asset(iconPath, fit: BoxFit.contain)
                  : Icon(Icons.lock,
                      size: screenWidth * 0.055, color: Colors.grey[600]),
            ),

            SizedBox(height: 8),

            // رقم المرحلة
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.015,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                gradient: isUnlocked
                    ? LinearGradient(
                        colors: [AppTheme.primarySkyBlue, AppTheme.darkSkyBlue],
                      )
                    : null,
                color: isUnlocked ? null : Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'المرحلة $stageNumber',
                style: TextStyle(
                  fontSize: screenWidth * 0.022,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 6),

            // اسم المرحلة
            Text(
              stageName,
              style: TextStyle(
                fontSize: screenWidth * 0.026,
                fontWeight: FontWeight.bold,
                color: isUnlocked ? AppTheme.textDark : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),

            SizedBox(height: 6),

            // النجوم
            if (isUnlocked)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.012,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.starYellow.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star,
                        color: AppTheme.starYellow, size: screenWidth * 0.028),
                    SizedBox(width: 3),
                    Text(
                      '$stars/$totalStars',
                      style: TextStyle(
                        fontSize: screenWidth * 0.022,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
