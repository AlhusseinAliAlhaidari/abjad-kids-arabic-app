import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StarRating extends StatelessWidget {
  final int stars; // 0-3
  final double size;
  final bool showAnimation;

  const StarRating({
    super.key,
    required this.stars,
    this.size = 32,
    this.showAnimation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final isFilled = index < stars;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: _StarIcon(
            isFilled: isFilled,
            size: size,
            delay: showAnimation ? Duration(milliseconds: index * 200) : Duration.zero,
          ),
        );
      }),
    );
  }
}

class _StarIcon extends StatefulWidget {
  final bool isFilled;
  final double size;
  final Duration delay;

  const _StarIcon({
    required this.isFilled,
    required this.size,
    required this.delay,
  });

  @override
  State<_StarIcon> createState() => _StarIconState();
}

class _StarIconState extends State<_StarIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    if (widget.isFilled && widget.delay != Duration.zero) {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    } else if (widget.isFilled) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Icon(
        widget.isFilled ? Icons.star : Icons.star_border,
        color: widget.isFilled ? AppTheme.starYellow : Colors.grey[400],
        size: widget.size,
        shadows: widget.isFilled
            ? [
                Shadow(
                  color: AppTheme.starYellow.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ]
            : null,
      ),
    );
  }
}
