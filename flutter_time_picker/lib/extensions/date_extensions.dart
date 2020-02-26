import 'package:intl/intl.dart';

class DateExtensions {
  static const dateFormatLocale = 'en_US';

  static String format({String pattern, DateTime date}) {
    return DateFormat(pattern, dateFormatLocale).format(date);
  }

  static DateTime trimSeconds(DateTime dateTime) =>
      dateTime.subtract(Duration(seconds: dateTime.second));

  static String formatToMMMdyhhmma(DateTime date) =>
      DateExtensions.format(pattern: "MMM d, y, hh:mm a", date: date);

  static String formatTohhmma(DateTime time) =>
      DateExtensions.format(pattern: "hh:mm a", date: time);
}
