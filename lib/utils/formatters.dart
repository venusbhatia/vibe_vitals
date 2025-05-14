import 'package:intl/intl.dart';

class Formatters {
  // Date formatters
  static final DateFormat _dateFormat = DateFormat('MMM d, yyyy');
  static final DateFormat _timeFormat = DateFormat('h:mm a');
  static final DateFormat _dateTimeFormat = DateFormat('MMM d, yyyy h:mm a');
  
  // Format a date
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }
  
  // Format a time
  static String formatTime(DateTime time) {
    return _timeFormat.format(time);
  }
  
  // Format a date and time
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }
  
  // Format a number with commas
  static String formatNumber(num number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }
  
  // Format a decimal number
  static String formatDecimal(num number, {int decimalPlaces = 1}) {
    final formatter = NumberFormat('#,##0.' + '0' * decimalPlaces);
    return formatter.format(number);
  }
} 