import 'package:intl/intl.dart';

class Utils {
  static final NumberFormat numberFormat = new NumberFormat("###0.00");
  static final DateFormat dbDateFormat = new DateFormat("yyyy-MM-dd HH:mm:ss");
  static final DateFormat dateFormat = new DateFormat("dd/MM/yyyy");
  static final DateFormat timeFormat = new DateFormat("HH:mm");
}
