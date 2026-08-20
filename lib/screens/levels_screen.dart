import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/levels_data.dart';
import '../data/pronunciation_lessons_data.dart';
import '../services/database_service.dart';
import 'lesson_screen.dart';
import 'pronunciation_lesson_screen.dart';

class LevelsScreen extends StatefulWidget {
  final String stageId;
  final String stageName;

  const LevelsScreen({
    super.key,
    required this.stageId,
    required this.stageName,
  });

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  void _checkStageCompletion() {
    final stage = LevelsData.getStage(widget.stageId);
    if (stage == null) return;

    // التحقق من إكمال جميع المستويات
    bool allCompleted = true;
    for (var level in stage.levels) {
      // تحديد نوع الدرس بناءً على المرحلة
      final lessonId = widget.stageId == 'basic'
          ? 'pronunciation_${level.id}_lesson'
          : 'level_${level.id}_lesson';

      final progress = DatabaseService.getLessonProgress(lessonId);
      if (progress == null || !progress.isCompleted) {
        allCompleted = false;
        break;
      }
    }

    if (allCompleted) {
      _showStageCelebration();
    }
  }

  void _showStageCelebration() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            maxWidth: 400,
          ),
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFFFF9E6)],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events, color: AppTheme.starYellow, size: 60),
                SizedBox(height: 15),
                Text(
                  '🎉 مبروك! 🎉',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primarySkyBlue),
                ),
                SizedBox(height: 12),
                Text(
                  'لقد أكملت ${widget.stageName} بنجاح!',
                  style: TextStyle(fontSize: 16, color: AppTheme.textDark),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'المرحلة التالية أصبحت متاحة الآن',
                  style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.successGreen,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      5,
                      (i) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            child: Icon(Icons.star,
                                color: AppTheme.starYellow, size: 30),
                          )),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // رفع المستوى
                    final profile = DatabaseService.getChildProfile();
                    if (profile != null) {
                      profile.currentLevel++;
                      await DatabaseService.saveChildProfile(profile);
                      print('🎊 تم رفع المستوى إلى: ${profile.currentLevel}');
                    }

                    if (mounted) {
                      Navigator.pop(context); // إغلاق الديالوج
                      Navigator.pop(context); // الرجوع للشاشة الرئيسية
                    }
                  },
                  child: Text('متابعة',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successGreen,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stage = LevelsData.getStage(widget.stageId);

    if (stage == null) {
      return Scaffold(
        appBar: AppBar(title: Text('خطأ')),
        body: Center(child: Text('المرحلة غير موجودة')),
      );
    }

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
          child: Column(
            children: [
              _buildHeader(context),
              SizedBox(height: 20),
              Expanded(
                child: _buildLevelsList(context, stage),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 10),
          Text(
            widget.stageName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelsList(BuildContext context, Stage stage) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: stage.levels.length,
      itemBuilder: (context, index) {
        final level = stage.levels[index];

        // التحقق من إمكانية فتح المستوى
        bool isUnlocked = index == 0; // المستوى الأول دائماً مفتوح

        if (index > 0) {
          // تحديد نوع الدرس بناءً على المرحلة
          final previousLevelId = widget.stageId == 'basic'
              ? 'pronunciation_${stage.levels[index - 1].id}_lesson'
              : 'level_${stage.levels[index - 1].id}_lesson';

          final previousProgress =
              DatabaseService.getLessonProgress(previousLevelId);
          isUnlocked = previousProgress?.isCompleted ?? false;

          print('🔓 فحص المستوى ${level.id}: ${isUnlocked ? "مفتوح" : "مقفل"}');
        }

        return _LevelCard(
          level: level,
          isUnlocked: isUnlocked,
          onTap: () {
            if (isUnlocked) {
              // التحقق من نوع الدرس
              if (widget.stageId == 'basic') {
                // مرحلة الأساسي - دروس النطق
                final pronunciationLevel = PronunciationLessonsData.getLevel(
                    'pronunciation_${level.id}');
                if (pronunciationLevel != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PronunciationLessonScreen(
                        level: pronunciationLevel,
                        lessonId: 'pronunciation_${level.id}_lesson',
                      ),
                    ),
                  ).then((_) {
                    if (mounted) {
                      setState(() {
                        print('🔄 تحديث شاشة المستويات');
                        _checkStageCompletion();
                      });
                    }
                  });
                }
              } else {
                // مرحلة التمهيد - دروس الحروف
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonScreen(
                      level: level,
                      lessonId: 'level_${level.id}_lesson',
                    ),
                  ),
                ).then((_) {
                  if (mounted) {
                    setState(() {
                      print('🔄 تحديث شاشة المستويات');
                      _checkStageCompletion();
                    });
                  }
                });
              }
            }
          },
        );
      },
    );
  }
}

class _LevelCard extends StatelessWidget {
  final Level level;
  final bool isUnlocked;
  final VoidCallback onTap;

  const _LevelCard({
    required this.level,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isUnlocked
              ? LinearGradient(
                  colors: [
                    Colors.white,
                    AppTheme.lightSkyBlue.withOpacity(0.3)
                  ],
                )
              : null,
          color: isUnlocked ? null : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: AppTheme.primarySkyBlue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ]
              : [],
          border: Border.all(
            color: isUnlocked ? AppTheme.primarySkyBlue : Colors.grey,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // أيقونة المستوى
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isUnlocked ? AppTheme.primarySkyBlue : Colors.grey,
              ),
              child: Center(
                child: isUnlocked
                    ? Text(
                        '${level.id}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : Icon(Icons.lock, color: Colors.white, size: 30),
              ),
            ),

            SizedBox(width: 16),

            // معلومات المستوى
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isUnlocked ? AppTheme.textDark : Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'الحروف: ${level.targetLetters.join('، ')}',
                    style: TextStyle(
                      fontSize: 16,
                      color: isUnlocked
                          ? AppTheme.textDark.withOpacity(0.7)
                          : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            // سهم
            if (isUnlocked)
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.primarySkyBlue,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
