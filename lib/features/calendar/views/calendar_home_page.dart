import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/event_provider.dart';
import '../widgets/month_view.dart';
import '../widgets/event_card.dart';
import '../../../core/lunar/lunar_service.dart';

class CalendarHomePage extends ConsumerStatefulWidget {
  const CalendarHomePage({super.key});

  @override
  ConsumerState<CalendarHomePage> createState() => _CalendarHomePageState();
}

class _CalendarHomePageState extends ConsumerState<CalendarHomePage> {
  late DateTime _selectedMonth;
  final _lunarService = LunarService();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsForMonthProvider(_selectedMonth));

    return Scaffold(
      appBar: AppBar(
        title:
            Text('${_selectedMonth.year}年${_selectedMonth.month}月'),
        actions: [
          IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => setState(() => _selectedMonth = DateTime(
                  _selectedMonth.year, _selectedMonth.month - 1))),
          IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => setState(() => _selectedMonth = DateTime(
                  _selectedMonth.year, _selectedMonth.month + 1))),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 320,
            child: eventsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('加载失败: $err')),
              data: (events) => MonthView(
                selectedMonth: _selectedMonth,
                events: events,
                lunarService: _lunarService,
                onDateTap: (date) => _showDateEvents(date),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: eventsAsync.when(
              loading: () => const SizedBox(),
              error: (err, _) => const SizedBox(),
              data: (events) {
                if (events.isEmpty) {
                  return const Center(child: Text('本月暂无事件'));
                }
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) => EventCard(
                    event: events[index],
                    onTap: () => context
                        .push('/calendar/event/${events[index].id}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.push('/calendar/event/new'),
      ),
    );
  }

  void _showDateEvents(DateTime date) {
    final eventsAsync = ref.read(eventsForDateProvider(date));
    eventsAsync.whenData((events) {
      if (events.isEmpty) return;
      showModalBottomSheet(
        context: context,
        builder: (ctx) => ListView(
          shrinkWrap: true,
          children: events
              .map((e) => EventCard(
                    event: e,
                    onTap: () {
                      Navigator.pop(ctx);
                      context.push('/calendar/event/${e.id}');
                    },
                  ))
              .toList(),
        ),
      );
    });
  }
}
