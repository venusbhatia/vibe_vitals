import 'package:intl/intl.dart';

class Formatters {
  
  static final DateFormat _dateFormat = DateFormat('MMM d, yyyy');
  static final DateFormat _timeFormat = DateFormat('h:mm a');
  static final DateFormat _dateTimeFormat = DateFormat('MMM d, yyyy h:mm a');
  
  
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }
  
  
  static String formatTime(DateTime time) {
    return _timeFormat.format(time);
  }
  
  
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }
  
  
  static String formatNumber(num number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }
  
  
  static String formatDecimal(num number, {int decimalPlaces = 1}) {
    final formatter = NumberFormat('#,##0.' + '0' * decimalPlaces);
    return formatter.format(number);
  }
} 