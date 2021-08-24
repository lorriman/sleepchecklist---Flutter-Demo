const Uint32maxValue = 0xFFFFFFFF;
const UInt32minValue = 0;
const Int32maxValue = 0x7FFFFFFF;
const Int32minValue = -0x80000000;

//web app javascript can't do these
/*
const Uint64maxValue = 0xFFFFFFFFFFFFFFFF;
const Uint64minValue = 0;
const Int64maxValue = 0x7FFFFFFFFFFFFFFF;
const Int64minValue = -0x8000000000000000;
*/
extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }

  bool isDayBeforeYesterday() {
    final yesterday = DateTime.now().subtract(Duration(days: 2));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }

  bool isSameDay(final DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }

  bool isSameMonth(final DateTime other) {
    return this.year == other.year && this.month == other.month;
  }

  DateTime dayBefore() {
    return subtract(Duration(days: 1));
  }

  DateTime dayAfter() {
    return add(Duration(days: 1));
  }
}