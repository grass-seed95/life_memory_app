import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/wardrobe_provider.dart';
import '../../../core/database/database.dart';

class OutfitCreatePage extends ConsumerStatefulWidget {
  const OutfitCreatePage({super.key});

  @override
  ConsumerState<OutfitCreatePage> createState() => _OutfitCreatePageState();
}

class _OutfitCreatePageState extends ConsumerState<OutfitCreatePage> {
  int? _selectedTop;
  int? _selectedBottom;
  int? _selectedDress;
  int? _selectedShoes;

  Future<void> _saveOutfit() async {
    final combo = OutfitCombination(
      topId: _selectedTop,
      bottomId: _selectedBottom,
      dressId: _selectedDress,
      shoeId: _selectedShoes,
    );

    final db = ref.read(databaseProvider);
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await db.into(db.outfitLogs).insert(OutfitLogsCompanion(
          date: Value(today),
          items: Value(jsonEncode(combo.toJson())),
        ));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('穿搭已记录！')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(wardrobeItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('选择搭配'),
        actions: [
          TextButton(
            onPressed: _saveOutfit,
            child: const Text('穿上'),
          ),
        ],
      ),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('加载失败: $err')),
        data: (items) {
          final tops = items
              .where((i) => i.category == WardrobeCategory.top.name)
              .toList();
          final bottoms = items
              .where((i) => i.category == WardrobeCategory.bottom.name)
              .toList();
          final dresses = items
              .where((i) => i.category == WardrobeCategory.dress.name)
              .toList();
          final shoes = items
              .where((i) => i.category == WardrobeCategory.shoes.name)
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _sectionHeader('上装'),
              SizedBox(
                height: 140,
                child: _horizontalPicker(tops, _selectedTop,
                    (v) => setState(() => _selectedTop = v)),
              ),
              _sectionHeader('下装'),
              SizedBox(
                height: 140,
                child: _horizontalPicker(bottoms, _selectedBottom,
                    (v) => setState(() => _selectedBottom = v)),
              ),
              _sectionHeader('裙装（与上下装二选一）'),
              SizedBox(
                height: 140,
                child: _horizontalPicker(dresses, _selectedDress,
                    (v) => setState(() => _selectedDress = v)),
              ),
              _sectionHeader('鞋'),
              SizedBox(
                height: 140,
                child: _horizontalPicker(shoes, _selectedShoes,
                    (v) => setState(() => _selectedShoes = v)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(title, style: Theme.of(context).textTheme.titleSmall),
    );
  }

  Widget _horizontalPicker(
      List<WardrobeItem> items, int? selected, void Function(int?) onSelect) {
    if (items.isEmpty) {
      return const Center(child: Text('暂无此类衣物'));
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final isSelected = items[index].id == selected;
        return GestureDetector(
          onTap: () => onSelect(isSelected ? null : items[index].id),
          child: Container(
            width: 120,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                width: 3,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(File(items[index].photoPath),
                        fit: BoxFit.cover, width: double.infinity),
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                      size: 18),
              ],
            ),
          ),
        );
      },
    );
  }
}
