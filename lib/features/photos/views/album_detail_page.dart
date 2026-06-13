import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import '../providers/photo_provider.dart';

class AlbumDetailPage extends ConsumerWidget {
  final int albumId;
  const AlbumDetailPage({super.key, required this.albumId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosAsync = ref.watch(galleryPhotosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('相册详情')),
      body: photosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('加载失败: $err')),
        data: (photos) {
          if (photos.isEmpty) {
            return const Center(child: Text('相册中暂无照片'));
          }
          return GridView.builder(
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return FutureBuilder<Uint8List?>(
                future: photos[index].thumbnailDataWithSize(
                    const ThumbnailSize(300, 300)),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Image.memory(snapshot.data!,
                        fit: BoxFit.cover);
                  }
                  return Container(color: Colors.grey[200]);
                },
              );
            },
          );
        },
      ),
    );
  }
}
