import 'package:hive/hive.dart';
import '../models/child_profile.dart';
import '../models/lesson_progress.dart';
import '../models/achievement.dart';

class DatabaseService {
  // أسماء Boxes
  static const String _profileBoxName = 'childProfile';
  static const String _lessonsBoxName = 'lessonProgress';
  static const String _achievementsBoxName = 'achievements';

  // Boxes
  static Box<ChildProfile>? _profileBox;
  static Box<LessonProgress>? _lessonsBox;
  static Box<Achievement>? _achievementsBox;

  // تهيئة قاعدة البيانات
  static Future<void> init() async {
    _profileBox = await Hive.openBox<ChildProfile>(_profileBoxName);
    _lessonsBox = await Hive.openBox<LessonProgress>(_lessonsBoxName);
    _achievementsBox = await Hive.openBox<Achievement>(_achievementsBoxName);
  }

  // ==================== ملف الطفل ====================

  /// حفظ ملف الطفل
  static Future<void> saveChildProfile(ChildProfile profile) async {
    await _profileBox?.put('current', profile);
  }

  /// جلب ملف الطفل
  static ChildProfile? getChildProfile() {
    return _profileBox?.get('current');
  }

  /// التحقق من وجود ملف
  static bool hasProfile() {
    return _profileBox?.get('current') != null;
  }

  /// حذف الملف (للبدء من جديد)
  static Future<void> deleteProfile() async {
    await _profileBox?.delete('current');
    await _lessonsBox?.clear();
    await _achievementsBox?.clear();
  }

  /// تحديث آخر نشاط
  static Future<void> updateLastActive() async {
    final profile = getChildProfile();
    if (profile != null) {
      profile.updateLastActive();
      await saveChildProfile(profile);
    }
  }

  /// إضافة نقاط
  static Future<void> addPoints(int points) async {
    final profile = getChildProfile();
    if (profile != null) {
      profile.addPoints(points);
      await saveChildProfile(profile);
    }
  }

  /// إضافة نجوم
  static Future<void> addStars(int stars) async {
    final profile = getChildProfile();
    if (profile != null) {
      profile.addStars(stars);
      await saveChildProfile(profile);
    }
  }

  /// رفع المستوى
  static Future<void> levelUp() async {
    final profile = getChildProfile();
    if (profile != null) {
      profile.levelUp();
      await saveChildProfile(profile);
    }
  }

  /// حفظ نتيجة اختبار تحديد المستوى
  static Future<void> savePlacementTestResult({
    required int score,
    required int level,
  }) async {
    final profile = getChildProfile();
    if (profile != null) {
      profile.hasCompletedPlacementTest = true;
      profile.placementTestScore = score;
      profile.currentLevel = level;
      await saveChildProfile(profile);
    }
  }

  // ==================== تقدم الدروس ====================

  /// حفظ تقدم درس
  static Future<void> saveLessonProgress(LessonProgress progress) async {
    await _lessonsBox?.put(progress.lessonId, progress);
  }

  /// جلب تقدم درس
  static LessonProgress? getLessonProgress(String lessonId) {
    return _lessonsBox?.get(lessonId);
  }

  /// جلب جميع الدروس المكتملة
  static List<LessonProgress> getCompletedLessons() {
    return _lessonsBox?.values.where((lesson) => lesson.isCompleted).toList() ??
        [];
  }

  /// جلب جميع الدروس
  static List<LessonProgress> getAllLessons() {
    return _lessonsBox?.values.toList() ?? [];
  }

  /// إكمال درس
  static Future<void> completeLesson(String lessonId, int stars) async {
    print('🎯 بدء حفظ الدرس: $lessonId بنجوم: $stars');
    
    var progress = getLessonProgress(lessonId);

    if (progress == null) {
      progress = LessonProgress(lessonId: lessonId);
      print('🟢 إنشاء تقدم جديد للدرس');
    } else {
      print('🟡 تحديث تقدم موجود');
    }

    progress.complete(100, stars);
    await saveLessonProgress(progress);
    print('✅ تم حفظ تقدم الدرس');

    // تحديث ملف الطفل
    final profile = getChildProfile();
    if (profile != null) {
      print('🔵 تحديث ملف الطفل');
      
      // إضافة النقاط حسب عدد النجوم
      final points = stars * 10; // كل نجمة = 10 نقاط
      profile.addPoints(points);
      print('💰 إضافة $points نقطة');
      
      // إضافة النجوم
      profile.addStars(stars);
      print('⭐ إضافة $stars نجمة');
      
      // إكمال الدرس
      profile.completeLesson();
      print('📚 زيادة عدد الدروس المكتملة');
      
      // حفظ الملف
      await saveChildProfile(profile);
      print('✅ تم حفظ ملف الطفل - النجوم: ${profile.totalStars}, النقاط: ${profile.totalPoints}, الدروس: ${profile.completedLessons}');
    } else {
      print('❌ لا يوجد ملف طفل!');
    }
  }

  // ==================== الإنجازات ====================

  /// حفظ إنجاز
  static Future<void> saveAchievement(Achievement achievement) async {
    await _achievementsBox?.put(achievement.achievementId, achievement);
  }

  /// جلب إنجاز
  static Achievement? getAchievement(String achievementId) {
    return _achievementsBox?.get(achievementId);
  }

  /// جلب جميع الإنجازات
  static List<Achievement> getAllAchievements() {
    return _achievementsBox?.values.toList() ?? [];
  }

  // ==================== متجر الشخصيات ====================

  /// شراء شخصية
  static Future<bool> purchaseCharacter(String characterId, int price) async {
    final profile = getChildProfile();
    if (profile == null) return false;

    // التحقق من النقاط الكافية
    if (profile.totalPoints < price) {
      print('❌ نقاط غير كافية للشراء');
      return false;
    }

    // التحقق من عدم شراء الشخصية مسبقاً
    if (profile.purchasedCharacters.contains(characterId)) {
      print('⚠️ الشخصية مشتراة مسبقاً');
      return false;
    }

    // خصم النقاط
    profile.totalPoints -= price;
    
    // إضافة الشخصية للمشتريات
    profile.purchasedCharacters.add(characterId);
    
    await saveChildProfile(profile);
    print('✅ تم شراء الشخصية: $characterId');
    return true;
  }

  /// اختيار شخصية
  static Future<void> selectCharacter(String characterId) async {
    final profile = getChildProfile();
    if (profile == null) return;

    // التحقق من أن الشخصية مشتراة
    if (!profile.purchasedCharacters.contains(characterId)) {
      print('❌ الشخصية غير مشتراة');
      return;
    }

    profile.selectedCharacter = characterId;
    await saveChildProfile(profile);
    print('✅ تم اختيار الشخصية: $characterId');
  }

  /// الحصول على الشخصيات المشتراة
  static List<String> getPurchasedCharacters() {
    final profile = getChildProfile();
    return profile?.purchasedCharacters ?? ['قطة'];
  }

  /// الحصول على الشخصية المختارة
  static String getSelectedCharacter() {
    final profile = getChildProfile();
    return profile?.selectedCharacter ?? 'قطة';
  }

  /// جلب الإنجازات المفتوحة
  static List<Achievement> getUnlockedAchievements() {
    return _achievementsBox?.values
            .where((achievement) => achievement.isUnlocked)
            .toList() ??
        [];
  }

  /// فتح إنجاز
  static Future<bool> unlockAchievement(String achievementId) async {
    var achievement = getAchievement(achievementId);

    if (achievement != null && !achievement.isUnlocked) {
      achievement.unlock();
      return true; // تم فتح إنجاز جديد
    }

    return false; // الإنجاز مفتوح مسبقاً أو غير موجود
  }

  /// تهيئة الإنجازات الافتراضية
  static Future<void> initializeDefaultAchievements() async {
    final achievements = [
      Achievement(
        achievementId: 'first_lesson',
        title: 'الدرس الأول',
        description: 'أكمل درسك الأول',
        iconPath: 'assets/images/badges/first_lesson.png',
      ),
      Achievement(
        achievementId: 'ten_lessons',
        title: 'متعلم نشيط',
        description: 'أكمل 10 دروس',
        iconPath: 'assets/images/badges/ten_lessons.png',
      ),
      Achievement(
        achievementId: 'perfect_score',
        title: 'نتيجة مثالية',
        description: 'احصل على نتيجة كاملة في درس',
        iconPath: 'assets/images/badges/perfect.png',
      ),
      Achievement(
        achievementId: 'week_streak',
        title: 'أسبوع متواصل',
        description: 'تعلم لمدة 7 أيام متتالية',
        iconPath: 'assets/images/badges/streak.png',
      ),
      Achievement(
        achievementId: 'hundred_stars',
        title: 'جامع النجوم',
        description: 'اجمع 100 نجمة',
        iconPath: 'assets/images/badges/stars.png',
      ),
    ];

    for (var achievement in achievements) {
      if (getAchievement(achievement.achievementId) == null) {
        await saveAchievement(achievement);
      }
    }
  }

  // ==================== إحصائيات ====================

  /// حساب إجمالي النجوم من الدروس
  static int getTotalStarsFromLessons() {
    return _lessonsBox?.values
            .fold<int>(0, (sum, lesson) => sum + lesson.stars) ??
        0;
  }

  /// حساب نسبة الإكمال
  static double getCompletionPercentage() {
    final total = _lessonsBox?.length ?? 0;
    if (total == 0) return 0.0;

    final completed = getCompletedLessons().length;
    return (completed / total) * 100;
  }

  // ==================== إغلاق ====================

  /// إغلاق جميع Boxes
  static Future<void> close() async {
    await _profileBox?.close();
    await _lessonsBox?.close();
    await _achievementsBox?.close();
  }
}
