import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late int age;

  @HiveField(3)
  String? avatarPath;

  @HiveField(4)
  late int coins;

  @HiveField(5)
  late List<String> badges;

  @HiveField(6)
  late List<String> purchasedCharacters;

  @HiveField(7)
  late String currentTheme;

  @HiveField(8)
  late Map<dynamic, dynamic> levelProgress; // stageId-levelId -> stars (0-3)

  @HiveField(9)
  late DateTime createdAt;

  @HiveField(10)
  late DateTime lastPlayed;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    this.avatarPath,
    int? coins,
    List<String>? badges,
    List<String>? purchasedCharacters,
    String? currentTheme,
    Map<dynamic, dynamic>? levelProgress,
    DateTime? createdAt,
    DateTime? lastPlayed,
  }) {
    this.coins = coins ?? 0;
    this.badges = badges ?? [];
    this.purchasedCharacters = purchasedCharacters ?? [];
    this.currentTheme = currentTheme ?? 'default';
    this.levelProgress = levelProgress ?? {};
    this.createdAt = createdAt ?? DateTime.now();
    this.lastPlayed = lastPlayed ?? DateTime.now();
  }

  // إضافة عملات
  void addCoins(int amount) {
    coins += amount;
    save();
  }

  // إنفاق عملات
  bool spendCoins(int amount) {
    if (coins >= amount) {
      coins -= amount;
      save();
      return true;
    }
    return false;
  }

  // إضافة شارة
  void addBadge(String badgeId) {
    if (!badges.contains(badgeId)) {
      badges.add(badgeId);
      save();
    }
  }

  // شراء شخصية
  void purchaseCharacter(String characterId) {
    if (!purchasedCharacters.contains(characterId)) {
      purchasedCharacters.add(characterId);
      save();
    }
  }

  // تحديث تقدم المستوى
  void updateLevelProgress(String stageId, int levelId, int stars) {
    final key = '$stageId-$levelId';
    final currentStars = (levelProgress[key] as int?) ?? 0;
    if (stars > currentStars) {
      levelProgress[key] = stars;
      save();
    }
  }

  // الحصول على نجوم المستوى
  int getLevelStars(String stageId, int levelId) {
    final key = '$stageId-$levelId';
    return (levelProgress[key] as int?) ?? 0;
  }

  // التحقق من إكمال المستوى
  bool isLevelCompleted(String stageId, int levelId) {
    return getLevelStars(stageId, levelId) > 0;
  }

  // تحديث آخر وقت لعب
  void updateLastPlayed() {
    lastPlayed = DateTime.now();
    save();
  }
}
