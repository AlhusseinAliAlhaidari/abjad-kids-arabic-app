import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import '../theme/app_theme.dart';
import '../data/pronunciation_lessons_data.dart';
import '../services/database_service.dart';
import 'basic_level_test_screen.dart';
import 'dart:math';

class PronunciationLessonScreen extends StatefulWidget {
  final PronunciationLevel level;
  final String lessonId;

  const PronunciationLessonScreen({
    Key? key,
    required this.level,
    required this.lessonId,
  }) : super(key: key);

  @override
  State<PronunciationLessonScreen> createState() =>
      _PronunciationLessonScreenState();
}

class _PronunciationLessonScreenState extends State<PronunciationLessonScreen>
    with SingleTickerProviderStateMixin {
  int _currentWordIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late stt.SpeechToText _speech;
  late AudioRecorder _recorder;
  bool _isListening = false;
  bool _speechAvailable = false;
  String _recognizedText = '';
  bool _showResult = false;
  bool _isCorrect = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _recorder = AudioRecorder();

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializeSpeech() async {
    if (kIsWeb) {
      setState(() {
        _speechAvailable = false;
      });
      return;
    }

    _speech = stt.SpeechToText();
    try {
      _speechAvailable = await _speech.initialize(
        onStatus: (status) => print('🎤 حالة التعرف: $status'),
        onError: (error) => print('❌ خطأ في التعرف: $error'),
      );
      setState(() {});
    } catch (e) {
      print('❌ فشل تهيئة التعرف على الصوت: $e');
      setState(() {
        _speechAvailable = false;
      });
    }
  }

  Future<void> _playWordAudio() async {
    final word = widget.level.words[_currentWordIndex];
    try {
      print('🔊 محاولة تشغيل الصوت: ${word.audioPath}');
      await _audioPlayer.stop(); // إيقاف أي صوت سابق
      await _audioPlayer.play(AssetSource(word.audioPath));
      print('✅ تم تشغيل صوت: ${word.word}');
    } catch (e) {
      print('❌ خطأ في تشغيل الصوت: $e');
      print('❌ المسار المطلوب: ${word.audioPath}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('عذراً، الصوت غير متوفر: ${word.word}'),
            duration: Duration(seconds: 2),
            backgroundColor: AppTheme.warningOrange,
          ),
        );
      }
    }
  }

  Future<void> _startListening() async {
    if (kIsWeb) {
      _showWebNotSupported();
      return;
    }

    if (!_speechAvailable) {
      _showSpeechNotAvailable();
      return;
    }

    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      _showPermissionDenied();
      return;
    }

    setState(() {
      _isListening = true;
      _showResult = false;
      _recognizedText = '';
    });

    try {
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _recognizedText = result.recognizedWords;
            print('🎤 تم التعرف على: $_recognizedText');
          });
        },
        localeId: 'ar_SA',
        listenFor: Duration(seconds: 5),
        pauseFor: Duration(seconds: 3),
      );

      Future.delayed(Duration(seconds: 5), () {
        if (_isListening) {
          _stopListening();
        }
      });
    } catch (e) {
      print('❌ خطأ في بدء الاستماع: $e');
      setState(() {
        _isListening = false;
      });
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() {
      _isListening = false;
    });
    _checkPronunciation();
  }

  void _checkPronunciation() {
    final targetWord = widget.level.words[_currentWordIndex].word;
    final similarity = _calculateSimilarity(_recognizedText, targetWord);

    print('🔍 المقارنة: "$_recognizedText" vs "$targetWord" = $similarity%');

    setState(() {
      _isCorrect = similarity >= 70;
      _showResult = true;
    });

    if (_isCorrect) {
      _playEncouragementSound();
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          _nextWord();
        }
      });
    }
  }

  int _calculateSimilarity(String recognized, String target) {
    recognized = recognized.trim().replaceAll(RegExp(r'[\u064B-\u065F]'), '');
    target = target.trim().replaceAll(RegExp(r'[\u064B-\u065F]'), '');

    if (recognized.isEmpty) return 0;
    if (recognized == target) return 100;
    if (recognized.contains(target) || target.contains(recognized)) return 85;

    int matches = 0;
    for (int i = 0; i < recognized.length && i < target.length; i++) {
      if (recognized[i] == target[i]) matches++;
    }

    return ((matches / target.length) * 100).round();
  }

  Future<void> _playEncouragementSound() async {
    final sounds = ['أحسنت.mp3', 'ممتاز.mp3', 'رائع.mp3', 'جيد.mp3'];
    final random = Random();
    final sound = sounds[random.nextInt(sounds.length)];

    try {
      await _audioPlayer.play(AssetSource('audio/encouragement/$sound'));
    } catch (e) {
      print('❌ خطأ في تشغيل صوت التشجيع: $e');
    }
  }

  void _nextWord() {
    setState(() {
      _showResult = false;
      _recognizedText = '';

      if (_currentWordIndex < widget.level.words.length - 1) {
        _currentWordIndex++;
        _pageController.animateToPage(
          _currentWordIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _completeLesson();
      }
    });
  }

  void _completeLesson() {
    DatabaseService.completeLesson(widget.lessonId, 3);
    Navigator.pop(context);
  }

  void _showWebNotSupported() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('غير متوفر على الويب',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('ميزة التعرف على الصوت متوفرة فقط على تطبيق الهاتف.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _showSpeechNotAvailable() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('غير متوفر', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('التعرف على الصوت غير متوفر على هذا الجهاز.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _showPermissionDenied() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('أذونات الميكروفون',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('نحتاج إلى إذن الميكروفون للتعرف على نطقك.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _speech.stop();
    _recorder.dispose();
    _pulseController.dispose();
    _pageController.dispose();
    super.dispose();
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
                      itemCount: widget.level.words.length,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() {
                          _currentWordIndex = index;
                          _showResult = false;
                          _recognizedText = '';
                        });
                      },
                      itemBuilder: (context, index) =>
                          _buildWordPage(widget.level.words[index]),
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
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              // مؤشر التقدم
              Positioned(
                top: 20,
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
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Text(
                      '${_currentWordIndex + 1} / ${widget.level.words.length}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primarySkyBlue,
                      ),
                    ),
                  ),
                ),
              ),

              // زر إنهاء الدرس
              if (_currentWordIndex == widget.level.words.length - 1)
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _completeLesson,
                      child: Text('إنهاء الدرس',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.successGreen,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
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

  Widget _buildWordPage(PronunciationWord word) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),

            // الصورة
            Hero(
              tag: 'word_${word.word}',
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primarySkyBlue.withOpacity(0.3),
                      blurRadius: 25,
                      offset: Offset(0, 15),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: _buildWordImage(word),
                ),
              ),
            ),

            SizedBox(height: 40),

            // الكلمة
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primarySkyBlue, AppTheme.lightSkyBlue],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primarySkyBlue.withOpacity(0.4),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Text(
                word.word,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 40),

            // زر الاستماع
            ElevatedButton.icon(
              onPressed: _playWordAudio,
              icon: Icon(Icons.volume_up, size: 32),
              label: Text('استمع للنطق',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.successGreen,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                elevation: 5,
              ),
            ),

            SizedBox(height: 30),

            // زر الميكروفون
            ScaleTransition(
              scale:
                  _isListening ? _pulseAnimation : AlwaysStoppedAnimation(1.0),
              child: GestureDetector(
                onTap: _isListening ? null : _startListening,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: _isListening
                          ? [Colors.red, Colors.redAccent]
                          : [AppTheme.warningOrange, Colors.orange[300]!],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (_isListening ? Colors.red : AppTheme.warningOrange)
                                .withOpacity(0.5),
                        blurRadius: 25,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    size: 65,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // مؤشر الاستماع
            if (_isListening) _buildListeningIndicator(),

            // النتيجة
            if (_showResult) _buildResult(),

            SizedBox(height: 20),

            // تلميح السحب
            if (!_showResult && !_isListening)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back_ios, color: Colors.grey[400], size: 20),
                  SizedBox(width: 10),
                  Text(
                    'اسحب للكلمة التالية',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_ios,
                      color: Colors.grey[400], size: 20),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildListeningIndicator() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            'أنا أستمع... 🎤',
            style: TextStyle(
                fontSize: 20,
                color: AppTheme.primarySkyBlue,
                fontWeight: FontWeight.bold),
          ),
          if (_recognizedText.isNotEmpty) ...[
            SizedBox(height: 10),
            Text(
              _recognizedText,
              style: TextStyle(
                  fontSize: 22,
                  color: AppTheme.textDark,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResult() {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isCorrect
              ? [AppTheme.successGreen, Colors.green[300]!]
              : [AppTheme.warningOrange, Colors.orange[300]!],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: (_isCorrect ? AppTheme.successGreen : AppTheme.warningOrange)
                .withOpacity(0.4),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            _isCorrect ? Icons.check_circle : Icons.refresh,
            size: 70,
            color: Colors.white,
          ),
          SizedBox(height: 15),
          Text(
            _isCorrect ? 'ممتاز! 🎉' : 'حاول مرة أخرى',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (_isCorrect) ...[
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // الانتقال للاختبار مباشرة
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BasicLevelTestScreen(
                      levelId: widget.level.id,
                      levelName: widget.level.name,
                    ),
                  ),
                );
              },
              child: Text('إنهاء الدرس والبدء بالاختبار',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.starYellow,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showResult = false;
                _recognizedText = '';
              });
            },
            child: Text('حاول مجدداً',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.warningOrange,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          // ],
          // زر الانتقال للاختبار
          if (_currentWordIndex == widget.level.words.length - 1)
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BasicLevelTestScreen(
                        levelId: widget.level.id,
                        levelName: widget.level.name,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.quiz, size: 28),
                label: Text('ابدأ الاختبار',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.starYellow,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  elevation: 8,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWordImage(PronunciationWord word) {
    // إذا كان لون (COLOR:0xFFRRGGBB)
    if (word.imagePath.startsWith('COLOR:')) {
      final colorHex = word.imagePath.substring(6);
      final color = Color(int.parse(colorHex));
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: Colors.white, width: 8),
        ),
      );
    }

    // إذا كان إيموجي (EMOJI:😀)
    if (word.imagePath.startsWith('EMOJI:')) {
      final emoji = word.imagePath.substring(6);
      return Center(
        child: Text(
          emoji,
          style: TextStyle(fontSize: 180),
        ),
      );
    }

    // صورة عادية
    return Image.asset(
      'assets/${word.imagePath}',
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Icon(Icons.image, size: 100, color: Colors.grey),
        );
      },
    );
  }
}
