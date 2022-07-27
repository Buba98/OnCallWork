class DateHelper {
  static String dateToString(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute < 10 ? '0${dateTime.minute}' : dateTime.minute}';
  }
}
