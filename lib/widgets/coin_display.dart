import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CoinDisplay extends StatelessWidget {
  final int coins;
  final bool showAnimation;

  const CoinDisplay({
    super.key,
    required this.coins,
    this.showAnimation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // أيقونة العملة
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.coinGold,
                  AppTheme.starYellow,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.coinGold.withOpacity(0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                '🪙',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // عدد العملات
          Text(
            coins.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
