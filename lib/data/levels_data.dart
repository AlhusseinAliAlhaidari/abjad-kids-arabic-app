import 'letters_data.dart';

enum LessonType {
  reading,
  writing,
  listening,
  speaking,
}

class Lesson {
  final String id;
  final String title;
  final LessonType type;
  final List<String> targetLetters;
  final String? description;
  final int coinsReward;

  Lesson({
    required this.id,
    required this.title,
    required this.type,
    required this.targetLetters,
    this.description,
    this.coinsReward = 10,
  });
}

class GameData {
  final String id;
  final String name;
  final String type; // 'matching', 'tracing', 'listening'
  final List<String> targetLetters;
  final int coinsReward;
  final int requiredScore; // النتيجة المطلوبة للنجاح

  GameData({
    required this.id,
    required this.name,
    required this.type,
    required this.targetLetters,
    this.coinsReward = 20,
    this.requiredScore = 70,
  });
}

class Level {
  final int id;
  final String title;
  final List<String> targetLetters;
  final List<Lesson> lessons;
  final List<GameData> games;
  final int requiredStarsToUnlock;

  Level({
    required this.id,
    required this.title,
    required this.targetLetters,
    required this.lessons,
    required this.games,
    this.requiredStarsToUnlock = 0,
  });

  // التحقق من إمكانية فتح المستوى
  bool canUnlock(int currentStars) {
    return currentStars >= requiredStarsToUnlock;
  }
}

class Stage {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final List<Level> levels;
  final int requiredStarsToUnlock;

  Stage({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.levels,
    this.requiredStarsToUnlock = 0,
  });
}

// بيانات المستويات
class LevelsData {
  // مرحلة التمهيد - جميع الحروف العربية
  static final Stage preparatoryStage = Stage(
    id: 'preparatory',
    name: 'مرحلة التمهيد',
    description: 'تعلم جميع الحروف العربية',
    iconPath: 'assets/images/ui/stage_preparatory.png',
    requiredStarsToUnlock: 0,
    levels: [
      // المستوى 1: الحروف (أ - ج)
      Level(
        id: 1,
        title: 'الحروف الأولى',
        targetLetters: ['أ', 'ب', 'ت', 'ث', 'ج'],
        requiredStarsToUnlock: 0,
        lessons: [
          Lesson(
            id: 'prep_1_lesson',
            title: 'تعلم الحروف',
            type: LessonType.reading,
            targetLetters: ['أ', 'ب', 'ت', 'ث', 'ج'],
          ),
        ],
        games: [],
      ),

      // المستوى 2: الحروف (ح - ر)
      Level(
        id: 2,
        title: 'حروف جديدة',
        targetLetters: ['ح', 'خ', 'د', 'ذ', 'ر'],
        requiredStarsToUnlock: 5,
        lessons: [
          Lesson(
            id: 'prep_2_lesson',
            title: 'تعلم الحروف',
            type: LessonType.reading,
            targetLetters: ['ح', 'خ', 'د', 'ذ', 'ر'],
          ),
        ],
        games: [],
      ),

      // المستوى 3: الحروف (ز - ض)
      Level(
        id: 3,
        title: 'المزيد من الحروف',
        targetLetters: ['ز', 'س', 'ش', 'ص', 'ض'],
        requiredStarsToUnlock: 10,
        lessons: [
          Lesson(
            id: 'prep_3_lesson',
            title: 'تعلم الحروف',
            type: LessonType.reading,
            targetLetters: ['ز', 'س', 'ش', 'ص', 'ض'],
          ),
        ],
        games: [],
      ),

      // المستوى 4: الحروف (ط - ف)
      Level(
        id: 4,
        title: 'حروف مميزة',
        targetLetters: ['ط', 'ظ', 'ع', 'غ', 'ف'],
        requiredStarsToUnlock: 15,
        lessons: [
          Lesson(
            id: 'prep_4_lesson',
            title: 'تعلم الحروف',
            type: LessonType.reading,
            targetLetters: ['ط', 'ظ', 'ع', 'غ', 'ف'],
          ),
        ],
        games: [],
      ),

      // المستوى 5: الحروف (ق - ن)
      Level(
        id: 5,
        title: 'نواصل التعلم',
        targetLetters: ['ق', 'ك', 'ل', 'م', 'ن'],
        requiredStarsToUnlock: 20,
        lessons: [
          Lesson(
            id: 'prep_5_lesson',
            title: 'تعلم الحروف',
            type: LessonType.reading,
            targetLetters: ['ق', 'ك', 'ل', 'م', 'ن'],
          ),
        ],
        games: [],
      ),

      // المستوى 6: الحروف الأخيرة (هـ - ي)
      Level(
        id: 6,
        title: 'إكمال الأبجدية',
        targetLetters: ['ه', 'و', 'ي'],
        requiredStarsToUnlock: 25,
        lessons: [
          Lesson(
            id: 'prep_6_lesson',
            title: 'تعلم الحروف',
            type: LessonType.reading,
            targetLetters: ['ه', 'و', 'ي'],
          ),
        ],
        games: [],
      ),
    ],
  );

  // مرحلة الأساسي - النطق والكلمات
  static final Stage basicStage = Stage(
    id: 'basic',
    name: 'مرحلة الأساسي',
    description: 'تعلم نطق الكلمات',
    iconPath: 'assets/images/ui/stage_basic.png',
    requiredStarsToUnlock: 0,
    levels: [
      // المستوى 1: الفواكه
      Level(
        id: 1,
        title: 'الفواكه',
        targetLetters: ['تفاح', 'موز', 'برتقال', 'عنب', 'فراولة'],
        lessons: [
          Lesson(
            id: 'pronunciation_1_lesson',
            title: 'تعلم نطق الفواكه',
            type: LessonType.speaking,
            targetLetters: ['تفاح', 'موز', 'برتقال', 'عنب', 'فراولة'],
            description: 'تعلم نطق أسماء الفواكه',
            coinsReward: 30,
          ),
        ],
        games: [],
      ),

      // المستوى 2: الألوان
      Level(
        id: 2,
        title: 'الألوان',
        targetLetters: ['أحمر', 'أزرق', 'أخضر', 'أصفر', 'وردي'],
        lessons: [
          Lesson(
            id: 'pronunciation_2_lesson',
            title: 'تعلم نطق الألوان',
            type: LessonType.speaking,
            targetLetters: ['أحمر', 'أزرق', 'أخضر', 'أصفر', 'وردي'],
            description: 'تعلم نطق أسماء الألوان',
            coinsReward: 30,
          ),
        ],
        games: [],
      ),

      // المستوى 3: المهن
      Level(
        id: 3,
        title: 'المهن',
        targetLetters: ['طبيب', 'معلم', 'شرطي', 'طيار', 'خباز'],
        lessons: [
          Lesson(
            id: 'pronunciation_3_lesson',
            title: 'تعلم نطق المهن',
            type: LessonType.speaking,
            targetLetters: ['طبيب', 'معلم', 'شرطي', 'طيار', 'خباز'],
            description: 'تعلم نطق أسماء المهن',
            coinsReward: 30,
          ),
        ],
        games: [],
      ),

      // المستوى 4: أعضاء الجسم
      Level(
        id: 4,
        title: 'أعضاء الجسم',
        targetLetters: ['العين', 'الأذن', 'الأنف', 'اليد', 'الرجل'],
        lessons: [
          Lesson(
            id: 'pronunciation_4_lesson',
            title: 'تعلم نطق أعضاء الجسم',
            type: LessonType.speaking,
            targetLetters: ['العين', 'الأذن', 'الأنف', 'اليد', 'الرجل'],
            description: 'تعلم نطق أسماء أعضاء الجسم',
            coinsReward: 30,
          ),
        ],
        games: [],
      ),
    ],
  );

  // قائمة جميع المراحل
  static final List<Stage> allStages = [
    preparatoryStage,
    basicStage,
  ];

  // الحصول على مرحلة بواسطة ID
  static Stage? getStage(String id) {
    try {
      return allStages.firstWhere((stage) => stage.id == id);
    } catch (e) {
      return null;
    }
  }

  // الحصول على مستوى معين
  static Level? getLevel(String stageId, int levelId) {
    final stage = getStage(stageId);
    if (stage == null) return null;

    try {
      return stage.levels.firstWhere((l) => l.id == levelId);
    } catch (e) {
      return null;
    }
  }
}
