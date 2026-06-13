import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:life_memory_app/features/calendar/widgets/month_view.dart';
import 'package:life_memory_app/core/lunar/lunar_service.dart';

void main() {
  final lunarService = LunarService();

  testWidgets('MonthView renders 7 day headers', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MonthView(
            selectedMonth: DateTime(2026, 6),
            events: [],
            lunarService: lunarService,
            onDateTap: (date) {},
          ),
        ),
      ),
    );

    expect(find.text('一'), findsOneWidget);
    expect(find.text('日'), findsOneWidget);
  });

  testWidgets('MonthView shows all days of June 2026', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MonthView(
            selectedMonth: DateTime(2026, 6),
            events: [],
            lunarService: lunarService,
            onDateTap: (date) {},
          ),
        ),
      ),
    );

    expect(find.text('30'), findsOneWidget);
    expect(find.text('31'), findsNothing);
  });
}
