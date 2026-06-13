import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:intl/intl.dart';
import 'photo_thumbnail.dart';

class PhotoTimeline extends StatelessWidget {
  final List<AssetEntity> photos;
  final void Function(AssetEntity, int) onPhotoTap;

  const PhotoTimeline({
    super.key,
    required this.photos,
    required this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return const Center(child: Text('没有照片'));
    }

    final grouped = <String, List<AssetEntity>>{};
    for (final photo in photos) {
      final dateStr =
          DateFormat('yyyy年MM月dd日').format(photo.createDateTime);
      grouped.putIfAbsent(dateStr, () => []).add(photo);
    }

    return ListView.builder(
      itemCount: grouped.length,
      itemBuilder: (context, sectionIndex) {
        final dateStr = grouped.keys.elementAt(sectionIndex);
        final items = grouped[dateStr]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(dateStr,
                  style: Theme.of(context).textTheme.titleSmall),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2),
              itemCount: items.length,
              itemBuilder: (context, i) => PhotoThumbnail(
                asset: items[i],
                onTap: () => onPhotoTap(items[i], i),
              ),
            ),
          ],
        );
      },
    );
  }
}
