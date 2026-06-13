import 'package:flutter_test/flutter_test.dart';
import 'package:life_memory_app/core/lunar/lunar_service.dart';

void main() {
  late LunarService service;

  setUp(() {
    service = LunarService();
  });

  group('LunarService', () {
    test('converts solar date to lunar date string', () {
      final result = service.solarToLunar(DateTime(2026, 1, 29));
      expect(result, contains('正月'));
      expect(result, contains('初一'));
    });

    test('returns lunar year info', () {
      final info = service.getLunarYearInfo(2026);
      expect(info['yearName'], isNotEmpty);
      expect(info['zodiac'], isNotEmpty);
    });

    test('checks if date is a traditional holiday', () {
      final holiday = service.getHoliday(DateTime(2026, 6, 19));
      expect(holiday, isNotNull);
      expect(holiday, contains('端午'));
    });

    test('returns null for non-holiday solar date', () {
      final holiday = service.getHoliday(DateTime(2026, 3, 15));
      expect(holiday, isNull);
    });

    test('gets lunar month and day for display', () {
      final lunar = service.getLunarDayDisplay(DateTime(2026, 6, 19));
      expect(lunar['month'], isNotEmpty);
      expect(lunar['day'], isNotEmpty);
    });
  });
}
