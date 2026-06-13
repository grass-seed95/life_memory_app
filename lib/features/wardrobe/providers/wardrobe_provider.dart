import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';

enum WardrobeCategory {
  top, bottom, dress, shoes, accessory;

  String get displayName {
    switch (this) {
      case WardrobeCategory.top: return '上装';
      case WardrobeCategory.bottom: return '下装';
      case WardrobeCategory.dress: return '裙装';
      case WardrobeCategory.shoes: return '鞋';
      case WardrobeCategory.accessory: return '配饰';
    }
  }

  static WardrobeCategory fromString(String value) {
    return WardrobeCategory.values.firstWhere(
      (c) => c.name == value,
      orElse: () => WardrobeCategory.top,
    );
  }
}

enum WardrobeSeason {
  spring, summer, autumn, winter, all;

  String get displayName {
    switch (this) {
      case WardrobeSeason.spring: return '春';
      case WardrobeSeason.summer: return '夏';
      case WardrobeSeason.autumn: return '秋';
      case WardrobeSeason.winter: return '冬';
      case WardrobeSeason.all: return '通用';
    }
  }

  static WardrobeSeason currentSeason() {
    final month = DateTime.now().month;
    if (month >= 3 && month <= 5) return WardrobeSeason.spring;
    if (month >= 6 && month <= 8) return WardrobeSeason.summer;
    if (month >= 9 && month <= 11) return WardrobeSeason.autumn;
    return WardrobeSeason.winter;
  }

  static WardrobeSeason fromString(String value) {
    return WardrobeSeason.values.firstWhere(
      (s) => s.name == value,
      orElse: () => WardrobeSeason.all,
    );
  }
}

class OutfitCombination {
  final int? topId;
  final int? bottomId;
  final int? dressId;
  final int? shoeId;
  final List<int> accessoryIds;

  const OutfitCombination({
    this.topId,
    this.bottomId,
    this.dressId,
    this.shoeId,
    this.accessoryIds = const [],
  });

  Map<String, dynamic> toJson() => {
        if (topId != null) 'top': topId,
        if (bottomId != null) 'bottom': bottomId,
        if (dressId != null) 'dress': dressId,
        if (shoeId != null) 'shoe': shoeId,
        'accessories': accessoryIds,
      };

  factory OutfitCombination.fromJson(Map<String, dynamic> json) {
    return OutfitCombination(
      topId: json['top'] as int?,
      bottomId: json['bottom'] as int?,
      dressId: json['dress'] as int?,
      shoeId: json['shoe'] as int?,
      accessoryIds: (json['accessories'] as List?)?.cast<int>() ?? [],
    );
  }

  List<int> get itemIds => [
        if (topId != null) topId!,
        if (bottomId != null) bottomId!,
        if (dressId != null) dressId!,
        if (shoeId != null) shoeId!,
        ...accessoryIds,
      ];
}

final wardrobeItemsProvider =
    FutureProvider<List<WardrobeItem>>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.select(db.wardrobeItems).get();
});

final wardrobeItemsByCategoryProvider =
    FutureProvider.family<List<WardrobeItem>, WardrobeCategory>(
  (ref, category) async {
    final db = ref.watch(databaseProvider);
    final query = db.select(db.wardrobeItems)
      ..where((t) => t.category.equals(category.name));
    return await query.get();
  },
);
