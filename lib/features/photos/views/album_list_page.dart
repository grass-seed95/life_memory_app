import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/database.dart';
import '../providers/album_provider.dart';

class AlbumListPage extends ConsumerWidget {
  const AlbumListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumsAsync = ref.watch(albumListProvider);
    final db = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('相册')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showCreateDialog(context, ref),
      ),
      body: albumsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('加载失败: $err')),
        data: (albums) {
          if (albums.isEmpty) {
            return const Center(child: Text('还没有相册，点击 + 创建'));
          }
          return ListView.builder(
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              return ListTile(
                leading: const Icon(Icons.folder),
                title: Text(album.name),
                onTap: () => context.push('/photos/albums/${album.id}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    await (db.delete(db.albums)
                          ..where((t) => t.id.equals(album.id)))
                        .go();
                    ref.invalidate(albumListProvider);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final db = ref.read(databaseProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('新建相册'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: '相册名称'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await db.into(db.albums).insert(
                      AlbumsCompanion(name: Value(controller.text)),
                    );
                ref.invalidate(albumListProvider);
              }
              Navigator.pop(ctx);
            },
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }
}
