import 'package:flutter/foundation.dart';

class MeasurementManager extends ChangeNotifier {
  String _heightUnit = 'ft';
  String _weightUnit = 'kg';
  String _speedUnit = 'mph';

  String get heightUnit => _heightUnit;
  String get weightUnit => _weightUnit;
  String get speedUnit => _speedUnit;

  void setHeightUnit(String value) {
    _heightUnit = value;
    notifyListeners();
  }

  void setWeightUnit(String value) {
    _weightUnit = value;
    notifyListeners();
  }

  void setSpeedUnit(String value) {
    _speedUnit = value;
    notifyListeners();
  }
}
