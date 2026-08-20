import 'package:flutter/material.dart';
import '../data/character_data.dart';

class ThemeProvider extends ChangeNotifier {
  Color _primaryColor = Color(0xFF87CEEB); // اللون الافتراضي
  Color _secondaryColor = Color(0xFFB0E0E6);

  Color get primaryColor => _primaryColor;
  Color get secondaryColor => _secondaryColor;

  void updateTheme(String characterId) {
    final character = CharactersData.getCharacter(characterId);
    if (character != null) {
      _primaryColor = character.primaryColor;
      _secondaryColor = character.secondaryColor;
      notifyListeners();
      print('🎨 تم تغيير الثيم إلى: ${character.name}');
    }
  }

  // الألوان الثابتة الأخرى
  static const Color starYellow = Color(0xFFFFC107);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFF757575);
  static const Color backgroundLight = Color(0xFFFAFAFA);
}
