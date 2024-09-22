// lib/core/utils/date_time_utils.dart
import 'package:intl/intl.dart';  // Import thư viện intl

class DateTimeUtils {
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }
}
