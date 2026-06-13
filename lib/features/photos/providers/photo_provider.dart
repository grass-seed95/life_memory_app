import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../core/photo_store/photo_store_service.dart';

enum PhotoViewMode { grid, timeline }
enum PhotoSortOrder { newestFirst, oldestFirst }

class PhotoFilter {
  final PhotoViewMode viewMode;
  final String? searchQuery;
  final int? albumId;
  final DateTimeRange? dateRange;
  final PhotoSortOrder sortOrder;

  const PhotoFilter({
    this.viewMode = PhotoViewMode.grid,
    this.searchQuery,
    this.albumId,
    this.dateRange,
    this.sortOrder = PhotoSortOrder.newestFirst,
  });

  PhotoFilter copyWith({
    PhotoViewMode? viewMode,
    String? searchQuery,
    int? albumId,
    DateTimeRange? dateRange,
    PhotoSortOrder? sortOrder,
  }) {
    return PhotoFilter(
      viewMode: viewMode ?? this.viewMode,
      searchQuery: searchQuery,
      albumId: albumId,
      dateRange: dateRange,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

final photoStoreServiceProvider = Provider<PhotoStoreService>((ref) {
  return PhotoStoreService();
});

final photoFilterProvider = StateProvider<PhotoFilter>((ref) {
  return const PhotoFilter();
});

final galleryPhotosProvider =
    FutureProvider<List<AssetEntity>>((ref) async {
  final service = ref.watch(photoStoreServiceProvider);
  final filter = ref.watch(photoFilterProvider);
  return service.fetchGalleryPhotos(page: 0, pageSize: 50);
});
