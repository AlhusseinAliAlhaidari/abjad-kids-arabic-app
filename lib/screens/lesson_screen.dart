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
            content: const Text('عذراً، الصوت غير متوفر حالياً'),
            duration: const Duration(seconds: 2),
            backgroundColor: AppTheme.warningOrange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallHeight = size.height < 450;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5), Color(0xFFEFF6FF)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // جسم الصفحة الرئيسي
              Column(
                children: [
                  // شريط التحكم العلوي المدمج
                  _buildTopHeader(isSmallHeight),

                  // محتوى الحرف المتجاوب (Side-by-Side)
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: letters.length,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() => _currentLetterIndex = index);
                      },
                      itemBuilder: (context, index) =>
                          _buildLetterPage(letters[index], isSmallHeight),
                    ),
                  ),
                ],
              ),

              // زر السهم السابق (على اليمين)
              if (_currentLetterIndex > 0)
                Positioned(
                  right: 12,
                  top: size.height * 0.45,
                  child: _buildNavArrow(
                    icon: Icons.chevron_right,
                    onTap: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),

              // زر السهم التالي (على اليسار)
              if (_currentLetterIndex < letters.length - 1)
                Positioned(
                  left: 12,
                  top: size.height * 0.45,
                  child: _buildNavArrow(
                    icon: Icons.chevron_left,
                    onTap: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // شريط علوي أنيق ومدمج
  Widget _buildTopHeader(bool isSmallHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isSmallHeight ? 6 : 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // زر الإغلاق
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.red[400], size: isSmallHeight ? 20 : 24),
              onPressed: _showExitDialog,
              padding: EdgeInsets.all(isSmallHeight ? 6 : 8),
              constraints: const BoxConstraints(),
            ),
          ),

          // مؤشر التقدم (حرف X من Y)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallHeight ? 14 : 20,
              vertical: isSmallHeight ? 4 : 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_stories,
                    color: AppTheme.primarySkyBlue, size: isSmallHeight ? 16 : 20),
                const SizedBox(width: 8),
                Text(
                  'حرف ${_currentLetterIndex + 1} من ${letters.length}',
                  style: TextStyle(
                    fontSize: isSmallHeight ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primarySkyBlue,
                  ),
                ),
              ],
            ),
          ),

          // زر الانتقال للتالي أو الاختبار في الزاوية
          if (_currentLetterIndex < letters.length - 1)
            ElevatedButton.icon(
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: const Icon(Icons.arrow_back, size: 16),
              label: Text(
                'التالي',
                style: TextStyle(
                  fontSize: isSmallHeight ? 13 : 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primarySkyBlue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallHeight ? 12 : 18,
                  vertical: isSmallHeight ? 6 : 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 3,
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: () {
                LevelTestDialog.show(context,
                    letters: letters, lessonId: widget.lessonId);
              },
              icon: const Icon(Icons.check_circle, size: 18),
              label: Text(
                'بدء الاختبار',
                style: TextStyle(
                  fontSize: isSmallHeight ? 13 : 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.successGreen,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallHeight ? 14 : 20,
                  vertical: isSmallHeight ? 6 : 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
              ),
            ),
        ],
      ),
    );
  }

  // سهم تنقل جانبي عائم
  Widget _buildNavArrow({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: AppTheme.primarySkyBlue, size: 28),
        ),
      ),
    );
  }

  // صفحة الحرف بالتقسيم الأفقي الذكي (Side-by-Side)
  Widget _buildLetterPage(String letter, bool isSmallHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallHeight ? 24 : 36,
        vertical: isSmallHeight ? 4 : 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1️⃣ الجانب الأيمن: بطاقة الحرف، الصوت، والأمثلة
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.all(isSmallHeight ? 10 : 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primarySkyBlue.withOpacity(0.12),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // صف الحرف + زر الاستماع
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // بطاقة الحرف
                              Container(
                                width: isSmallHeight ? 75 : 95,
                                height: isSmallHeight ? 75 : 95,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white,
                                      AppTheme.lightSkyBlue.withOpacity(0.3),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.primarySkyBlue.withOpacity(0.5),
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primarySkyBlue.withOpacity(0.25),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    letter,
                                    style: TextStyle(
                                      fontSize: isSmallHeight ? 46 : 60,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primarySkyBlue,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 20),

                              // زر الاستماع للصوت
                              GestureDetector(
                                onTap: _playSound,
                                child: Container(
                                  padding: EdgeInsets.all(isSmallHeight ? 12 : 16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.warningOrange,
                                        Colors.orange[400]!,
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.warningOrange.withOpacity(0.4),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.volume_up_rounded,
                                        size: isSmallHeight ? 28 : 36,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'استمع',
                                        style: TextStyle(
                                          fontSize: isSmallHeight ? 10 : 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: isSmallHeight ? 6 : 10),

                          // الكلمات والأمثلة في سطر أفقي مدمج
                          _buildCompactExamplesSection(letter, isSmallHeight),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 14),

          // 2️⃣ الجانب الأيسر: مشغل فيديو رسم الحرف
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.successGreen.withOpacity(0.12),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: LetterVideoPlayer(letter: letter),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // قسم أمثلة الكلمات المدمجة أفقياً
  Widget _buildCompactExamplesSection(String letter, bool isSmallHeight) {
    final examples = LetterExamplesData.getExamples(letter);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: isSmallHeight ? 6 : 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.starYellow.withOpacity(0.8), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, color: AppTheme.starYellow, size: isSmallHeight ? 14 : 18),
              const SizedBox(width: 6),
              Text(
                'كلمات تبدأ بالحرف',
                style: TextStyle(
                  fontSize: isSmallHeight ? 12 : 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallHeight ? 6 : 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: examples
                  .map((example) => _buildCompactExampleCard(example, isSmallHeight))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactExampleCard(Map<String, String> example, bool isSmallHeight) {
    final cardWidth = isSmallHeight ? 65.0 : 78.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: cardWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: cardWidth,
            height: isSmallHeight ? 48 : 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Text(
                example['emoji'] ?? '🌟',
                style: TextStyle(fontSize: isSmallHeight ? 28 : 34),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            example['word'] ?? '',
            style: TextStyle(
              fontSize: isSmallHeight ? 11 : 13,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('هل تريد الخروج؟', textAlign: TextAlign.center),
        content: const Text(
          'لم تنهِ جميع الحروف بعد. هل تريد الخروج للرئيسية؟',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('متابعة التعلم'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('خروج', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
