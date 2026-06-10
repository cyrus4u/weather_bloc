import 'package:intl/intl.dart';

class DateConverter {
  /// change DateTime to our dateFormat ---Jun 23--- for Example
  static String changeDtToDateTime(DateTime dt) {
    final formatter = DateFormat.MMMd();
    return formatter.format(dt.toUtc()); // or dt if you don't want UTC
  }

  /// change DateTime to our dateFormat ---5:55 AM/PM--- for Example
  static String changeDtToDateTimeHour(int timestamp, int timezoneInSeconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
      isUtc: true,
    );
    final adjusted = dateTime.add(Duration(seconds: timezoneInSeconds));
    return DateFormat.jm().format(adjusted); // outputs like 5:55 AM
  }
}
