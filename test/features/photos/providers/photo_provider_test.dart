import 'package:flutter_test/flutter_test.dart';
import 'package:life_memory_app/features/photos/providers/photo_provider.dart';

void main() {
  group('PhotoFilter', () {
    test('default filter has no constraints', () {
      final filter = PhotoFilter();
      expect(filter.viewMode, PhotoViewMode.grid);
      expect(filter.searchQuery, isNull);
      expect(filter.albumId, isNull);
      expect(filter.dateRange, isNull);
      expect(filter.sortOrder, PhotoSortOrder.newestFirst);
    });

    test('copyWith updates only specified fields', () {
      final filter = PhotoFilter();
      final updated = filter.copyWith(viewMode: PhotoViewMode.timeline);
      expect(updated.viewMode, PhotoViewMode.timeline);
      expect(updated.searchQuery, isNull);
    });
  });
}
