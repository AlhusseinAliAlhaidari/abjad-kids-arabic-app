import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:audioplayers/audioplayers.dart';
import '../data/placement_test_data.dart';
import '../services/database_service.dart';
import 'home_screen.dart';

class PlacementTestScreen extends StatefulWidget {
  final String childName;
  final int childAge;

  const PlacementTestScreen({
    super.key,
    required this.childName,
    required this.childAge,
  });

  @override
  State<PlacementTestScreen> createState() => _PlacementTestScreenState();
}

class _PlacementTestScreenState extends State<PlacementTestScreen>
    with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late List<TestQuestion> _questions;
  late AnimationController _bounceController;
  late AnimationController _slideController;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _questions = PlacementTestData.getAllQuestions();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideController.forward();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _bounceController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _playSound() async {
    final question = _questions[_currentQuestionIndex];
    if (question.audioPath != null) {
      try {
        await _audioPlayer.play(AssetSource(question.audioPath!));
      } catch (e) {
        print('Error playing sound: $e');
      }
    }
  }

  void _checkAnswer(String selectedAnswer) {
    if (_isAnswered) return;

    setState(() {
      _isAnswered = true;
    });

    final correctAnswer = _questions[_currentQuestionIndex].correctAnswer;
    final isCorrect = selectedAnswer == correctAnswer;

    if (isCorrect) {
      _correctAnswers++;
      _bounceController.forward().then((_) => _bounceController.reverse());
    }

    // إظهار رسالة للنجاح والخطأ
    _showFeedback(isCorrect);

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.of(context).pop();
        _moveToNextQuestion();
      }
    });
  }

  void _moveToNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _isAnswered = false;
      });
      _slideController.reset();
      _slideController.forward();
    } else {
      _showResults();
    }
  }

  void _showFeedback(bool isCorrect) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isCorrect
                  ? [Color(0xFF4CAF50), Color(0xFF81C784)]
                  : [Color(0xFFFF9800), Color(0xFFFFB74D)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCorrect ? Icons.star : Icons.lightbulb,
                color: Colors.white,
                size: 70,
              ),
              const SizedBox(height: 15),
              Text(
                isCorrect ? 'أحسنت! 🎉' : 'حاول مرة أخرى 💪',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResults() {
    final level = PlacementTestData.determineLevelFromScore(_correctAnswers);
    final message = PlacementTestData.getEncouragementMessage(_correctAnswers);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6A11CB),
                  Color(0xFF2575FC),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/characters/arab_kids_celebrating_1764934121585.png',
                  height: 100,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.celebration,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'نتيجتك: $_correctAnswers / ${_questions.length}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    level,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () async {
                    // حفظ نتيجة الاختبار
                    final levelNumber = _getLevelNumber(level);
                    await DatabaseService.savePlacementTestResult(
                      score: _correctAnswers,
                      level: levelNumber,
                    );

                    if (!mounted) return;

                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF2575FC),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'ابدأ التعلم! 🚀',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // تحويل نص المستوى إلى رقم
  int _getLevelNumber(String levelText) {
    if (levelText.contains('1')) return 1;
    if (levelText.contains('2')) return 2;
    if (levelText.contains('3')) return 3;
    if (levelText.contains('4')) return 4;
    if (levelText.contains('5')) return 5;
    return 1; // افتراضي
  }

  void _skipTest() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final question = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/backgrounds/background_pattern_stars_1764934179475.png'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFE5E5),
              Color(0xFFFFF0F0),
              Color(0xFFE5F3FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(screenHeight * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: _skipTest,
                      icon: Icon(Icons.skip_next, color: Color(0xFFFF6B6B)),
                      label: Text(
                        'تخطي',
                        style: TextStyle(
                          fontSize: screenHeight * 0.022,
                          color: Color(0xFFFF6B6B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/characters/arab_child_thinking_1764934154475.png',
                      height: screenHeight * 0.08,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.child_care,
                        size: screenHeight * 0.06,
                        color: AppTheme.primarySkyBlue,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.015,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFFF6B6B).withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        '${_currentQuestionIndex + 1} / ${_questions.length}',
                        style: TextStyle(
                          fontSize: screenHeight * 0.025,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: screenHeight * 0.015,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(1, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _slideController,
                    curve: Curves.easeOutCubic,
                  )),
                  child: _buildQuestionContent(
                      question, screenHeight, screenWidth),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionContent(
      TestQuestion question, double screenHeight, double screenWidth) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.025,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                question.question,
                style: TextStyle(
                  fontSize: screenWidth * 0.045, // أكبر للهواتف
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: screenHeight * 0.025),
            if (question.type == QuestionType.audioToLetter)
              _buildAudioQuestion(question, screenHeight)
            else if (question.type == QuestionType.imageToFirstLetter ||
                question.type == QuestionType.countLetters ||
                question.type == QuestionType.completeWord)
              _buildImageQuestion(question, screenHeight)
            else if (question.type == QuestionType.wordToImage)
              _buildWordToImageQuestion(question, screenHeight, screenWidth)
            else if (question.type == QuestionType.imageToWord)
              _buildImageToWordQuestion(question, screenHeight, screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioQuestion(TestQuestion question, double screenHeight) {
    return Column(
      children: [
        GestureDetector(
          onTap: _playSound,
          child: Container(
            width: screenHeight * 0.18,
            height: screenHeight * 0.18,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFF6B6B).withOpacity(0.4),
                  blurRadius: 18,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              Icons.volume_up,
              size: screenHeight * 0.09,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
        _buildTextOptions(question.options, screenHeight),
      ],
    );
  }

  Widget _buildImageQuestion(TestQuestion question, double screenHeight) {
    return Column(
      children: [
        Container(
          height: screenHeight * 0.25, // أكبر
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Image.asset(
                'assets/${question.imagePath}',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image,
                  size: screenHeight * 0.1,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.025),
        _buildTextOptions(question.options, screenHeight),
      ],
    );
  }

  Widget _buildWordToImageQuestion(
      TestQuestion question, double screenHeight, double screenWidth) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(screenHeight * 0.025),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF2575FC).withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            question.word ?? '',
            style: TextStyle(
              fontSize: screenHeight * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.025),
        LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: screenWidth * 0.03,
                mainAxisSpacing: screenHeight * 0.025,
                childAspectRatio: 0.95, // أفضل للصور
              ),
              itemCount: question.options.length,
              itemBuilder: (context, index) {
                return _buildImageOption(
                    question.options[index], screenHeight, screenWidth);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildImageToWordQuestion(
      TestQuestion question, double screenHeight, double screenWidth) {
    return Column(
      children: [
        Container(
          height: screenHeight * 0.2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/${question.imagePath}',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.image,
                size: screenHeight * 0.08,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.025),
        _buildTextOptions(question.options, screenHeight),
      ],
    );
  }

  Widget _buildTextOptions(List<String> options, double screenHeight) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Wrap(
      spacing: screenWidth * 0.025,
      runSpacing: screenHeight * 0.02,
      alignment: WrapAlignment.center,
      children: options.map((option) {
        return GestureDetector(
          onTap: () => _checkAnswer(option),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06, // أكبر
              vertical: screenHeight * 0.025, // أكبر
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF4CAF50).withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              option,
              style: TextStyle(
                fontSize: screenWidth * 0.065, // أكبر للهواتف
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildImageOption(
      String imagePath, double screenHeight, double screenWidth) {
    return GestureDetector(
      onTap: () => _checkAnswer(imagePath),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Color(0xFF4CAF50),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Image.asset(
              'assets/$imagePath',
              fit: BoxFit.contain, // contain بدلاً من cover
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.image,
                size: screenWidth * 0.12,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
