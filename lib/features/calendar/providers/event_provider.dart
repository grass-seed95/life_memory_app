import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';

enum EventRepeatRule {
  none,
  yearly,
  monthly,
  weekly;

  DateTime? nextOccurrence(DateTime from) {
    switch (this) {
      case EventRepeatRule.yearly:
        return DateTime(from.year + 1, from.month, from.day);
      case EventRepeatRule.monthly:
        return DateTime(from.year, from.month + 1, from.day);
      case EventRepeatRule.weekly:
        return from.add(const Duration(days: 7));
      case EventRepeatRule.none:
        return null;
    }
  }

  String get label {
    switch (this) {
      case EventRepeatRule.none:
        return '不重复';
      case EventRepeatRule.yearly:
        return '每年';
      case EventRepeatRule.monthly:
        return '每月';
      case EventRepeatRule.weekly:
        return '每周';
    }
  }

  static EventRepeatRule fromRepeatRule(String? rule) {
    switch (rule) {
      case 'yearly':
        return EventRepeatRule.yearly;
      case 'monthly':
        return EventRepeatRule.monthly;
      case 'weekly':
        return EventRepeatRule.weekly;
      default:
        return EventRepeatRule.none;
    }
  }

  String? toRepeatRule() {
    switch (this) {
      case EventRepeatRule.yearly:
        return 'yearly';
      case EventRepeatRule.monthly:
        return 'monthly';
      case EventRepeatRule.weekly:
        return 'weekly';
      case EventRepeatRule.none:
        return null;
    }
  }
}

class EventFormData {
  final String? title;
  final DateTime? date;
  final String? type;
  final bool isLunar;
  final EventRepeatRule repeatRule;
  final String? notes;

  const EventFormData({
    this.title,
    this.date,
    this.type,
    this.isLunar = false,
    this.repeatRule = EventRepeatRule.none,
    this.notes,
  });

  static List<String> validate({
    required String title,
    required DateTime? date,
  }) {
    final errors = <String>[];
    if (title.trim().isEmpty) errors.add('请输入标题');
    if (date == null) errors.add('请选择日期');
    return errors;
  }
}

final eventsForMonthProvider =
    FutureProvider.family<List<Event>, DateTime>((ref, month) async {
  final db = ref.watch(databaseProvider);
  final start = DateTime(month.year, month.month, 1);
  final startStr =
      '${start.year}-${start.month.toString().padLeft(2, '0')}-01';
  final end =
      DateTime(month.year, month.month + 1, 1);
  final endStr =
      '${end.year}-${end.month.toString().padLeft(2, '0')}-01';

  final query = db.select(db.events)
    ..where((t) => t.date.isBiggerOrEqualValue(startStr))
    ..where((t) => t.date.isSmallerThanValue(endStr))
    ..orderBy([(t) => OrderingTerm.asc(t.date)]);

  return await query.get();
});

final eventsForDateProvider =
    FutureProvider.family<List<Event>, DateTime>((ref, date) async {
  final db = ref.watch(databaseProvider);
  final dateStr =
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  final query =
      db.select(db.events)..where((t) => t.date.equals(dateStr));
  return await query.get();
});
