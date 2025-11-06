
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:anylife/constants/game_constants.dart';

// A custom scroll behavior that enables scrolling via mouse drag.
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class BirthdayPicker extends StatefulWidget {
  final int initialMonth;
  final int initialDay;

  const BirthdayPicker({
    super.key,
    required this.initialMonth,
    required this.initialDay,
  });

  @override
  State<BirthdayPicker> createState() => _BirthdayPickerState();
}

class _BirthdayPickerState extends State<BirthdayPicker> {
  late int _selectedMonth;
  late int _selectedDay;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _dayController;

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.initialMonth;
    _selectedDay = widget.initialDay;
    _monthController =
        FixedExtentScrollController(initialItem: _selectedMonth - 1);
    _dayController = FixedExtentScrollController(initialItem: _selectedDay - 1);
  }

  @override
  void dispose() {
    _monthController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  int _daysInMonth(int month) {
    return (GameConstants.hoursPerMonth[month] ?? 672) ~/ 24;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: colors.onSurface,
    );

    final pickerContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              CupertinoButton(
                onPressed: () {
                  Navigator.of(context).pop({
                    'month': _selectedMonth,
                    'day': _selectedDay,
                  });
                },
                child: const Text(
                  'Done',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220, // Explicit height for the pickers
          child: ScrollConfiguration(
            // Apply the custom scroll behavior to the pickers.
            behavior: MyCustomScrollBehavior(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CupertinoPicker(
                    scrollController: _monthController,
                    itemExtent: 32,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _selectedMonth = index + 1;
                        final maxDays = _daysInMonth(_selectedMonth);
                        if (_selectedDay > maxDays) {
                          _selectedDay = maxDays;
                          if (_dayController.hasClients) {
                            _dayController.animateToItem(
                              _selectedDay - 1,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                            );
                          }
                        }
                      });
                    },
                    children: List<Widget>.generate(12, (int index) {
                      return Center(
                        child: Text(
                          GameConstants.monthNames[index + 1]!,
                          style: textStyle,
                        ),
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: _dayController,
                    itemExtent: 32,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _selectedDay = index + 1;
                      });
                    },
                    key: ValueKey<int>(_selectedMonth),
                    children: List<Widget>.generate(
                      _daysInMonth(_selectedMonth),
                      (int index) {
                        return Center(
                          child: Text(
                            '${index + 1}',
                            style: textStyle,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          clipBehavior: Clip.antiAlias,
          child: pickerContent,
        ),
      ),
    );
  }
}
