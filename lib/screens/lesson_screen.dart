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

class _LessonScreenState extends State<LessonScreen> with SingleTickerProviderStateMixin {
  int _currentLetterIndex = 0;
  late final PageController _pageController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlayingAudio = false;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  List<String> get letters => widget.level.targetLetters;
  String get currentLetter => letters[_currentLetterIndex];
  bool get isLastLetter => _currentLetterIndex == letters.length - 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
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

  String _getLetterFullName(String letter) {
    final names = {
      'أ': 'حرف الألف',
      'ب': 'حرف الباء',
      'ت': 'حرف التاء',
      'ث': 'حرف الثاء',
      'ج': 'حرف الجيم',
      'ح': 'حرف الحاء',
      'خ': 'حرف الخاء',
      'د': 'حرف الدال',
      'ذ': 'حرف الذال',
      'ر': 'حرف الراء',
      'ز': 'حرف الزاي',
      'س': 'حرف السين',
      'ش': 'حرف الشين',
      'ص': 'حرف الصاد',
      'ض': 'حرف الضاد',
      'ط': 'حرف الطاء',
      'ظ': 'حرف الظاء',
      'ع': 'حرف العين',
      'غ': 'حرف الغين',
      'ف': 'حرف الفاء',
      'ق': 'حرف القاف',
      'ك': 'حرف الكاف',
      'ل': 'حرف اللام',
      'م': 'حرف الميم',
      'ن': 'حرف النون',
      'ه': 'حرف الهاء',
      'و': 'حرف الواو',
      'ي': 'حرف الياء',
    };
    return names[letter] ?? 'حرف $letter';
  }

  Future<void> _playSound() async {
    try {
      setState(() => _isPlayingAudio = true);
      final audioPath = 'audio/letters/${_getLetterFileName(currentLetter)}.mp3';
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(audioPath));
      _audioPlayer.onPlayerComplete.first.then((_) {
        if (mounted) setState(() => _isPlayingAudio = false);
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isPlayingAudio = false);
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEFF6FF),
              Color(0xFFFFFBEB),
              Color(0xFFF0FDF4),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 650 ||
                  (constraints.maxWidth > constraints.maxHeight && constraints.maxWidth >= 500);

              return Column(
                children: [
                  // 1️⃣ الشريط العلوي التفاعلي المتجاوب
                  _buildHeader(constraints),

                  // 2️⃣ محتوى الحرف والفيديو المدمج والمدروس لعدم الحاجة لأي سكرول
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: letters.length,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() => _currentLetterIndex = index);
                      },
                      itemBuilder: (context, index) {
                        final letter = letters[index];
                        return isWide
                            ? _buildWideLandscapeLayout(letter, constraints)
                            : _buildCompactPortraitLayout(letter, constraints);
                      },
                    ),
                  ),

                  // 3️⃣ شريط التنقل السفلي السهل والمريح لأيدي الأطفال
                  _buildBottomNavBar(constraints),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // 1️⃣ الشريط العلوي (زر الإغلاق + مؤشر النقاط + زر الاختبار إن وجد)
  Widget _buildHeader(BoxConstraints constraints) {
    final isCompact = constraints.maxHeight < 600;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: constraints.maxWidth > 700 ? 32 : 14,
        vertical: isCompact ? 4 : 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // زر الخروج
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _showExitDialog,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.all(isCompact ? 6 : 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red.withValues(alpha: 0.2), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.red[400],
                  size: isCompact ? 18 : 22,
                ),
              ),
            ),
          ),

          // كبسولة التقدم التفاعلية
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 12 : 16,
              vertical: isCompact ? 4 : 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // نقاط تقدم سريعة لجميع الحروف
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(letters.length, (idx) {
                    final isCurrent = idx == _currentLetterIndex;
                    final isPassed = idx < _currentLetterIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 2.5),
                      width: isCurrent ? 18 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? const Color(0xFF0284C7)
                            : isPassed
                                ? const Color(0xFF22C55E)
                                : const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 8),
                Text(
                  '${_currentLetterIndex + 1} / ${letters.length}',
                  style: TextStyle(
                    fontSize: isCompact ? 12 : 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0284C7),
                  ),
                ),
              ],
            ),
          ),

          // زر الاختبار إذا كان في آخر حرف أو عنوان المستوى
          if (isLastLetter)
            ElevatedButton.icon(
              onPressed: _openLevelQuiz,
              icon: const Icon(Icons.star_rounded, size: 18, color: Colors.white),
              label: Text(
                'الاختبار',
                style: TextStyle(
                  fontSize: isCompact ? 12 : 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 10 : 14,
                  vertical: isCompact ? 4 : 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 3,
              ),
            )
          else
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 10 : 12,
                vertical: isCompact ? 4 : 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppTheme.starYellow.withValues(alpha: 0.6),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.school_rounded, size: 16, color: Color(0xFFD97706)),
                  const SizedBox(width: 4),
                  Text(
                    widget.level.title,
                    style: TextStyle(
                      fontSize: isCompact ? 11 : 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF92400E),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // 2️⃣ أ: التصميم العريض للأجهزة اللوحية والشاشات الكبيرة والوضع الأفقي (Landscape / Tablet)
  Widget _buildWideLandscapeLayout(String letter, BoxConstraints constraints) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1050),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🅰️ البطاقة الأولى (اليمين في العربية): الحرف + الصوت + الكلمات المصورة
              Expanded(
                flex: 5,
                child: Container(
                  margin: const EdgeInsets.all(6),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF38BDF8).withValues(alpha: 0.25),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // عنوان الحرف
                      Text(
                        _getLetterFullName(letter),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),

                      // الحرف الكبير ثلاثي الأبعاد مع زر الصوت
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ScaleTransition(
                            scale: _pulseAnimation,
                            child: _buildLetterCircle(letter, size: 85, fontSize: 50),
                          ),
                          const SizedBox(width: 20),
                          _buildSoundButton(isLarge: true),
                        ],
                      ),

                      const Divider(height: 20, thickness: 1, color: Color(0xFFF1F5F9)),

                      // الكلمات المصورة
                      _buildWordExamplesSection(letter, isCompact: false),
                    ],
                  ),
                ),
              ),

              // 🅱️ البطاقة الثانية (اليسار في العربية): شاشة السينما للفيديو
              Expanded(
                flex: 6,
                child: Container(
                  margin: const EdgeInsets.all(6),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.25),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LetterVideoPlayer(
                        letter: letter,
                        showTitle: true,
                        compact: constraints.maxHeight < 550,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '✨ المس الشاشة لتشغيل أو إيقاف رسم الحرف',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
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
    );
  }

  // 2️⃣ ب: التصميم الرأسي المدمج المحكم (Mobile Portrait) - بدون أي سكرول
  Widget _buildCompactPortraitLayout(String letter, BoxConstraints constraints) {
    final availableHeight = constraints.maxHeight;
    final isVeryShort = availableHeight < 640;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 14,
            vertical: isVeryShort ? 2 : 6,
          ),
          child: Column(
            children: [
              // 1. بطاقة الحرف العلوية المدمجة
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: isVeryShort ? 6 : 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF38BDF8).withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // دائرة الحرف
                    _buildLetterCircle(
                      letter,
                      size: isVeryShort ? 50 : 60,
                      fontSize: isVeryShort ? 30 : 36,
                    ),
                    const SizedBox(width: 12),

                    // اسم الحرف وتوجيه
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _getLetterFullName(letter),
                            style: TextStyle(
                              fontSize: isVeryShort ? 15 : 17,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'تعلم نطق ورسم الحرف',
                            style: TextStyle(
                              fontSize: isVeryShort ? 11 : 12,
                              color: Colors.blueGrey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // زر الاستماع للصوت
                    _buildSoundButton(isLarge: false, compact: isVeryShort),
                  ],
                ),
              ),

              SizedBox(height: isVeryShort ? 6 : 8),

              // 2. منطقة الفيديو المدمجة
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: isVeryShort ? 4 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF22C55E).withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SizedBox(
                        width: constraints.maxWidth > 400 ? 400 : constraints.maxWidth - 30,
                        child: LetterVideoPlayer(
                          letter: letter,
                          showTitle: !isVeryShort,
                          compact: isVeryShort,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: isVeryShort ? 6 : 8),

              // 3. شريط الكلمات المصورة
              _buildWordExamplesSection(letter, isCompact: isVeryShort),
            ],
          ),
        ),
      ),
    );
  }

  // دائرة الحرف ثلاثية الأبعاد المبهجة
  Widget _buildLetterCircle(String letter, {required double size, required double fontSize}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE0F2FE),
            Color(0xFFBAE6FD),
          ],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF0284C7),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0369A1),
            height: 1.1,
          ),
        ),
      ),
    );
  }

  // زر الاستماع للصوت
  Widget _buildSoundButton({bool isLarge = false, bool compact = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _playSound,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: isLarge ? 18 : (compact ? 10 : 14),
            vertical: isLarge ? 12 : (compact ? 7 : 9),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isPlayingAudio
                  ? [const Color(0xFF22C55E), const Color(0xFF16A34A)]
                  : [const Color(0xFFF97316), const Color(0xFFEA580C)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: (_isPlayingAudio ? const Color(0xFF16A34A) : const Color(0xFFEA580C))
                    .withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _isPlayingAudio ? Icons.graphic_eq_rounded : Icons.volume_up_rounded,
                size: isLarge ? 24 : (compact ? 18 : 20),
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                _isPlayingAudio ? 'يقرأ...' : 'استمع',
                style: TextStyle(
                  fontSize: isLarge ? 15 : (compact ? 12 : 13),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // بطاقة الكلمات المصورة
  Widget _buildWordExamplesSection(String letter, {required bool isCompact}) {
    final examples = LetterExamplesData.getExamples(letter);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 10 : 14,
        vertical: isCompact ? 6 : 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFDE68A),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_awesome_rounded, color: Color(0xFFD97706), size: 15),
              const SizedBox(width: 5),
              Text(
                'كلمات تبدأ بحرف ($letter)',
                style: TextStyle(
                  fontSize: isCompact ? 11 : 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF92400E),
                ),
              ),
            ],
          ),
          SizedBox(height: isCompact ? 4 : 8),
          if (examples.isEmpty)
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                'حرف $letter من الحروف الجميلة',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: examples.take(3).map((e) => _buildWordChip(e, isCompact)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildWordChip(Map<String, String> example, bool isCompact) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 3 : 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFFEF08A),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            example['emoji'] ?? '⭐',
            style: TextStyle(fontSize: isCompact ? 16 : 20),
          ),
          const SizedBox(width: 5),
          Text(
            example['word'] ?? '',
            style: TextStyle(
              fontSize: isCompact ? 12 : 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  // 3️⃣ شريط التنقل السفلي المريح
  Widget _buildBottomNavBar(BoxConstraints constraints) {
    final isCompact = constraints.maxHeight < 600;

    return Padding(
      padding: EdgeInsets.only(
        left: constraints.maxWidth > 700 ? 32 : 14,
        right: constraints.maxWidth > 700 ? 32 : 14,
        bottom: isCompact ? 4 : 8,
        top: 2,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Row(
            children: [
              // زر السابق
              if (_currentLetterIndex > 0)
                Expanded(
                  flex: 1,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    label: Text(
                      'السابق',
                      style: TextStyle(
                        fontSize: isCompact ? 12 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF475569),
                      elevation: 2,
                      padding: EdgeInsets.symmetric(vertical: isCompact ? 8 : 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.withValues(alpha: 0.25)),
                      ),
                    ),
                  ),
                )
              else
                const Spacer(flex: 1),

              const SizedBox(width: 14),

              // زر التالي أو زر الاختبار عند آخر حرف
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (isLastLetter) {
                      _openLevelQuiz();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  icon: Icon(
                    isLastLetter ? Icons.stars_rounded : Icons.arrow_back_ios_new_rounded,
                    size: isLastLetter ? 22 : 16,
                    color: Colors.white,
                  ),
                  label: Text(
                    isLastLetter ? 'بدء اختبار المستوى 🎯' : 'الحرف التالي',
                    style: TextStyle(
                      fontSize: isCompact ? 13 : 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLastLetter
                        ? const Color(0xFF16A34A)
                        : const Color(0xFF0284C7),
                    elevation: 4,
                    padding: EdgeInsets.symmetric(vertical: isCompact ? 9 : 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: (isLastLetter ? const Color(0xFF16A34A) : const Color(0xFF0284C7))
                        .withValues(alpha: 0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openLevelQuiz() {
    LevelTestDialog.show(
      context,
      letters: letters,
      lessonId: widget.lessonId,
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.door_front_door_rounded, color: Color(0xFFF59E0B), size: 24),
            SizedBox(width: 8),
            Text('هل تريد الخروج؟', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'لم تكمل جميع حروف هذا المستوى بعد. هل تريد العودة للشاشة الرئيسية؟',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'متابعة التعلم',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('خروج', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
