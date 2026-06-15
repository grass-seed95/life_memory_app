import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/database/database.dart';

final outfitLogsForDateProvider =
    FutureProvider.family<List<OutfitLog>, DateTime>(
  (ref, date) async {
    final db = ref.watch(databaseProvider);
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final query =
        db.select(db.outfitLogs)..where((t) => t.date.equals(dateStr));
    return await query.get();
  },
);

final outfitLogsByMonthProvider =
    FutureProvider.family<List<OutfitLog>, DateTime>(
  (ref, month) async {
    final db = ref.watch(databaseProvider);
    final start = DateFormat('yyyy-MM-dd')
        .format(DateTime(month.year, month.month, 1));
    final end = DateFormat('yyyy-MM-dd')
        .format(DateTime(month.year, month.month + 1, 1));
    final query = db.select(db.outfitLogs)
      ..where((t) => t.date.isBiggerOrEqualValue(start))
      ..where((t) => t.date.isSmallerThanValue(end));
    return await query.get();
  },
);

final outfitHistoryProvider =
    FutureProvider<List<OutfitLog>>((ref) async {
  final db = ref.watch(databaseProvider);
  final query = db.select(db.outfitLogs)
    ..orderBy([(t) => OrderingTerm.desc(t.date)]);
  return await query.get();
});
