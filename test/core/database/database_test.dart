import 'package:flutter_test/flutter_test.dart';
import 'package:life_memory_app/core/database/tables.dart';

void main() {
  group('Database table definitions', () {
    test('Photos table has expected columns', () {
      expect(photos.$columns.length, 8);
      expect(photos.id.$name, 'id');
      expect(photos.filePath.$name, 'file_path');
      expect(photos.thumbnailPath.$name, 'thumbnail_path');
    });

    test('WardrobeItems table has expected columns', () {
      expect(wardrobeItems.$columns.length, 9);
      expect(wardrobeItems.category.$name, 'category');
      expect(wardrobeItems.season.$name, 'season');
    });

    test('Events table has lunar_flag column', () {
      expect(events.$columns.any((c) => c.$name == 'lunar_flag'), isTrue);
      expect(events.$columns.any((c) => c.$name == 'repeat_rule'), isTrue);
    });

    test('OutfitLogs table references wardrobe items via JSON', () {
      expect(outfitLogs.$columns.any((c) => c.$name == 'items'), isTrue);
      expect(outfitLogs.$columns.any((c) => c.$name == 'date'), isTrue);
    });
  });
}
