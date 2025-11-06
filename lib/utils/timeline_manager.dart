import '../models/player_model.dart';
import '../constants/game_constants.dart';

class TimelineManager {
  /// Returns a map like:
  /// {
  ///   "0 Years Old": ["July", "August", ..., "June"],
  ///   "1 Years Old": ["July", "August", ...],
  /// }
  static Map<String, List<String>> buildTimelineStructure(PlayerModel player) {
    final int totalMonths = player.ageInMonths + 1; // ✅ include current month
    final int birthMonth = player.birthMonth; // 1–12

    final List<int> rotatedMonths = _generateRotatedMonthList(
      birthMonth,
      totalMonths,
    );

    final Map<String, List<String>> yearToMonths = {};

    for (int i = 0; i < rotatedMonths.length; i++) {
      int year = i ~/ GameConstants.monthsPerYear;
      String label = "$year Years Old";

      yearToMonths.putIfAbsent(label, () => []);
      final int monthNum = rotatedMonths[i];
      yearToMonths[label]!.add(GameConstants.getMonthName(monthNum));
    }

    return yearToMonths;
  }

  /// Rotates the month list to start at birthMonth and returns only the months lived
  static List<int> _generateRotatedMonthList(int birthMonth, int livedMonths) {
    List<int> allMonths = [];

    for (int i = 0; i < livedMonths; i++) {
      int rotatedMonth = ((birthMonth - 1 + i) % 12) + 1;
      allMonths.add(rotatedMonth);
    }

    return allMonths;
  }
}
