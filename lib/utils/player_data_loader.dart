import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/player_model.dart';

Future<PlayerModel> loadPlayerData() async {
  final jsonString = await rootBundle.loadString(
    'data/player_data.json',
  );
  final Map<String, dynamic> jsonMap = json.decode(jsonString);
  return PlayerModel.fromJson(jsonMap);
}
