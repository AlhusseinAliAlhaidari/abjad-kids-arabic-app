import 'package:hive/hive.dart';

part 'child_profile.g.dart';

@HiveType(typeId: 0)
class ChildProfile extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  int currentLevel;

  @HiveField(3)
  int totalPoints;

  @HiveField(4)
  bool hasCompletedPlacementTest;

  @HiveField(5)
  int placementTestScore;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  DateTime lastActiveAt;

  @HiveField(8)
  int totalStars;

  @HiveField(9)
  List<String> purchasedCharacters;

  @HiveField(10)
  String selectedCharacter;

  @HiveField(11)
  int completedLessons;

  ChildProfile({
    required this.name,
    required this.age,
    this.currentLevel = 1,
    this.totalPoints = 0,
    this.hasCompletedPlacementTest = false,
    this.placementTestScore = 0,
    required this.createdAt,
    required this.lastActiveAt,
    this.totalStars = 0,
    this.completedLessons = 0,
    List<String>? purchasedCharacters,
    this.selectedCharacter = 'قطة', // الحيوان الافتراضي
  }) : purchasedCharacters = purchasedCharacters ?? ['قطة'];

  // تحديث آخر نشاط
  void updateLastActive() {
    lastActiveAt = DateTime.now();
    // لا نستدعي save() هنا
  }

  // إضافة نقاط
  void addPoints(int points) {
    totalPoints += points;
    // لا نستدعي save() هنا
  }

  // إضافة نجوم
  void addStars(int stars) {
    totalStars += stars;
    // لا نستدعي save() هنا
  }

  // رفع المستوى
  void levelUp() {
    currentLevel++;
    // لا نستدعي save() هنا
  }

  // إكمال درس
  void completeLesson() {
    completedLessons++;
    // لا نستدعي save() هنا
  }

  @override
  String toString() {
    return 'ChildProfile(name: $name, age: $age, level: $currentLevel, points: $totalPoints)';
  }
}
