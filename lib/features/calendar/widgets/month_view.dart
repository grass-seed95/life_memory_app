import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/event_provider.dart';
import '../../../core/lunar/lunar_service.dart';
import '../../../core/database/database.dart';

class MonthView extends StatelessWidget {
  final DateTime selectedMonth;
  final List<Event> events;
  final void Function(DateTime) onDateTap;
  final LunarService lunarService;

  const MonthView({
    super.key,
    required this.selectedMonth,
    required this.events,
    required this.onDateTap,
    required this.lunarService,
  });

  static const _dayHeaders = ['一', '二', '三', '四', '五', '六', '日'];

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(
        selectedMonth.year, selectedMonth.month);
    final firstDayOffset =
        (DateTime(selectedMonth.year, selectedMonth.month, 1).weekday - 1) %
            7;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    return Column(
      children: [
        Row(
          children: _dayHeaders.map((day) {
            final isWeekend = day == '六' || day == '日';
            return Expanded(
              child: Center(
                child: Text(day,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isWeekend ? Colors.red[300] : null,
                    )),
              ),
            );
          }).toList(),
        ),
        const Divider(height: 1),
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7),
            itemCount: firstDayOffset + daysInMonth,
            itemBuilder: (context, index) {
              if (index < firstDayOffset) return const SizedBox.shrink();
              final day = index - firstDayOffset + 1;
              final date =
                  DateTime(selectedMonth.year, selectedMonth.month, day);
              final isToday = date == todayDate;
              final dateEvents = events
                  .where((e) =>
                      e.date == DateFormat('yyyy-MM-dd').format(date))
                  .toList();

              return GestureDetector(
                onTap: () => onDateTap(date),
                child: Container(
                  key: isToday ? const ValueKey('today-cell') : null,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isToday
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(day.toString(),
                          style: TextStyle(
                            fontWeight:
                                isToday ? FontWeight.bold : FontWeight.normal,
                          )),
                      Text(
                        lunarService.getLunarDayDisplay(date)['day'] ?? '',
                        style: const TextStyle(
                            fontSize: 10, color: Colors.grey),
                      ),
                      if (dateEvents.isNotEmpty)
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
