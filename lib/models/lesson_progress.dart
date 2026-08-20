import 'package:hive/hive.dart';

part 'lesson_progress.g.dart';

@HiveType(typeId: 1)
class LessonProgress extends HiveObject {
  @HiveField(0)
  String lessonId;

  @HiveField(1)
  bool isCompleted;

  @HiveField(2)
  int stars; // 0-3 نجوم

  @HiveField(3)
  DateTime? completedAt;

  @HiveField(4)
  int attempts; // عدد المحاولات

  @HiveField(5)
  int bestScore; // أفضل نتيجة

  LessonProgress({
    required this.lessonId,
    this.isCompleted = false,
    this.stars = 0,
    this.completedAt,
    this.attempts = 0,
    this.bestScore = 0,
  });

  // إكمال الدرس
  void complete(int score, int earnedStars) {
    isCompleted = true;
    completedAt = DateTime.now();
    
    if (score > bestScore) {
      bestScore = score;
    }
    
    if (earnedStars > stars) {
      stars = earnedStars;
    }
    
    // لا نستدعي save() هنا - سيتم الحفظ من DatabaseService
  }

  // زيادة المحاولات
  void incrementAttempts() {
    attempts++;
    // لا نستدعي save() هنا - سيتم الحفظ من DatabaseService
  }

  @override
  String toString() {
    return 'LessonProgress(lessonId: $lessonId, completed: $isCompleted, stars: $stars)';
  }
}
