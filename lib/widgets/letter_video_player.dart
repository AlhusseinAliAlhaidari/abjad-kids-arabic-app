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
    final assetPath = 'assets/videos/letters/$fileName.mp4';

    try {
      if (kIsWeb) {
        // تجربة تحميل الفيديو عبر الرابط المرمز المناسب للمتصفحات و Vercel
        final encodedFileName = Uri.encodeComponent('$fileName.mp4');
        final webUri = Uri.base.resolve('assets/videos/letters/$encodedFileName');
        print('🎥 [Web] تحميل الفيديو المرمز: $webUri');
        
        try {
          _controller = VideoPlayerController.networkUrl(webUri);
          await _controller!.initialize();
        } catch (webErr) {
          print('⚠️ المحاولة الأولى فشلت، جاري تجربة controller.asset: $webErr');
          _controller?.dispose();
          _controller = VideoPlayerController.asset(assetPath);
          await _controller!.initialize();
        }
      } else {
        print('🎥 [Native] تحميل الفيديو: $assetPath');
        _controller = VideoPlayerController.asset(assetPath);
        await _controller!.initialize();
      }

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = false;
        });
        _controller!.setLooping(true);
        _controller!.play();
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppTheme.successGreen.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.play_circle, color: AppTheme.successGreen, size: 28),
              const SizedBox(width: 10),
              const Text(
                'فيديو رسم الحرف',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primarySkyBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

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
    return const SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppTheme.primarySkyBlue),
            SizedBox(height: 10),
            Text(
              'جاري تحميل الفيديو...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 60,
            color: AppTheme.primarySkyBlue.withOpacity(0.5),
          ),
          const SizedBox(height: 15),
          Text(
            'فيديو رسم الحرف ${widget.letter}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primarySkyBlue,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.lightSkyBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _hasError = false;
                      _isInitialized = false;
                    });
                    _initializeVideo();
                  },
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('إعادة المحاولة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primarySkyBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
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
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.replay, size: 40, color: AppTheme.successGreen),
              onPressed: () {
                _controller!.seekTo(Duration.zero);
                _controller!.play();
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
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
