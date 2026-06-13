import 'package:flutter_test/flutter_test.dart';
import 'package:life_memory_app/features/calendar/providers/event_provider.dart';

void main() {
  group('EventForm validation', () {
    test('valid when title and date are provided', () {
      final errors = EventFormData.validate(
        title: '生日',
        date: DateTime(2026, 6, 15),
      );
      expect(errors, isEmpty);
    });

    test('fails when title is empty', () {
      final errors = EventFormData.validate(
        title: '',
        date: DateTime(2026, 6, 15),
      );
      expect(errors, contains('请输入标题'));
    });

    test('fails when date is null', () {
      final errors = EventFormData.validate(
        title: '生日',
        date: null,
      );
      expect(errors, contains('请选择日期'));
    });
  });

  group('EventRepeatRule', () {
    test('yearly rule generates next year date', () {
      final next =
          EventRepeatRule.yearly.nextOccurrence(DateTime(2026, 6, 15));
      expect(next, DateTime(2027, 6, 15));
    });

    test('monthly rule generates next month date', () {
      final next =
          EventRepeatRule.monthly.nextOccurrence(DateTime(2026, 6, 15));
      expect(next, DateTime(2026, 7, 15));
    });

    test('none rule returns null', () {
      final next =
          EventRepeatRule.none.nextOccurrence(DateTime(2026, 6, 15));
      expect(next, isNull);
    });
  });
}
