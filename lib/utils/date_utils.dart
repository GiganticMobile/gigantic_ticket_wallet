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
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return 'Sunday';
    }
  }

  /// converts Date Time to DD/MM/YYYY format
  static String convertDateTimeToString(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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
