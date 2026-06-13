import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:photo_manager/photo_manager.dart';

class PhotoStoreService {
  Future<String> generateThumbnail(String filePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final thumbDir = Directory(p.join(dir.path, 'thumbnails'));
    if (!await thumbDir.exists()) {
      await thumbDir.create(recursive: true);
    }

    final fileName = p.basenameWithoutExtension(filePath);
    final thumbPath = p.join(thumbDir.path, '${fileName}_thumb.jpg');

    if (await File(thumbPath).exists()) return thumbPath;

    final bytes = await File(filePath).readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return filePath;

    final thumbnail = img.copyResize(image, width: 300);
    final thumbBytes = img.encodeJpg(thumbnail);
    await File(thumbPath).writeAsBytes(thumbBytes);

    return thumbPath;
  }

  Future<List<AssetEntity>> fetchGalleryPhotos({
    required int page,
    int pageSize = 50,
  }) async {
    final permitted = await PhotoManager.requestPermissionExtend();
    if (!permitted.isAuth) return [];

    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    if (albums.isEmpty) return [];

    final photos = await albums.first.getAssetListPaged(
      page: page,
      size: pageSize,
    );

    return photos;
  }

  Future<File?> getAssetFile(AssetEntity entity) async {
    final file = await entity.file;
    return file;
  }

  Future<String> saveToAppDirectory(String sourcePath, String subdir) async {
    final dir = await getApplicationDocumentsDirectory();
    final targetDir = Directory(p.join(dir.path, 'app_photos', subdir));
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final fileName = p.basename(sourcePath);
    final targetPath = p.join(targetDir.path, fileName);
    await File(sourcePath).copy(targetPath);
    return targetPath;
  }
}
