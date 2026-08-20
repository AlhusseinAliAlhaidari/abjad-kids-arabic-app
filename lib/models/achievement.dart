import 'package:hive/hive.dart';

part 'achievement.g.dart';

@HiveType(typeId: 2)
class Achievement extends HiveObject {
  @HiveField(0)
  String achievementId;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  bool isUnlocked;

  @HiveField(4)
  DateTime? unlockedAt;

  @HiveField(5)
  String iconPath;

  Achievement({
    required this.achievementId,
    required this.title,
    required this.description,
    this.isUnlocked = false,
    this.unlockedAt,
    required this.iconPath,
  });

  // فتح الإنجاز
  void unlock() {
    if (!isUnlocked) {
      isUnlocked = true;
      unlockedAt = DateTime.now();
      save();
    }
  }

  @override
  String toString() {
    return 'Achievement(id: $achievementId, title: $title, unlocked: $isUnlocked)';
  }
}
