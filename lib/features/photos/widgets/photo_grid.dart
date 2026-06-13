import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'photo_thumbnail.dart';

class PhotoGrid extends StatelessWidget {
  final List<AssetEntity> photos;
  final void Function(AssetEntity, int) onPhotoTap;

  const PhotoGrid({
    super.key,
    required this.photos,
    required this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return const Center(child: Text('没有照片'));
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return PhotoThumbnail(
          asset: photos[index],
          onTap: () => onPhotoTap(photos[index], index),
        );
      },
    );
  }
}
