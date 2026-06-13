import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/database.dart';

final eventDetailProvider = FutureProvider.family<Event?, int>(
  (ref, eventId) async {
    final db = ref.watch(databaseProvider);
    final query =
        db.select(db.events)..where((t) => t.id.equals(eventId));
    final results = await query.get();
    return results.isNotEmpty ? results.first : null;
  },
);

class EventDetailPage extends ConsumerWidget {
  final int eventId;
  const EventDetailPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventDetailProvider(eventId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('事件详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () =>
                context.push('/calendar/event/$eventId/edit'),
          ),
        ],
      ),
      body: eventAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('加载失败: $err')),
        data: (event) {
          if (event == null) return const Center(child: Text('事件不存在'));
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Chip(label: Text(event.type)),
                const SizedBox(height: 16),
                Text('日期: ${event.date}'),
                if (event.lunarFlag) const Text('(农历日期)'),
                if (event.repeatRule != null)
                  Text('重复: ${event.repeatRule}'),
                if (event.notes != null && event.notes!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('备注:', style: Theme.of(context).textTheme.titleSmall),
                  Text(event.notes!),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
