/*
Class that parsers data to required/better format
Has static methods, we don't create an instance of this class
 */
class Parser {
  // static String parseDateTime(String dateTime) {
  //   return DateFormat('dd-MM-yyyy – kk:mm')
  //       .format(DateTime.parse(dateTime).toLocal());
  // }
  //
  // static String getTimeFromDateTimeString(String dateTime) {
  //   return DateFormat('kk:mm').format(DateTime.parse(dateTime).toLocal());
  // }

  static String parseEmail(String email) {
    return email.toString().split("@")[0];
  }

  static stringToDateTime(String dateTime) {
    return DateTime.parse(dateTime);
  }
}
