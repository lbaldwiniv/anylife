import '../models/player_model.dart';

class SnapshotManager {
  final Map<String, PlayerModel> _snapshots = {};

  void saveSnapshot(String label, PlayerModel model) {
    _snapshots[label] = model.copy();
  }

  PlayerModel? getSnapshot(String label) => _snapshots[label];

  List<String> get availableLabels => _snapshots.keys.toList();
}

extension PlayerModelCopy on PlayerModel {
  PlayerModel copy() {
    return PlayerModel(
      firstName: firstName,
      lastName: lastName,
      countryOfBirth: countryOfBirth,
      cityOfBirth: cityOfBirth,
      birthDay: birthDay,
      birthMonth: birthMonth,
      ageInMonths: ageInMonths,
    );
  }
}
