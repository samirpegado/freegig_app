import 'package:intl/intl.dart';

class FormatDate {
  String formatDateString(String dateString) {
    List<String> dateParts = dateString.split('-');
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    DateTime dateTime = DateTime(year, month, day);

    String formattedDate = DateFormat('d MMMM', 'pt_BR').format(dateTime);

    return formattedDate;
  }
}
