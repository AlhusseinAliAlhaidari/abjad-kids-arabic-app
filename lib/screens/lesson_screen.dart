import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../theme/app_theme.dart';
import '../data/levels_data.dart';
import '../data/letter_examples_data.dart';
import '../widgets/level_test_dialog.dart';
import '../widgets/letter_video_player.dart';

class LessonScreen extends StatefulWidget {
  final Level level;
  final String lessonId;

  const LessonScreen({
    super.key,
    required this.level,
    required this.lessonId,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _currentLetterIndex = 0;
  late final PageController _pageController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<String> get letters => widget.level.targetLetters;
  String get currentLetter => letters[_currentLetterIndex];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  String _getLetterFileName(String letter) {
    final fileNames = {
      'أ': 'أ - ألف',
      'ب': 'ب - باء',
      'ت': 'ت - تاء',
      'ث': 'ث - ثاء',
      'ج': 'ج - جيم',
      'ح': 'ح - حاء',
      'خ': 'خ - خاء',
      'د': 'د - دال',
      'ذ': 'ذ - ذال',
      'ر': 'ر - راء',
      'ز': 'ز - زاي',
      'س': 'س - سين',
      'ش': 'ش - شين',
      'ص': 'ص - صاد',
      'ض': 'ض - ضاد',
      'ط': 'ط - طاء',
      'ظ': 'ظ - ظاء',
      'ع': 'ع - عين',
      'غ': 'غ - غين',
      'ف': 'ف - فاء',
      'ق': 'ق - قاف',
      'ك': 'ك - كاف',
      'ل': 'ل - لام',
      'م': 'م - ميم',
      'ن': 'ن - نون',
      'ه': 'ه - هاء',
      'و': 'و - واو',
      'ي': 'ي - ياء',
    };
    return fileNames[letter] ?? letter;
  }

  Future<void> _playSound() async {
    try {
      final audioPath = 'audio/letters/${_getLetterFileName(currentLetter)}.mp3';
      print('🔊 محاولة تشغيل الصوت: $audioPath');
      await _audioPlayer.play(AssetSource(audioPath));
    } catch (e) {
      print('❌ خطأ في تشغيل الصوت: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('عذراً، الصوت غير متوفر حالياً'),
            duration: Duration(seconds: 2),
            backgroundColor: AppTheme.warningOrange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF4E6), Color(0xFFFFE6F0)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 60),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: letters.length,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() => _currentLetterIndex = index);
                      },
                      itemBuilder: (context, index) =>
                          _buildLetterPage(letters[index]),
                    ),
                  ),
                ],
              ),

              // زر الإغلاق
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1), blurRadius: 10)
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.red[400], size: 28),
                    onPressed: _showExitDialog,
                  ),
                ),
              ),

              // زر الحرف التالي (يظهر إلا في الحرف الأخير)
              if (_currentLetterIndex < letters.length - 1)
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                      },
                      icon: const Icon(Icons.arrow_back, size: 24),
                      label: const Text(
                        'الحرف التالي',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primarySkyBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                        shadowColor: AppTheme.primarySkyBlue.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),

              // زر إنهاء الدرس (يظهر فقط عند الحرف الأخير)
              if (_currentLetterIndex == letters.length - 1)
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        LevelTestDialog.show(context,
                            letters: letters, lessonId: widget.lessonId);
                      },
                      icon: Icon(Icons.check_circle, size: 28),
                      label: Text('إنهاء الدرس والبدء بالاختبار',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.successGreen,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 8,
                        shadowColor: AppTheme.successGreen.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),

              // مؤشر التقدم
              Positioned(
                top: 15,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10)
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_stories,
                            color: AppTheme.primarySkyBlue, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'حرف ${_currentLetterIndex + 1} من ${letters.length}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primarySkyBlue),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLetterPage(String letter) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          // 1. عنوان + الحرف
          Text('تعلم حرف',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primarySkyBlue)),
          SizedBox(height: 15),
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: AppTheme.primarySkyBlue.withOpacity(0.3),
                    blurRadius: 30,
                    offset: Offset(0, 10))
              ],
            ),
            child: Center(
                child: Text(letter,
                    style: TextStyle(
                        fontSize: 85,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primarySkyBlue))),
          ),

          SizedBox(height: 25),

          // 2. زر الاستماع
          Text('اضغط للاستماع',
              style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textDark,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 12),
          GestureDetector(
            onTap: _playSound,
            child: Container(
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [AppTheme.warningOrange, Colors.orange[300]!]),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: AppTheme.warningOrange.withOpacity(0.4),
                      blurRadius: 20,
                      offset: Offset(0, 8))
                ],
              ),
              child: Icon(Icons.volume_up, size: 45, color: Colors.white),
            ),
          ),

          SizedBox(height: 30),

          // 3. فيديو رسم الحرف
          _buildVideoSection(letter),

          SizedBox(height: 25),

          // 4. الأمثلة
          _buildExamplesSection(letter),

          SizedBox(height: 30),

          // 5. تلميح التمرير
          if (_currentLetterIndex < letters.length - 1)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.primarySkyBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.swipe_left,
                      color: AppTheme.primarySkyBlue, size: 24),
                  SizedBox(width: 10),
                  Text('مرر لليسار للحرف التالي',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.primarySkyBlue,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoSection(String letter) {
    print('🎥 فيديو الحرف: $letter');
    return LetterVideoPlayer(letter: letter);
  }

  Widget _buildExamplesSection(String letter) {
    final examples = LetterExamplesData.getExamples(letter);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppTheme.starYellow, width: 3),
        boxShadow: [
          BoxShadow(
              color: AppTheme.starYellow.withOpacity(0.2),
              blurRadius: 15,
              offset: Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lightbulb, color: AppTheme.starYellow, size: 28),
              SizedBox(width: 10),
              Text('كلمات تبدأ بهذا الحرف',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primarySkyBlue)),
            ],
          ),
          SizedBox(height: 15),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            alignment: WrapAlignment.center,
            children:
                examples.map((example) => _buildExampleCard(example)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(Map<String, String> example) {
    return Container(
      width: 100,
      child: Column(
        children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.lightSkyBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Center(
                  child: Text(
                    example['emoji']!,
                    style: TextStyle(fontSize: 60),
                  ),
                ),
              ),
            ),
          SizedBox(height: 8),
          Text(
            example['word']!,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('هل تريد الخروج؟', textAlign: TextAlign.center),
        content: Text('لم تنهي جميع الحروف بعد. هل تريد الخروج؟',
            textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('متابعة التعلم'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('خروج', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
