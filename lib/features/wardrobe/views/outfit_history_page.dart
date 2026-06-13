import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/database/database.dart';
import '../providers/outfit_provider.dart';

class OutfitHistoryPage extends ConsumerWidget {
  const OutfitHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(outfitHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('穿搭记录')),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('加载失败: $err')),
        data: (logs) {
          if (logs.isEmpty) {
            return const Center(child: Text('还没有穿搭记录'));
          }

          final grouped = <String, List<OutfitLog>>{};
          for (final log in logs) {
            final monthKey = log.date.substring(0, 7);
            grouped.putIfAbsent(monthKey, () => []).add(log);
          }

          return ListView.builder(
            itemCount: grouped.length,
            itemBuilder: (context, index) {
              final monthKey = grouped.keys.elementAt(index);
              final monthLogs = grouped[monthKey]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      DateFormat('yyyy年MM月').format(
                          DateTime.parse('$monthKey-01')),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  ...monthLogs.map((log) => ListTile(
                        leading: const Icon(Icons.checkroom),
                        title: Text(DateFormat('MM月dd日')
                            .format(DateTime.parse(log.date))),
                        subtitle:
                            Text('${_countItems(log.items)}件单品'),
                      )),
                ],
              );
            },
          );
        },
      ),
    );
  }

  int _countItems(String itemsJson) {
    try {
      final map = jsonDecode(itemsJson) as Map<String, dynamic>;
      return map.values.where((v) => v != null).length;
    } catch (_) {
      return 0;
    }
  }
}
