import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../theme/app_theme.dart';

class LetterVideoPlayer extends StatefulWidget {
  final String letter;
  final bool showTitle;
  final bool compact;

  const LetterVideoPlayer({
    super.key,
    required this.letter,
    this.showTitle = true,
    this.compact = false,
  });

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
      debugPrint('❌ خطأ في تحميل الفيديو: $e');
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showTitle)
          Padding(
            padding: EdgeInsets.only(
              top: widget.compact ? 2 : 6,
              bottom: widget.compact ? 4 : 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_note_rounded,
                    color: AppTheme.successGreen,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'طريقة كتابة الحرف (${widget.letter})',
                  style: TextStyle(
                    fontSize: widget.compact ? 12 : 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
          ),

        // منطقة الفيديو
        if (_hasError)
          _buildErrorWidget()
        else if (!_isInitialized)
          _buildLoadingWidget()
        else
          _buildVideoWidget(),
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      height: widget.compact ? 130 : 170,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                color: AppTheme.primarySkyBlue,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'جاري تحضير رسم الحرف...',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: widget.compact ? 130 : 170,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFECDD3),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_lesson_rounded,
              size: 32,
              color: AppTheme.warningOrange.withValues(alpha: 0.8),
            ),
            const SizedBox(height: 6),
            Text(
              'فيديو كتابة حرف (${widget.letter})',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 6),
            InkWell(
              onTap: () {
                setState(() {
                  _hasError = false;
                  _isInitialized = false;
                });
                _initializeVideo();
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.primarySkyBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'إعادة التحميل',
                      style: TextStyle(
                        fontSize: 11,
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
      ),
    );
  }

  Widget _buildVideoWidget() {
    final aspect = _controller!.value.aspectRatio > 0
        ? _controller!.value.aspectRatio
        : 16 / 9;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الفيديو مع إمكانية الضغط للتشغيل والإيقاف
            GestureDetector(
              onTap: _togglePlay,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: aspect,
                    child: VideoPlayer(_controller!),
                  ),
                  if (!_controller!.value.isPlaying)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white70, width: 2),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),

            // شريط التحكم الصغير المدمج
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.compact ? 8 : 12,
                vertical: widget.compact ? 3 : 5,
              ),
              color: const Color(0xFF1E293B),
              child: Row(
                children: [
                  // زر تشغيل / إيقاف
                  InkWell(
                    onTap: _togglePlay,
                    borderRadius: BorderRadius.circular(15),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Icon(
                        _controller!.value.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: widget.compact ? 20 : 24,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 6),

                  // شريط التقدم
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        height: 6,
                        child: VideoProgressIndicator(
                          _controller!,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            playedColor: const Color(0xFF38BDF8),
                            bufferedColor: const Color(0xFF0284C7).withValues(alpha: 0.5),
                            backgroundColor: Colors.white24,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 6),

                  // زر إعادة
                  InkWell(
                    onTap: () {
                      _controller!.seekTo(Duration.zero);
                      _controller!.play();
                      setState(() {});
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Icon(
                        Icons.replay_rounded,
                        size: widget.compact ? 18 : 22,
                        color: const Color(0xFF4ADE80),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _togglePlay() {
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }
}
