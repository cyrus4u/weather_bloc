import 'package:intl/intl.dart';

class DateConverter {
  /// change DateTime to our dateFormat ---Jun 23--- for Example
  static String changeDtToDateTime(DateTime dt) {
    final formatter = DateFormat.MMMd();
    return formatter.format(dt.toUtc()); // or dt if you don't want UTC
  }

  /// change DateTime to our dateFormat ---5:55 AM/PM--- for Example
  static String changeDtToDateTimeHour(DateTime dt, int timeZoneInSeconds) {
    final formatter = DateFormat.jm();
    // adjust timezone by seconds
    final adjusted = dt.add(Duration(seconds: timeZoneInSeconds));
    return formatter.format(adjusted.toUtc()); // or just adjusted
  }
}
