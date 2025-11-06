import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:anylife/utils/measurement_manager.dart';

/// Enables scrolling via both touch and mouse.
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class HeightPicker extends StatefulWidget {
  final int initialFeet;
  final int initialInches;
  final int initialCm;
  final Function(int feet, int inches, int cm) onHeightChanged;

  const HeightPicker({
    super.key,
    this.initialFeet = 5,
    this.initialInches = 8,
    this.initialCm = 170,
    required this.onHeightChanged,
  });

  @override
  State<HeightPicker> createState() => _HeightPickerState();
}

class _HeightPickerState extends State<HeightPicker> {
  late int _selectedFeet;
  late int _selectedInches;
  late int _selectedCm;
  late FixedExtentScrollController _feetController;
  late FixedExtentScrollController _inchesController;
  late FixedExtentScrollController _cmController;

  @override
  void initState() {
    super.initState();
    _selectedFeet = widget.initialFeet;
    _selectedInches = widget.initialInches;
    _selectedCm = widget.initialCm;
    _feetController =
        FixedExtentScrollController(initialItem: _selectedFeet - 1);
    _inchesController =
        FixedExtentScrollController(initialItem: _selectedInches);
    _cmController = FixedExtentScrollController(initialItem: _selectedCm - 100);
  }

  @override
  void dispose() {
    _feetController.dispose();
    _inchesController.dispose();
    _cmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: colors.onSurface,
    );

    return Consumer<MeasurementManager>(
      builder: (context, measurementManager, _) {
        final isMetric = measurementManager.heightUnit == 'cm';

        return Container(
          height: 250,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select Your Height',
                  style: textStyle.copyWith(fontWeight: FontWeight.bold),
                ),
              ),

              // Scrollable pickers
              Expanded(
                child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: isMetric
                      ? _buildCmPicker(textStyle)
                      : _buildFeetInchesPicker(textStyle),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// --- FEET + INCHES PICKER ---
  Widget _buildFeetInchesPicker(TextStyle textStyle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CupertinoPicker(
            scrollController: _feetController,
            itemExtent: 32,
            onSelectedItemChanged: (int index) {
              setState(() => _selectedFeet = index + 1);
              widget.onHeightChanged(
                  _selectedFeet, _selectedInches, _selectedCm);
            },
            children: List<Widget>.generate(9, (int index) {
              return Center(
                child: Text('${index + 1} ft', style: textStyle),
              );
            }),
          ),
        ),
        Expanded(
          child: CupertinoPicker(
            scrollController: _inchesController,
            itemExtent: 32,
            onSelectedItemChanged: (int index) {
              setState(() => _selectedInches = index);
              widget.onHeightChanged(
                  _selectedFeet, _selectedInches, _selectedCm);
            },
            children: List<Widget>.generate(12, (int index) {
              return Center(
                child: Text('$index in', style: textStyle),
              );
            }),
          ),
        ),
      ],
    );
  }

  /// --- CENTIMETER PICKER ---
  Widget _buildCmPicker(TextStyle textStyle) {
    return CupertinoPicker(
      scrollController: _cmController,
      itemExtent: 32,
      onSelectedItemChanged: (int index) {
        setState(() => _selectedCm = index + 100);
        widget.onHeightChanged(_selectedFeet, _selectedInches, _selectedCm);
      },
      children: List<Widget>.generate(151, (int index) {
        final value = index + 100; // 100cm to 250cm
        return Center(
          child: Text('$value cm', style: textStyle),
        );
      }),
    );
  }
}
