import 'package:intl/intl.dart';

class DateUtils {
  static final zoneDateFormatter = new DateFormat("yyy-MM-ddTHH:mm:ss.SSSZ");
  static final localDateFormatter = new DateFormat("dd-MM-yy hh:mm:ss.SSS");

  static String formatToLocalDate(String datetimeZone) {
    final localDate = zoneDateFormatter.parseUTC(datetimeZone).toLocal();
    return localDateFormatter.format(localDate);
  }
}
