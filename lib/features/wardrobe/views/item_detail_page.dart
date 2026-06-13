import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../providers/wardrobe_provider.dart';

final itemDetailProvider = FutureProvider.family<WardrobeItem?, int>(
  (ref, itemId) async {
    final db = ref.watch(databaseProvider);
    final query = db.select(db.wardrobeItems)
      ..where((t) => t.id.equals(itemId));
    final results = await query.get();
    return results.isNotEmpty ? results.first : null;
  },
);

class ItemDetailPage extends ConsumerWidget {
  final int itemId;
  const ItemDetailPage({super.key, required this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(itemDetailProvider(itemId));

    return Scaffold(
      appBar: AppBar(title: const Text('衣物详情')),
      body: itemAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('加载失败: $err')),
        data: (item) {
          if (item == null) return const Center(child: Text('衣物不存在'));
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(File(item.photoPath),
                      fit: BoxFit.contain,
                      height: 300,
                      width: double.infinity),
                ),
                const SizedBox(height: 24),
                _infoRow(context, '类别',
                    WardrobeCategory.fromString(item.category).displayName),
                _infoRow(context, '季节',
                    WardrobeSeason.fromString(item.season).displayName),
                _infoRow(context, '颜色', item.color ?? '-'),
                _infoRow(context, '风格', item.style ?? '-'),
                _infoRow(context, '场合', item.occasion ?? '-'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
