class PlayerModel {
  final String firstName;
  final String lastName;
  final String countryOfBirth;
  final String cityOfBirth;
  final int birthDay;
  final int birthMonth;

  // This is runtime-only: lives evolve from 0 months old
  int ageInMonths;

  PlayerModel({
    required this.firstName,
    required this.lastName,
    required this.countryOfBirth,
    required this.cityOfBirth,
    required this.birthDay,
    required this.birthMonth,
    this.ageInMonths = 0, // ✅ Start at 0 months old
  });

  // Converts JSON → PlayerModel
  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      firstName: json['FirstName'],
      lastName: json['LastName'],
      countryOfBirth: json['countryOfBirth'],
      cityOfBirth: json['cityOfBirth'],
      birthDay: int.parse(json['birthDay']),
      birthMonth: int.parse(json['birthMonth']),
      ageInMonths: 0, // ✅ Match default constructor
    );
  }

  // Converts PlayerModel → JSON (for saving later)
  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'countryOfBirth': countryOfBirth,
      'cityOfBirth': cityOfBirth,
      'birthDay': birthDay,
      'birthMonth': birthMonth,
      'ageInMonths': ageInMonths,
    };
  }

  // Optional: helper for full name
  String get fullName => '$firstName $lastName';
}
