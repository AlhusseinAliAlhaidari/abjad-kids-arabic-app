import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../theme/app_theme.dart';
import '../services/database_service.dart';
import '../data/letter_examples_data.dart';
import 'dart:math';

class LevelTestDialog {
  static void show(
    BuildContext context, {
    required List<String> letters,
    required String lessonId,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFE6F3FF)],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events, color: AppTheme.starYellow, size: 70),
                SizedBox(height: 15),
                Text(
                  'رائع! 🎉',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primarySkyBlue),
                ),
                SizedBox(height: 12),
                Text(
                  'لقد تعلمت ${letters.length} حرف!\nهل أنت مستعد للاختبار؟',
                  style: TextStyle(fontSize: 16, color: AppTheme.textDark),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text('لاحقاً', style: TextStyle(fontSize: 14)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: AppTheme.textDark,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _startTest(context, letters, lessonId);
                          },
                          child: Text('ابدأ!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.successGreen,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
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

  static void _startTest(BuildContext context, List<String> letters, String lessonId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _TestScreen(letters: letters, lessonId: lessonId),
      ),
    );
  }
}

class _TestScreen extends StatefulWidget {
  final List<String> letters;
  final String lessonId;

  const _TestScreen({required this.letters, required this.lessonId});

  @override
  State<_TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<_TestScreen> {
  int currentQuestion = 0;
  int score = 0;
  final random = Random();
  String? selectedAnswer;
  bool showingFeedback = false;

  @override
  Widget build(BuildContext context) {
    if (currentQuestion >= widget.letters.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTestResults();
      });
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final questionData = _generateQuestion();

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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // مؤشر التقدم
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 5,
                      children: List.generate(widget.letters.length, (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index < currentQuestion
                                ? AppTheme.successGreen
                                : index == currentQuestion
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
                        'سؤال ${currentQuestion + 1} من ${widget.letters.length}',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primarySkyBlue),
                      ),
                    ),

                    SizedBox(height: 20),

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
                            questionData['question'],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 15),
                          if (questionData['type'] == 'letter')
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppTheme.lightSkyBlue.withOpacity(0.3), AppTheme.primarySkyBlue.withOpacity(0.1)],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  questionData['display'],
                                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: AppTheme.primarySkyBlue),
                                ),
                              ),
                            ),
                          if (questionData['type'] == 'word')
                            Text(
                              questionData['display'],
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primarySkyBlue),
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // الخيارات - مضغوطة ومرتبة
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: (questionData['options'] as List<String>).map((option) {
                        final isSelected = selectedAnswer == option;
                        return SizedBox(
                          width: 70,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: showingFeedback ? null : () => _handleAnswer(option, questionData['correct']),
                            child: Text(
                              option,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? (option == questionData['correct'] ? AppTheme.successGreen : AppTheme.warningOrange)
                                  : Colors.white,
                              foregroundColor: isSelected ? Colors.white : AppTheme.primarySkyBlue,
                              elevation: 5,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _generateQuestion() {
    final correctLetter = widget.letters[currentQuestion];
    
    // اختيار 3 حروف عشوائية مختلفة
    final allLetters = List<String>.from(widget.letters);
    allLetters.remove(correctLetter);
    allLetters.shuffle(random);

    final options = <String>[correctLetter];
    for (var i = 0; i < 3 && i < allLetters.length; i++) {
      options.add(allLetters[i]);
    }

    // إذا لم يكن هناك حروف كافية
    if (options.length < 4) {
      final basicLetters = ['ا', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ذ', 'ر', 'ز', 'س', 'ش', 'ص'];
      for (var letter in basicLetters) {
        if (!options.contains(letter) && options.length < 4) {
          options.add(letter);
        }
      }
    }

    options.shuffle(random);

    // دائماً نعرض كلمة ونطلب الحرف الأول
    final examples = LetterExamplesData.getExamples(correctLetter);
    if (examples.isNotEmpty) {
      final example = examples[random.nextInt(examples.length)];
      return {
        'type': 'word',
        'question': 'ما الحرف الذي تبدأ به هذه الكلمة؟',
        'display': example['word']!,
        'options': options,
        'correct': correctLetter,
      };
    }

    // سؤال افتراضي: ما هذا الحرف؟
    return {
      'type': 'letter',
      'question': 'ما هذا الحرف؟',
      'display': correctLetter,
      'options': options,
      'correct': correctLetter,
    };
  }

  void _handleAnswer(String answer, String correct) {
    setState(() {
      selectedAnswer = answer;
      showingFeedback = true;
    });

    if (answer == correct) {
      score++;
    }

    // الانتقال فوراً للسؤال التالي
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          currentQuestion++;
          selectedAnswer = null;
          showingFeedback = false;
        });
      }
    });
  }

  Future<void> _playEncouragementSound() async {
    final encouragementSounds = [
      'أحسنت.mp3',
      'ممتاز.mp3',
      'رائع.mp3',
      'جيد.mp3',
      'تصفيق.mp3',
    ];
    
    final random = Random();
    final selectedSound = encouragementSounds[random.nextInt(encouragementSounds.length)];
    
    try {
      final player = AudioPlayer();
      await player.play(AssetSource('audio/encouragement/$selectedSound'));
      print('🎵 تشغيل صوت تشجيع: $selectedSound');
    } catch (e) {
      print('خطأ في تشغيل صوت التشجيع: $e');
    }
  }

  void _showTestResults() {
    final percentage = (score / widget.letters.length * 100).round();
    final passed = percentage >= 70;

    // تشغيل صوت تشجيع عند النجاح
    if (passed) {
      _playEncouragementSound();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
            maxWidth: 400,
          ),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: passed ? [Colors.white, Color(0xFFE8F5E9)] : [Colors.white, Color(0xFFFFEBEE)],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  passed ? Icons.emoji_events : Icons.refresh,
                  color: passed ? AppTheme.successGreen : AppTheme.warningOrange,
                  size: 60,
                ),
                SizedBox(height: 12),
                Text(
                  passed ? 'ممتاز! 🎉' : 'حاول مرة أخرى',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: passed ? AppTheme.successGreen : AppTheme.warningOrange),
                ),
                SizedBox(height: 10),
                Text('نتيجتك: $score من ${widget.letters.length}', style: TextStyle(fontSize: 16, color: AppTheme.textDark)),
                SizedBox(height: 5),
                Text('$percentage%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primarySkyBlue)),
                SizedBox(height: 12),
                if (passed)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        3,
                        (i) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              child: Icon(Icons.star, color: AppTheme.starYellow, size: 35),
                            )),
                  ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    if (passed) {
                      print('🎯 محاولة حفظ الدرس: ${widget.lessonId}');
                      await DatabaseService.completeLesson(widget.lessonId, 3);
                      print('✅ تم حفظ الدرس بنجاح');
                    }
                    if (!context.mounted) return;
                    Navigator.pop(context); // إغلاق الديالوج
                    Navigator.pop(context); // إغلاق شاشة الاختبار
                    Navigator.pop(context); // الرجوع للشاشة الرئيسية
                  },
                  child: Text(passed ? 'متابعة' : 'إعادة المحاولة', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: passed ? AppTheme.successGreen : AppTheme.warningOrange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
