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

  @override
  void didUpdateWidget(LetterVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.letter != widget.letter) {
      _controller?.dispose();
      _isInitialized = false;
      _hasError = false;
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    final fileName = _getLetterFileName(widget.letter);
    final assetPath = 'assets/videos/letters/$fileName.mp4';

    try {
      if (kIsWeb) {
        final encodedFileName = Uri.encodeComponent('$fileName.mp4');
        final webUri = Uri.base.resolve('assets/videos/letters/$encodedFileName');
        
        try {
          _controller = VideoPlayerController.networkUrl(webUri);
          await _controller!.initialize();
        } catch (e) {
          _controller?.dispose();
          _controller = VideoPlayerController.asset(assetPath);
          await _controller!.initialize();
        }
      } else {
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
    final size = MediaQuery.of(context).size;
    final isSmallHeight = size.height < 450;

    return Padding(
      padding: EdgeInsets.all(isSmallHeight ? 8 : 14),
      child: Column(
        children: [
          // شريط عنوان الفيديو
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.brush_rounded,
                  color: AppTheme.successGreen, size: isSmallHeight ? 16 : 22),
              const SizedBox(width: 6),
              Text(
                'شاهد كيف يُكتب الحرف',
                style: TextStyle(
                  fontSize: isSmallHeight ? 13 : 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primarySkyBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallHeight ? 4 : 8),

          // منطقة الفيديو
          Expanded(
            child: _hasError
                ? _buildErrorWidget(isSmallHeight)
                : !_isInitialized
                    ? _buildLoadingWidget(isSmallHeight)
                    : _buildVideoWidget(isSmallHeight),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget(bool isSmallHeight) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.primarySkyBlue,
            strokeWidth: isSmallHeight ? 2.5 : 3.5,
          ),
          const SizedBox(height: 8),
          Text(
            'جاري تجهيز الفيديو...',
            style: TextStyle(
              fontSize: isSmallHeight ? 11 : 13,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(bool isSmallHeight) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: isSmallHeight ? 36 : 48,
            color: AppTheme.primarySkyBlue.withOpacity(0.6),
          ),
          const SizedBox(height: 6),
          Text(
            'فيديو رسم الحرف ${widget.letter}',
            style: TextStyle(
              fontSize: isSmallHeight ? 13 : 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.primarySkyBlue,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _hasError = false;
                _isInitialized = false;
              });
              _initializeVideo();
            },
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('إعادة المحاولة', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primarySkyBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoWidget(bool isSmallHeight) {
    return Column(
      children: [
        // مشغل الفيديو
        Expanded(
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio > 0
                    ? _controller!.value.aspectRatio
                    : 16 / 9,
                child: VideoPlayer(_controller!),
              ),
            ),
          ),
        ),
        SizedBox(height: isSmallHeight ? 4 : 8),

        // شريط التقدم والتحكم المدمج
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // زر التشغيل/الإيقاف
            InkWell(
              onTap: () {
                setState(() {
                  if (_controller!.value.isPlaying) {
                    _controller!.pause();
                  } else {
                    _controller!.play();
                  }
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  _controller!.value.isPlaying
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_filled_rounded,
                  size: isSmallHeight ? 28 : 36,
                  color: AppTheme.primarySkyBlue,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // شريط التقدم
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: VideoProgressIndicator(
                  _controller!,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: AppTheme.primarySkyBlue,
                    bufferedColor: AppTheme.lightSkyBlue,
                    backgroundColor: Colors.grey[200]!,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // زر إعادة التشغيل
            InkWell(
              onTap: () {
                _controller!.seekTo(Duration.zero);
                _controller!.play();
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.replay_rounded,
                  size: isSmallHeight ? 22 : 28,
                  color: AppTheme.successGreen,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
