import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime dateTime, {bool include24h = true}) {
    if (include24h) {
      return DateFormat('EEEE, MMM d, yyyy').format(dateTime);
    }
    return DateFormat('EEEE, MMM d').format(dateTime);
  }
  
  static String formatTime(DateTime dateTime, {bool use24hFormat = true}) {
    if (use24hFormat) {
      return DateFormat('HH:mm').format(dateTime);
    }
    return DateFormat('hh:mm a').format(dateTime);
  }
  
  static String formatDateWithTime(DateTime dateTime) {
    return DateFormat('MMM d, yyyy HH:mm').format(dateTime);
  }
}
