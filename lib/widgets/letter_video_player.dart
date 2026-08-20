import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../theme/app_theme.dart';

class LetterVideoPlayer extends StatefulWidget {
  final String letter;

  const LetterVideoPlayer({super.key, required this.letter});

  @override
  State<LetterVideoPlayer> createState() => _LetterVideoPlayerState();
}

class _LetterVideoPlayerState extends State<LetterVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final fileName = _getLetterFileName(widget.letter);
    try {
      if (kIsWeb) {
        // على الويب: flutter يُخدِّم assets عبر HTTP تحت assets/
        final uri = Uri.base.resolve('assets/videos/letters/$fileName.mp4');
        print('🎥 [Web] تحميل الفيديو: $uri');
        _controller = VideoPlayerController.networkUrl(uri);
      } else {
        final assetPath = 'assets/videos/letters/$fileName.mp4';
        print('🎥 [Native] تحميل الفيديو: $assetPath');
        _controller = VideoPlayerController.asset(assetPath);
      }

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = false;
        });
        _controller!.play();
        _controller!.setLooping(true);
      }
    } catch (e) {
      print('❌ خطأ في تحميل الفيديو: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
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
    return fileNames[letter] ?? 'أ - ألف';
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppTheme.successGreen.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_circle, color: AppTheme.successGreen, size: 28),
              SizedBox(width: 10),
              Text(
                'فيديو رسم الحرف',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primarySkyBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),

          if (_hasError)
            _buildErrorWidget()
          else if (!_isInitialized)
            _buildLoadingWidget()
          else
            _buildVideoWidget(),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppTheme.primarySkyBlue),
            SizedBox(height: 10),
            Text(
              'جاري تحميل الفيديو...',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 60,
            color: AppTheme.primarySkyBlue.withOpacity(0.5),
          ),
          SizedBox(height: 15),
          Text(
            'فيديو رسم الحرف ${widget.letter}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primarySkyBlue,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.lightSkyBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  'الفيديوهات متوفرة في تطبيق الهاتف',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  'يمكنك متابعة التعلم باستخدام الصوت والأمثلة',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoWidget() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // زر التشغيل/الإيقاف
            IconButton(
              icon: Icon(
                _controller!.value.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                size: 50,
                color: AppTheme.primarySkyBlue,
              ),
              onPressed: () {
                setState(() {
                  if (_controller!.value.isPlaying) {
                    _controller!.pause();
                  } else {
                    _controller!.play();
                  }
                });
              },
            ),
            SizedBox(width: 20),
            // زر إعادة التشغيل
            IconButton(
              icon: Icon(Icons.replay, size: 40, color: AppTheme.successGreen),
              onPressed: () {
                _controller!.seekTo(Duration.zero);
                _controller!.play();
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        // شريط التقدم
        VideoProgressIndicator(
          _controller!,
          allowScrubbing: true,
          colors: VideoProgressColors(
            playedColor: AppTheme.primarySkyBlue,
            bufferedColor: AppTheme.lightSkyBlue,
            backgroundColor: Colors.grey[300]!,
          ),
        ),
      ],
    );
  }
}
