import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../theme/app_theme.dart';
import '../data/basic_level_tests_data.dart';
import '../services/database_service.dart';
import 'dart:math';

class BasicLevelTestScreen extends StatefulWidget {
  final String levelId;
  final String levelName;

  const BasicLevelTestScreen({
    Key? key,
    required this.levelId,
    required this.levelName,
  }) : super(key: key);

  @override
  State<BasicLevelTestScreen> createState() => _BasicLevelTestScreenState();
}

class _BasicLevelTestScreenState extends State<BasicLevelTestScreen> {
  late List<TestQuestion> questions;
  int currentQuestionIndex = 0;
  int score = 0;
  String? selectedAnswerId;
  bool showingFeedback = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlayingAudio = false;

  @override
  void initState() {
    super.initState();
    questions = BasicLevelTestsData.getTestForLevel(widget.levelId);
    _playQuestionAudio();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playQuestionAudio() async {
    final question = questions[currentQuestionIndex];
    if (question.audioPath != null) {
      try {
        setState(() => isPlayingAudio = true);
        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource(question.audioPath!));
        setState(() => isPlayingAudio = false);
      } catch (e) {
        print('❌ خطأ في تشغيل الصوت: $e');
        setState(() => isPlayingAudio = false);
      }
    }
  }

  void _handleAnswer(String answerId) {
    if (showingFeedback) return;

    setState(() {
      selectedAnswerId = answerId;
      showingFeedback = true;
    });

    final isCorrect = answerId == questions[currentQuestionIndex].correctAnswerId;
    if (isCorrect) {
      score++;
      _playSuccessSound();
    }

    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        if (currentQuestionIndex < questions.length - 1) {
          setState(() {
            currentQuestionIndex++;
            selectedAnswerId = null;
            showingFeedback = false;
          });
          _playQuestionAudio();
        } else {
          _showResults();
        }
      }
    });
  }

  Future<void> _playSuccessSound() async {
    try {
      final sounds = ['أحسنت.mp3', 'ممتاز.mp3', 'رائع.mp3', 'جيد.mp3'];
      final random = Random();
      await _audioPlayer.play(AssetSource('audio/encouragement/${sounds[random.nextInt(sounds.length)]}'));
    } catch (e) {
      print('❌ خطأ في تشغيل صوت النجاح: $e');
    }
  }

  void _showResults() {
    final percentage = (score / questions.length * 100).round();
    final stars = percentage >= 80 ? 3 : percentage >= 60 ? 2 : 1;

    // حفظ النتيجة
    DatabaseService.completeLesson(widget.levelId, stars);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, color: AppTheme.starYellow, size: 40),
            SizedBox(width: 10),
            Text('نتيجة الاختبار', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$score من ${questions.length}',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.primarySkyBlue),
            ),
            SizedBox(height: 10),
            Text(
              '$percentage%',
              style: TextStyle(fontSize: 24, color: AppTheme.textDark),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Icon(
                  index < stars ? Icons.star : Icons.star_border,
                  color: AppTheme.starYellow,
                  size: 40,
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('العودة', style: TextStyle(fontSize: 18)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentQuestionIndex = 0;
                score = 0;
                selectedAnswerId = null;
                showingFeedback = false;
              });
              _playQuestionAudio();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primarySkyBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text('إعادة المحاولة', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('اختبار ${widget.levelName}'),
          backgroundColor: AppTheme.primarySkyBlue,
        ),
        body: Center(
          child: Text('لا توجد أسئلة متاحة', style: TextStyle(fontSize: 18)),
        ),
      );
    }

    final question = questions[currentQuestionIndex];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF4E6), Color(0xFFFFE6F0)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // الهيدر
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: AppTheme.primarySkyBlue, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          'اختبار ${widget.levelName}',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primarySkyBlue),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 48),
                    ],
                  ),

                  SizedBox(height: 20),

                  // مؤشر التقدم
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 5,
                    children: List.generate(questions.length, (index) {
                      return Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index < currentQuestionIndex
                              ? AppTheme.successGreen
                              : index == currentQuestionIndex
                                  ? AppTheme.primarySkyBlue
                                  : Colors.grey[300],
                        ),
                      );
                    }),
                  ),

                  SizedBox(height: 15),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'سؤال ${currentQuestionIndex + 1} من ${questions.length}',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primarySkyBlue),
                    ),
                  ),

                  SizedBox(height: 30),

                  // السؤال
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15)],
                    ),
                    child: Column(
                      children: [
                        Text(
                          question.questionText,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 15),
                        if (question.audioPath != null)
                          ElevatedButton.icon(
                            onPressed: isPlayingAudio ? null : _playQuestionAudio,
                            icon: Icon(isPlayingAudio ? Icons.volume_up : Icons.play_arrow, size: 30),
                            label: Text(isPlayingAudio ? 'يتم التشغيل...' : 'استمع مرة أخرى', style: TextStyle(fontSize: 16)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primarySkyBlue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // الخيارات
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 0.9,
                    children: question.options.map((option) {
                      final isSelected = selectedAnswerId == option.id;
                      final isCorrect = option.id == question.correctAnswerId;
                      
                      Color backgroundColor = Colors.white;
                      if (isSelected && showingFeedback) {
                        backgroundColor = isCorrect ? AppTheme.successGreen : AppTheme.warningOrange;
                      }

                      return GestureDetector(
                        onTap: showingFeedback ? null : () => _handleAnswer(option.id),
                        child: Container(
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(20),
                            border: isSelected ? Border.all(color: isCorrect ? AppTheme.successGreen : AppTheme.warningOrange, width: 3) : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // الإيموجي أو الصورة
                              if (option.emoji != null)
                                Text(
                                  option.emoji!,
                                  style: TextStyle(fontSize: 60),
                                ),
                              if (option.imagePath != null && option.emoji == null)
                                Container(
                                  width: 80,
                                  height: 80,
                                  child: Image.asset(
                                    'assets/${option.imagePath}',
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.image, size: 60, color: Colors.grey);
                                    },
                                  ),
                                ),
                              SizedBox(height: 10),
                              Text(
                                option.text,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected && showingFeedback ? Colors.white : AppTheme.textDark,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
