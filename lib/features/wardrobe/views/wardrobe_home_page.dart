import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/wardrobe_provider.dart';
import '../widgets/wardrobe_item_card.dart';

class WardrobeHomePage extends ConsumerWidget {
  const WardrobeHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allItemsAsync = ref.watch(wardrobeItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的衣橱'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            onPressed: () => context.push('/wardrobe/outfit/create'),
            tooltip: '搭配',
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/wardrobe/outfit/history'),
            tooltip: '穿搭记录',
          ),
        ],
      ),
      body: DefaultTabController(
        length: WardrobeCategory.values.length,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              tabs: WardrobeCategory.values
                  .map((c) => Tab(text: c.displayName))
                  .toList(),
            ),
            Expanded(
              child: allItemsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('加载失败: $err')),
                data: (allItems) => TabBarView(
                  children: WardrobeCategory.values.map((category) {
                    final items = allItems
                        .where((item) => item.category == category.name)
                        .toList();
                    if (items.isEmpty) {
                      return const Center(child: Text('暂无衣物'));
                    }
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8),
                      padding: const EdgeInsets.all(8),
                      itemCount: items.length,
                      itemBuilder: (context, index) =>
                          WardrobeItemCard(
                        item: items[index],
                        onTap: () => context
                            .push('/wardrobe/item/${items[index].id}'),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.push('/wardrobe/add-item'),
      ),
    );
  }
}
