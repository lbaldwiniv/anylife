import 'dart:math';
import 'package:anylife/constants/game_constants.dart';
import 'package:anylife/models/location.dart';
import 'package:anylife/constants/location_constants.dart';
import 'package:anylife/widgets/customlife/birthday_picker.dart';
import 'package:anylife/widgets/customlife/location_picker.dart';
import 'package:anylife/widgets/customlife/height_picker.dart';
import 'package:anylife/widgets/squashbutton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:anylife/utils/measurement_manager.dart';

class CustomLifeScreen extends StatefulWidget {
  const CustomLifeScreen({super.key});

  @override
  State<CustomLifeScreen> createState() => _CustomLifeScreenState();
}

class _CustomLifeScreenState extends State<CustomLifeScreen> {
  bool _isMale = true;
  bool _isEditingName = false;
  String _name = 'enter name here';
  final TextEditingController _nameController = TextEditingController();
  bool _showBirthdaySentence = false;
  bool _showHeightSentence = false;

  int _selectedMonth = 1;
  int _selectedDay = 1;

  late Country _selectedCountry;
  late City _selectedCity;

  int _selectedFeet = 5;
  int _selectedInches = 5;
  int _selectedCm = 165;

  final Random _rand = Random();

  @override
  void initState() {
    super.initState();
    _randomizeDefaults();
    _nameController.text = _name;
  }

  void _randomizeDefaults() {
    _isMale = _rand.nextBool();

    _selectedMonth = _rand.nextInt(12) + 1;
    int maxDay =
        (GameConstants.getBaseHoursForMonth(_selectedMonth) / 24).round();
    _selectedDay = _rand.nextInt(maxDay) + 1;

    _selectedCountry = countries[_rand.nextInt(countries.length)];
    if (_selectedCountry.cities.isNotEmpty) {
      _selectedCity =
          _selectedCountry.cities[_rand.nextInt(_selectedCountry.cities.length)];
    } else {
      _selectedCity = const City(name: '', flag: '');
    }

    if (_isMale) {
      _selectedCm = 160 + _rand.nextInt(31); // 160–190 cm
    } else {
      _selectedCm = 150 + _rand.nextInt(26); // 150–175 cm
    }

    double totalInches = _selectedCm / 2.54;
    _selectedFeet = totalInches ~/ 12;
    _selectedInches = totalInches.round() % 12;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _toggleGender() {
    HapticFeedback.selectionClick();
    setState(() => _isMale = !_isMale);
  }

  void _updateName(String value) {
    setState(() {
      _name = value.isNotEmpty ? value : 'enter name here';
      _isEditingName = false;
    });
  }

  Future<void> _showBirthdayPicker() async {
    final result = await showModalBottomSheet<Map<String, int>>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BirthdayPicker(
        initialMonth: _selectedMonth,
        initialDay: _selectedDay,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedMonth = result['month']!;
        _selectedDay = result['day']!;
      });
    }
  }

  void _showLocationSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: 800),
      builder: (context) => LocationPicker(
        countries: countries,
        onLocationSelected: (location) {
          setState(() {
            if (location is Country) {
              _selectedCountry = location;
              _selectedCity = const City(name: '', flag: '');
            } else if (location is City) {
              _selectedCity = location;
              _selectedCountry = countries.firstWhere(
                (country) => country.cities.contains(location),
              );
            }
          });
        },
      ),
    );
  }

  Future<void> _showHeightPicker() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => HeightPicker(
        initialFeet: _selectedFeet,
        initialInches: _selectedInches,
        initialCm: _selectedCm,
        onHeightChanged: (feet, inches, cm) {
          setState(() {
            _selectedFeet = feet;
            _selectedInches = inches;
            _selectedCm = cm;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final nameWidget = _isEditingName
        ? IntrinsicWidth(
            child: TextField(
              controller: _nameController,
              autofocus: true,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
              onSubmitted: _updateName,
              onTapOutside: (_) => _updateName(_nameController.text),
            ),
          )
        : GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                _isEditingName = true;
                _nameController.text =
                    (_name == 'enter name here') ? '' : _name;
              });
            },
            child: Text(
              _name,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: _name == 'enter name here'
                    ? FontWeight.w300
                    : FontWeight.w700,
                fontStyle: _name == 'enter name here'
                    ? FontStyle.italic
                    : FontStyle.normal,
                color: _name == 'enter name here'
                    ? colors.onSurfaceVariant
                    : colors.onSurface,
              ),
            ),
          );

    final nameAndGenderWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'I am a ',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              GestureDetector(
                onTap: _toggleGender,
                child: Text(
                  _isMale ? 'male' : 'female',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: _isMale ? Colors.blue : Colors.pinkAccent,
                  ),
                ),
              ),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                ' named ',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              nameWidget,
            ],
          ),
        ],
      ),
    );

    final birthdayAndLocationWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: colors.onSurface,
              ),
              children: [
                const TextSpan(text: 'I was born on '),
                TextSpan(
                  text:
                      '${GameConstants.getMonthName(_selectedMonth)} $_selectedDay${GameConstants.getDaySuffix(_selectedDay)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = _showBirthdayPicker,
                ),
                const TextSpan(text: ' in\n'),
                TextSpan(
                  text: _selectedCity.name.isNotEmpty
                      ? '${_selectedCity.name}, ${_selectedCountry.name}'
                      : _selectedCountry.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = _showLocationSelection,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final heightSentenceWidget = Consumer<MeasurementManager>(
      builder: (context, measurementManager, _) {
        final isMetric = measurementManager.heightUnit == 'cm';
        final heightText = isMetric
            ? '$_selectedCm cm'
            : '${_selectedFeet}ft ${_selectedInches}inches';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: colors.onSurface,
                  ),
                  children: [
                    const TextSpan(text: 'When I grow up, I will be '),
                    TextSpan(
                      text: heightText,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      recognizer:
                          TapGestureRecognizer()..onTap = _showHeightPicker,
                    ),
                    const TextSpan(text: ' tall'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        height: _showBirthdaySentence ? 0.0 : 40.0,
                      ),
                      nameAndGenderWidget,
                      const SizedBox(height: 38), // spacing added here
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, 0.2),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: _showBirthdaySentence
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  birthdayAndLocationWidget,
                                  const SizedBox(height: 38), // more spacing
                                  AnimatedSwitcher(
                                    duration:
                                        const Duration(milliseconds: 500),
                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(0.0, 0.2),
                                            end: Offset.zero,
                                          ).animate(animation),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: _showHeightSentence
                                        ? heightSentenceWidget
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
        child: SquashableButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            setState(() {
              if (!_showBirthdaySentence) {
                _showBirthdaySentence = true;
              } else if (!_showHeightSentence) {
                _showHeightSentence = true;
              } else {
                // future step
              }
            });
          },
          child: Icon(
            Icons.arrow_forward,
            color: colors.onSurface,
            size: 32,
          ),
        ),
      ),
    );
  }
}
