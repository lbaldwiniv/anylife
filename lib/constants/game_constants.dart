// lib/constants/game_constants.dart

class GameConstants {
  static const int monthsPerYear = 12;

  /// Month labels indexed 1–12 (real-world month numbers)
  static const Map<int, String> monthNames = {
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December',
  };

  /// Standard hours in each month (non-leap February)
  static const Map<int, int> hoursPerMonth = {
    1: 744, // January
    2: 672, // February (normal)
    3: 744,
    4: 720,
    5: 744,
    6: 720,
    7: 744,
    8: 744,
    9: 720,
    10: 744,
    11: 720,
    12: 744,
  };

  /// Hours in February during a leap year (29 days)
  static const int leapYearFebruaryHours = 696;

  /// Helper: Get name of a month (1–12)
  static String getMonthName(int monthNumber) {
    return monthNames[monthNumber] ?? 'Unknown';
  }

  /// Helper: Get standard hours in a month (not accounting for leap years)
  static int getBaseHoursForMonth(int monthNumber) {
    return hoursPerMonth[monthNumber] ?? 0;
  }

  /// Helper: Get the ordinal suffix for a given day.
  static String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
