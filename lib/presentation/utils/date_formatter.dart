import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime time) {
    String result = DateFormat('h:mm').format(time);
    return result;
  }
}
