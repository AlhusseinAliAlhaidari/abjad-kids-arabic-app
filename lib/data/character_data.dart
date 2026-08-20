import 'package:flutter/material.dart';

class AnimalCharacter {
  final String id;
  final String name;
  final String imagePath;
  final int price;
  final Color primaryColor;
  final Color secondaryColor;
  final String category; // 'رخيص', 'متوسط', 'غالي', 'نادر'

  const AnimalCharacter({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.primaryColor,
    required this.secondaryColor,
    required this.category,
  });
}

class CharactersData {
  // حيوانات رخيصة (10-30 نقطة)
  static const cheap = [
    AnimalCharacter(
      id: 'قطة',
      name: 'قطة',
      imagePath: 'images/animals/قطة.jpg',
      price: 0, // مجاني - الحيوان الافتراضي
      primaryColor: Color(0xFFFF9800),
      secondaryColor: Color(0xFFFFE0B2),
      category: 'افتراضي',
    ),
    AnimalCharacter(
      id: 'كلب',
      name: 'كلب',
      imagePath: 'images/animals/كلب.jpg',
      price: 10,
      primaryColor: Color(0xFF8D6E63),
      secondaryColor: Color(0xFFD7CCC8),
      category: 'رخيص',
    ),
    AnimalCharacter(
      id: 'أرنب',
      name: 'أرنب',
      imagePath: 'images/animals/أرنب.jpg',
      price: 15,
      primaryColor: Color(0xFFE0E0E0),
      secondaryColor: Color(0xFFF5F5F5),
      category: 'رخيص',
    ),
    AnimalCharacter(
      id: 'دجاجة',
      name: 'دجاجة',
      imagePath: 'images/animals/دجاجة.jpg',
      price: 20,
      primaryColor: Color(0xFFFFF176),
      secondaryColor: Color(0xFFFFF9C4),
      category: 'رخيص',
    ),
    AnimalCharacter(
      id: 'ديك',
      name: 'ديك',
      imagePath: 'images/animals/ديك.jpg',
      price: 25,
      primaryColor: Color(0xFFE53935),
      secondaryColor: Color(0xFFFFCDD2),
      category: 'رخيص',
    ),
    AnimalCharacter(
      id: 'خروف',
      name: 'خروف',
      imagePath: 'images/animals/خروف.jpg',
      price: 30,
      primaryColor: Color(0xFFEEEEEE),
      secondaryColor: Color(0xFFFAFAFA),
      category: 'رخيص',
    ),
    AnimalCharacter(
      id: 'بقرة',
      name: 'بقرة',
      imagePath: 'images/animals/بقرة.jpg',
      price: 30,
      primaryColor: Color(0xFF424242),
      secondaryColor: Color(0xFFE0E0E0),
      category: 'رخيص',
    ),
  ];

  // حيوانات متوسطة (40-80 نقطة)
  static const medium = [
    AnimalCharacter(
      id: 'خيل',
      name: 'حصان',
      imagePath: 'images/animals/خيل.jpg',
      price: 40,
      primaryColor: Color(0xFF6D4C41),
      secondaryColor: Color(0xFFBCAAA4),
      category: 'متوسط',
    ),
    AnimalCharacter(
      id: 'جمل',
      name: 'جمل',
      imagePath: 'images/animals/جمل.jpg',
      price: 45,
      primaryColor: Color(0xFFD4A574),
      secondaryColor: Color(0xFFEFD5B5),
      category: 'متوسط',
    ),
    AnimalCharacter(
      id: 'حمار',
      name: 'حمار',
      imagePath: 'images/animals/حمار.jpg',
      price: 50,
      primaryColor: Color(0xFF9E9E9E),
      secondaryColor: Color(0xFFE0E0E0),
      category: 'متوسط',
    ),
    AnimalCharacter(
      id: 'فأر',
      name: 'فأر',
      imagePath: 'images/animals/فأر.jpg',
      price: 55,
      primaryColor: Color(0xFF757575),
      secondaryColor: Color(0xFFBDBDBD),
      category: 'متوسط',
    ),
    AnimalCharacter(
      id: 'ضفدع',
      name: 'ضفدع',
      imagePath: 'images/animals/ضفدع.jpg',
      price: 60,
      primaryColor: Color(0xFF66BB6A),
      secondaryColor: Color(0xFFC8E6C9),
      category: 'متوسط',
    ),
    AnimalCharacter(
      id: 'نحلة',
      name: 'نحلة',
      imagePath: 'images/animals/نحلة.jpg',
      price: 65,
      primaryColor: Color(0xFFFFEB3B),
      secondaryColor: Color(0xFF424242),
      category: 'متوسط',
    ),
    AnimalCharacter(
      id: 'نملة',
      name: 'نملة',
      imagePath: 'images/animals/نملة.jpg',
      price: 70,
      primaryColor: Color(0xFF5D4037),
      secondaryColor: Color(0xFFBCAAA4),
      category: 'متوسط',
    ),
    AnimalCharacter(
      id: 'فراشة',
      name: 'فراشة',
      imagePath: 'images/animals/فراشة.jpg',
      price: 75,
      primaryColor: Color(0xFFE91E63),
      secondaryColor: Color(0xFFF8BBD0),
      category: 'متوسط',
    ),
    AnimalCharacter(
      id: 'خنفساء',
      name: 'خنفساء',
      imagePath: 'images/animals/خنفساء.jpg',
      price: 80,
      primaryColor: Color(0xFF1976D2),
      secondaryColor: Color(0xFFBBDEFB),
      category: 'متوسط',
    ),
  ];

  // حيوانات غالية (90-150 نقطة)
  static const expensive = [
    AnimalCharacter(
      id: 'أسد',
      name: 'أسد',
      imagePath: 'images/animals/أسد.jpg',
      price: 90,
      primaryColor: Color(0xFFFF9800),
      secondaryColor: Color(0xFF6D4C41),
      category: 'غالي',
    ),
    AnimalCharacter(
      id: 'نمر',
      name: 'نمر',
      imagePath: 'images/animals/نمر.jpg',
      price: 100,
      primaryColor: Color(0xFFFF6F00),
      secondaryColor: Color(0xFF424242),
      category: 'غالي',
    ),
    AnimalCharacter(
      id: 'فهد',
      name: 'فهد',
      imagePath: 'images/animals/فهد.jpg',
      price: 110,
      primaryColor: Color(0xFFFFB300),
      secondaryColor: Color(0xFF5D4037),
      category: 'غالي',
    ),
    AnimalCharacter(
      id: 'ذئب',
      name: 'ذئب',
      imagePath: 'images/animals/ذئب.jpg',
      price: 120,
      primaryColor: Color(0xFF616161),
      secondaryColor: Color(0xFFE0E0E0),
      category: 'غالي',
    ),
    AnimalCharacter(
      id: 'دب الباندا',
      name: 'باندا',
      imagePath: 'images/animals/دب الباندا.jpg',
      price: 130,
      primaryColor: Color(0xFF212121),
      secondaryColor: Color(0xFFFAFAFA),
      category: 'غالي',
    ),
    AnimalCharacter(
      id: 'زرافة',
      name: 'زرافة',
      imagePath: 'images/animals/زرافة.jpg',
      price: 135,
      primaryColor: Color(0xFFFFB74D),
      secondaryColor: Color(0xFF6D4C41),
      category: 'غالي',
    ),
    AnimalCharacter(
      id: 'فيل',
      name: 'فيل',
      imagePath: 'images/animals/فيل.jpg',
      price: 140,
      primaryColor: Color(0xFF78909C),
      secondaryColor: Color(0xFFCFD8DC),
      category: 'غالي',
    ),
    AnimalCharacter(
      id: 'قرد',
      name: 'قرد',
      imagePath: 'images/animals/قرد.jpg',
      price: 145,
      primaryColor: Color(0xFF8D6E63),
      secondaryColor: Color(0xFFD7CCC8),
      category: 'غالي',
    ),
    AnimalCharacter(
      id: 'بومة',
      name: 'بومة',
      imagePath: 'images/animals/بومة.jpg',
      price: 150,
      primaryColor: Color(0xFF795548),
      secondaryColor: Color(0xFFD7CCC8),
      category: 'غالي',
    ),
    AnimalCharacter(
      id: 'صقر',
      name: 'صقر',
      imagePath: 'images/animals/صقر.jpg',
      price: 150,
      primaryColor: Color(0xFF5D4037),
      secondaryColor: Color(0xFFBCAAA4),
      category: 'غالي',
    ),
  ];

  // حيوانات نادرة (160-200 نقطة)
  static const rare = [
    AnimalCharacter(
      id: 'دولفين',
      name: 'دولفين',
      imagePath: 'images/animals/دولفين.jpg',
      price: 160,
      primaryColor: Color(0xFF2196F3),
      secondaryColor: Color(0xFFBBDEFB),
      category: 'نادر',
    ),
    AnimalCharacter(
      id: 'حوت',
      name: 'حوت',
      imagePath: 'images/animals/حوت.jpg',
      price: 165,
      primaryColor: Color(0xFF1976D2),
      secondaryColor: Color(0xFF90CAF9),
      category: 'نادر',
    ),
    AnimalCharacter(
      id: 'سمكة القرش',
      name: 'قرش',
      imagePath: 'images/animals/سمكة القرش.jpg',
      price: 170,
      primaryColor: Color(0xFF607D8B),
      secondaryColor: Color(0xFFCFD8DC),
      category: 'نادر',
    ),
    AnimalCharacter(
      id: 'أخطبوط',
      name: 'أخطبوط',
      imagePath: 'images/animals/أخطبوط.jpg',
      price: 175,
      primaryColor: Color(0xFF9C27B0),
      secondaryColor: Color(0xFFE1BEE7),
      category: 'نادر',
    ),
    AnimalCharacter(
      id: 'سلطعون',
      name: 'سلطعون',
      imagePath: 'images/animals/سلطعون.jpg',
      price: 180,
      primaryColor: Color(0xFFE53935),
      secondaryColor: Color(0xFFFFCDD2),
      category: 'نادر',
    ),
    AnimalCharacter(
      id: 'فقمة',
      name: 'فقمة',
      imagePath: 'images/animals/فقمة.jpg',
      price: 185,
      primaryColor: Color(0xFF546E7A),
      secondaryColor: Color(0xFFCFD8DC),
      category: 'نادر',
    ),
    AnimalCharacter(
      id: 'بطريق',
      name: 'بطريق',
      imagePath: 'images/animals/بطريق.jpg',
      price: 190,
      primaryColor: Color(0xFF212121),
      secondaryColor: Color(0xFFFAFAFA),
      category: 'نادر',
    ),
    AnimalCharacter(
      id: 'أوزة',
      name: 'أوزة',
      imagePath: 'images/animals/أوزة.jpg',
      price: 195,
      primaryColor: Color(0xFFF5F5F5),
      secondaryColor: Color(0xFFFF6F00),
      category: 'نادر',
    ),
    AnimalCharacter(
      id: 'ثعبان',
      name: 'ثعبان',
      imagePath: 'images/animals/ثعبان.jpg',
      price: 200,
      primaryColor: Color(0xFF558B2F),
      secondaryColor: Color(0xFFDCEDC8),
      category: 'نادر',
    ),
    AnimalCharacter(
      id: 'قنفذ',
      name: 'قنفذ',
      imagePath: 'images/animals/قنفذ.jpg',
      price: 200,
      primaryColor: Color(0xFF795548),
      secondaryColor: Color(0xFFD7CCC8),
      category: 'نادر',
    ),
  ];

  // جميع الحيوانات
  static List<AnimalCharacter> get allCharacters {
    return [...cheap, ...medium, ...expensive, ...rare];
  }

  // الحصول على حيوان بواسطة ID
  static AnimalCharacter? getCharacter(String id) {
    try {
      return allCharacters.firstWhere((char) => char.id == id);
    } catch (e) {
      return null;
    }
  }

  // الحصول على حيوانات حسب الفئة
  static List<AnimalCharacter> getByCategory(String category) {
    return allCharacters.where((char) => char.category == category).toList();
  }
}
