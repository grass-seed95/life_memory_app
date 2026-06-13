import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoDetailPage extends StatefulWidget {
  final int photoId;
  const PhotoDetailPage({super.key, required this.photoId});

  @override
  State<PhotoDetailPage> createState() => _PhotoDetailPageState();
}

class _PhotoDetailPageState extends State<PhotoDetailPage> {
  AssetEntity? _asset;
  Uint8List? _originBytes;

  @override
  void initState() {
    super.initState();
    _loadAsset();
  }

  Future<void> _loadAsset() async {
    final assets =
        await PhotoManager.getAssetPathList(type: RequestType.image);
    if (assets.isEmpty) return;
    final assetList =
        await assets.first.getAssetListPaged(page: 0, size: 200);
    for (final a in assetList) {
      if (a.id == widget.photoId) {
        final bytes = await a.originBytes;
        setState(() {
          _asset = a;
          _originBytes = bytes;
        });
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('照片详情')),
      body: _originBytes == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: InteractiveViewer(
                child: Image.memory(_originBytes!, fit: BoxFit.contain),
              ),
            ),
    );
  }
}
