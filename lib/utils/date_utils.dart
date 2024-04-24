/// handles converting date to and from string
class CommonDateUtils {

  /// This converts dates as an int to a DateTime value
  static DateTime getDateFromInt(int date) {
    //startTimeJson is in seconds so converted to
    // milliseconds by multiplying by 1000
    final dateInMilliseconds = date * 1000;
    return DateTime.fromMillisecondsSinceEpoch(dateInMilliseconds);
  }

  /// Converts DateTime to day of the week string
  static String convertDateTimeToDay(DateTime date) {
    switch(date.weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      default:
        return 'Sunday';
    }
  }

  /// converts Date Time to DD/MM/YYYY format
  static String convertDateTimeToString(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// converts Date Time to Saturday 16th March 2024 format
  static String convertDateTimeToLongDateString(DateTime date) {

    final day = convertDateTimeToDay(date);
    final String month;
    switch(date.month) {
      case DateTime.january:
        month = 'January';
      case DateTime.february:
        month = 'February';
      case DateTime.march:
        month = 'March';
      case DateTime.april:
        month = 'April';
      case DateTime.may:
        month = 'May';
      case DateTime.june:
        month = 'June';
      case DateTime.july:
        month = 'July';
      case DateTime.august:
        month = 'August';
      case DateTime.september:
        month = 'September';
      case DateTime.october:
        month = 'October';
      case DateTime.november:
        month = 'November';
      default:
        month = 'December';
    }

    return '$day ${date.day} $month ${date.year}';
  }

  /// converts DateTime to hours:minutes format
  static String convertTimeToString(DateTime time) {
    final String minutes;
    if (time.minute < 10) {
      minutes = '0${time.minute}';
    } else {
      minutes = time.minute.toString();
    }

    final String hours;
    if (time.hour < 10) {
      hours = '0${time.hour}';
    } else {
      hours = time.hour.toString();
    }

    return '$hours:$minutes';
  }
}
