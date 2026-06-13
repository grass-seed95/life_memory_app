import 'package:lunar/lunar.dart';

class LunarService {
  String solarToLunar(DateTime date) {
    final solar = Solar.fromYmd(date.year, date.month, date.day);
    final lunar = solar.getLunar();
    return '${lunar.getMonthInChinese()}月${lunar.getDayInChinese()}';
  }

  Map<String, String> getLunarYearInfo(int year) {
    final lunar = Lunar.fromYmd(year, 1, 1);
    return {
      'yearName': lunar.getYearInChinese(),
      'zodiac': lunar.getYearShengXiao(),
    };
  }

  String? getHoliday(DateTime date) {
    final solar = Solar.fromYmd(date.year, date.month, date.day);
    final lunar = solar.getLunar();

    final festivals = lunar.getFestivals();
    if (festivals.isNotEmpty) return festivals.first;

    final solarFestivals = solar.getFestivals();
    if (solarFestivals.isNotEmpty) return solarFestivals.first;

    final jieQi = lunar.getJieQi();
    if (jieQi.isNotEmpty) return jieQi;

    return null;
  }

  Map<String, String> getLunarDayDisplay(DateTime date) {
    final solar = Solar.fromYmd(date.year, date.month, date.day);
    final lunar = solar.getLunar();
    return {
      'month': lunar.getMonthInChinese(),
      'day': lunar.getDayInChinese(),
    };
  }

  DateTime lunarToNextSolar(int lunarMonth, int lunarDay) {
    final today = DateTime.now();
    final lunar = Lunar.fromYmd(today.year, lunarMonth, lunarDay);
    final solar = lunar.getSolar();
    final nextDate = DateTime(today.year, solar.getMonth(), solar.getDay());
    if (nextDate.isBefore(today)) {
      final nextLunar = Lunar.fromYmd(today.year + 1, lunarMonth, lunarDay);
      final nextSolar = nextLunar.getSolar();
      return DateTime(today.year + 1, nextSolar.getMonth(), nextSolar.getDay());
    }
    return nextDate;
  }
}
