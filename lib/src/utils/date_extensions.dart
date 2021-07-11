import 'package:intl/intl.dart';

// Use the following to import:
// import 'features/utils/date_extensions.dart';

extension DateUtils on DateTime {
  String? formatDate({String format = 'EEEE MMMM d'}) {
    return DateFormat(format).format(toLocal());
  }

  String? formatGameTableDate({String format = 'd MMM y | h.mma'}) {
    return DateFormat(format).format(toLocal());
  }
}
