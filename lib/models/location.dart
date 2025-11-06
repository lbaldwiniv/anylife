import 'package:flutter/foundation.dart';

@immutable
abstract class Location {
  final String name;
  final String? flag;

  const Location({required this.name, this.flag});
}

@immutable
class Country extends Location {
  final List<City> cities;

  const Country({
    required super.name,
    super.flag,
    this.cities = const [],
  });
}

@immutable
class City extends Location {
  const City({required super.name, super.flag});
}
