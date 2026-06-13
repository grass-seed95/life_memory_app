import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoThumbnail extends StatelessWidget {
  final AssetEntity asset;
  final VoidCallback onTap;

  const PhotoThumbnail({
    super.key,
    required this.asset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FutureBuilder<Uint8List?>(
        future: asset.thumbnailDataWithSize(
          const ThumbnailSize(300, 300),
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Image.memory(snapshot.data!, fit: BoxFit.cover);
          }
          return Container(color: Colors.grey[200]);
        },
      ),
    );
  }
}
