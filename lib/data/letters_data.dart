class ArabicLetter {
  final String letter;
  final String name;
  final String audioPath;
  final String videoPath;
  final List<String> examples; // كلمات تبدأ بالحرف
  final Map<String, String> harakatAudio; // الحركات: فتحة، ضمة، كسرة

  ArabicLetter({
    required this.letter,
    required this.name,
    required this.audioPath,
    required this.videoPath,
    required this.examples,
    required this.harakatAudio,
  });
}

// بيانات الحروف العربية
class LettersData {
  static final List<ArabicLetter> allLetters = [
    ArabicLetter(
      letter: 'أ',
      name: 'ألف',
      audioPath: 'assets/audio/letters/أ - ألف.mp3',
      videoPath: 'assets/videos/letters/أ - ألف.mp4',
      examples: ['إوزة', 'أرجوحة', 'أرنب'],
      harakatAudio: {
        'fatha': 'assets/audio/letters_with_harakat/l - kk.mp3',
        'damma': 'assets/audio/letters_with_harakat/l - lw.mp3',
        'kasra': 'assets/audio/letters_with_harakat/l - ny.mp3',
      },
    ),
    ArabicLetter(
      letter: 'ب',
      name: 'باء',
      audioPath: 'assets/audio/letters/ب - باء.mp3',
      videoPath: 'assets/videos/letters/ب - باء.mp4',
      examples: ['بطة', 'بقرة', 'باب'],
      harakatAudio: {
        'fatha': 'assets/audio/letters_with_harakat/ب - با.mp3',
        'damma': 'assets/audio/letters_with_harakat/ب - بو.mp3',
        'kasra': 'assets/audio/letters_with_harakat/ب - بي.mp3',
      },
    ),
    ArabicLetter(
      letter: 'ت',
      name: 'تاء',
      audioPath: 'assets/audio/letters/ت - تاء.mp3',
      videoPath: 'assets/videos/letters/ت - تاء.mp4',
      examples: ['تفاحة', 'تمساح', 'تاج'],
      harakatAudio: {
        'fatha': 'assets/audio/letters_with_harakat/ت - تا.mp3',
        'damma': 'assets/audio/letters_with_harakat/ت - تو.mp3',
        'kasra': 'assets/audio/letters_with_harakat/ت - تي.mp3',
      },
    ),
    ArabicLetter(
      letter: 'ث',
      name: 'ثاء',
      audioPath: 'assets/audio/letters/ث - ثاء.mp3',
      videoPath: 'assets/videos/letters/ث - ثاء.mp4',
      examples: ['ثعلب', 'ثوب', 'ثلج'],
      harakatAudio: {
        'fatha': 'assets/audio/letters_with_harakat/ث - ثا.mp3',
        'damma': 'assets/audio/letters_with_harakat/ث - ثو.mp3',
        'kasra': 'assets/audio/letters_with_harakat/ث - ثي.mp3',
      },
    ),
    ArabicLetter(
      letter: 'ج',
      name: 'جيم',
      audioPath: 'assets/audio/letters/ج - جيم.mp3',
      videoPath: 'assets/videos/letters/ج - جيم.mp4',
      examples: ['جمل', 'جبل', 'جزر'],
      harakatAudio: {
        'fatha': 'assets/audio/letters_with_harakat/ج - جا.mp3',
        'damma': 'assets/audio/letters_with_harakat/ج - جو.mp3',
        'kasra': 'assets/audio/letters_with_harakat/ج - جي.mp3',
      },
    ),
    ArabicLetter(
      letter: 'ح',
      name: 'حاء',
      audioPath: 'assets/audio/letters/ح - حاء.mp3',
      videoPath: 'assets/videos/letters/ح - حاء.mp4',
      examples: ['حصان', 'حوت', 'حليب'],
      harakatAudio: {
        'fatha': 'assets/audio/letters_with_harakat/ح - حا.mp3',
        'damma': 'assets/audio/letters_with_harakat/ح - حو.mp3',
        'kasra': 'assets/audio/letters_with_harakat/ح - حي.mp3',
      },
    ),
    ArabicLetter(
      letter: 'خ',
      name: 'خاء',
      audioPath: 'assets/audio/letters/خ - خاء.mp3',
      videoPath: 'assets/videos/letters/خ - خاء.mp4',
      examples: ['خروف', 'خيار', 'خبز'],
      harakatAudio: {
        'fatha': 'assets/audio/letters_with_harakat/خ - خا.mp3',
        'damma': 'assets/audio/letters_with_harakat/خ - خو.mp3',
        'kasra': 'assets/audio/letters_with_harakat/خ - خي.mp3',
      },
    ),
    ArabicLetter(
      letter: 'د',
      name: 'دال',
      audioPath: 'assets/audio/letters/د - دال.mp3',
      videoPath: 'assets/videos/letters/د - دال.mp4',
      examples: ['دب', 'دجاجة', 'دراجة'],
      harakatAudio: {
        'fatha': 'assets/audio/letters_with_harakat/د - دا.mp3',
        'damma': 'assets/audio/letters_with_harakat/د - دو.mp3',
        'kasra': 'assets/audio/letters_with_harakat/د - دي.mp3',
      },
    ),
    // يمكن إضافة باقي الحروف بنفس الطريقة...
  ];

  // الحصول على حرف معين
  static ArabicLetter? getLetter(String letter) {
    try {
      return allLetters.firstWhere((l) => l.letter == letter);
    } catch (e) {
      return null;
    }
  }

  // الحصول على مجموعة حروف
  static List<ArabicLetter> getLetters(List<String> letters) {
    return letters.map((l) => getLetter(l)).whereType<ArabicLetter>().toList();
  }
}
