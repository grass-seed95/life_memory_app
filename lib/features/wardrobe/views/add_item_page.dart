import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/wardrobe_provider.dart';
import '../../../core/database/database.dart';

class AddItemPage extends ConsumerStatefulWidget {
  const AddItemPage({super.key});

  @override
  ConsumerState<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends ConsumerState<AddItemPage> {
  final ImagePicker _picker = ImagePicker();
  String? _photoPath;
  WardrobeCategory _category = WardrobeCategory.top;
  WardrobeSeason _season = WardrobeSeason.currentSeason();
  String _color = '黑';
  String _style = '休闲';

  final _colors = ['红', '橙', '黄', '绿', '蓝', '紫', '黑', '白', '灰', '棕'];
  final _styles = ['休闲', '正式', '运动'];

  Future<void> _takePhoto() async {
    final photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() => _photoPath = photo.path);
    }
  }

  Future<void> _pickFromGallery() async {
    final photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() => _photoPath = photo.path);
    }
  }

  Future<void> _save() async {
    if (_photoPath == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('请先拍照或选择照片')));
      return;
    }

    final db = ref.read(databaseProvider);
    await db.into(db.wardrobeItems).insert(WardrobeItemsCompanion(
          photoPath: Value(_photoPath!),
          category: Value(_category.name),
          season: Value(_season.name),
          color: Value(_color),
          style: Value(_style),
        ));

    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加衣物'),
        actions: [
          TextButton(onPressed: _save, child: const Text('保存')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (ctx) => SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                        leading: const Icon(Icons.camera),
                        title: const Text('拍照'),
                        onTap: () {
                          Navigator.pop(ctx);
                          _takePhoto();
                        }),
                    ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text('从相册选择'),
                        onTap: () {
                          Navigator.pop(ctx);
                          _pickFromGallery();
                        }),
                  ],
                ),
              ),
            ),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: _photoPath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(File(_photoPath!),
                          fit: BoxFit.cover, width: double.infinity))
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, size: 48, color: Colors.grey),
                        Text('点击拍照或选择照片'),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<WardrobeCategory>(
            value: _category,
            decoration: const InputDecoration(labelText: '类别'),
            items: WardrobeCategory.values
                .map((c) => DropdownMenuItem(
                    value: c, child: Text(c.displayName)))
                .toList(),
            onChanged: (v) => setState(() => _category = v!),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<WardrobeSeason>(
            value: _season,
            decoration: const InputDecoration(labelText: '季节'),
            items: WardrobeSeason.values
                .map((s) => DropdownMenuItem(
                    value: s, child: Text(s.displayName)))
                .toList(),
            onChanged: (v) => setState(() => _season = v!),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _color,
            decoration: const InputDecoration(labelText: '颜色'),
            items: _colors
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _color = v!),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _style,
            decoration: const InputDecoration(labelText: '风格'),
            items: _styles
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) => setState(() => _style = v!),
          ),
        ],
      ),
    );
  }
}
