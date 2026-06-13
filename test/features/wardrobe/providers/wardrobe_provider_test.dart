import 'package:flutter_test/flutter_test.dart';
import 'package:life_memory_app/features/wardrobe/providers/wardrobe_provider.dart';

void main() {
  group('WardrobeCategory', () {
    test('all categories have display names', () {
      for (final cat in WardrobeCategory.values) {
        expect(cat.displayName, isNotEmpty);
      }
    });
  });

  group('WardrobeSeason', () {
    test('all seasons have display names', () {
      for (final season in WardrobeSeason.values) {
        expect(season.displayName, isNotEmpty);
      }
    });

    test('currentSeason returns a valid season', () {
      final season = WardrobeSeason.currentSeason();
      expect(WardrobeSeason.values, contains(season));
    });
  });

  group('OutfitCombination', () {
    test('toJson serializes item IDs', () {
      final combo = OutfitCombination(topId: 1, bottomId: 2, shoeId: 3);
      final json = combo.toJson();
      expect(json['top'], 1);
      expect(json['bottom'], 2);
      expect(json['shoe'], 3);
    });

    test('fromJson deserializes item IDs', () {
      final json = {'top': 1, 'bottom': 2, 'shoe': 3};
      final combo = OutfitCombination.fromJson(json);
      expect(combo.topId, 1);
      expect(combo.bottomId, 2);
      expect(combo.shoeId, 3);
    });
  });
}
