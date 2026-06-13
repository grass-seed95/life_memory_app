import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/photo_provider.dart';
import '../widgets/photo_grid.dart';
import '../widgets/photo_timeline.dart';

class PhotosHomePage extends ConsumerWidget {
  const PhotosHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(photoFilterProvider);
    final photosAsync = ref.watch(galleryPhotosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('照片'),
        actions: [
          IconButton(
            icon: Icon(filter.viewMode == PhotoViewMode.grid
                ? Icons.view_agenda
                : Icons.grid_view),
            onPressed: () {
              ref.read(photoFilterProvider.notifier).state =
                  filter.copyWith(
                      viewMode: filter.viewMode == PhotoViewMode.grid
                          ? PhotoViewMode.timeline
                          : PhotoViewMode.grid);
            },
          ),
          IconButton(
            icon: const Icon(Icons.folder),
            onPressed: () => context.push('/photos/albums'),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/photos/search'),
          ),
        ],
      ),
      body: photosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('加载失败: $err')),
        data: (photos) => filter.viewMode == PhotoViewMode.grid
            ? PhotoGrid(
                photos: photos,
                onPhotoTap: (asset, index) =>
                    context.push('/photos/detail/${asset.id}'),
              )
            : PhotoTimeline(
                photos: photos,
                onPhotoTap: (asset, index) =>
                    context.push('/photos/detail/${asset.id}'),
              ),
      ),
    );
  }
}
