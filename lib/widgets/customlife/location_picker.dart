import 'package:anylife/models/location.dart';
import 'package:anylife/widgets/squashbutton.dart';
import 'package:flutter/material.dart';

class LocationPicker extends StatefulWidget {
  final List<Country> countries;
  final Function(Location) onLocationSelected;

  const LocationPicker({
    super.key,
    required this.countries,
    required this.onLocationSelected,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  Country? _selectedCountry;

  void _onCountryTapped(Country country) {
    if (country.cities.isNotEmpty) {
      setState(() => _selectedCountry = country);
    } else {
      widget.onLocationSelected(country);
      Navigator.pop(context);
    }
  }

  void _onCityTapped(City city) {
    widget.onLocationSelected(city);
    Navigator.pop(context);
  }

  void _onBackPressed() => setState(() => _selectedCountry = null);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(textTheme),
          Expanded(child: _buildContent(colors)),
        ],
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme) {
    final headerStyle = textTheme.headlineSmall?.copyWith(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.bold,
    );

    final isCountryList = _selectedCountry == null;
    final title = isCountryList ? 'Select a Country' : 'Select a City';
    final onPressed =
        isCountryList ? () => Navigator.pop(context) : _onBackPressed;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Padding(
        key: ValueKey(title),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            SquashableButton(
              onPressed: onPressed,
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(Icons.arrow_back),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 52.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: headerStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ColorScheme colors) {
    final isCountryList = _selectedCountry == null;
    final items = isCountryList ? widget.countries : _selectedCountry!.cities;

    final screenWidth = MediaQuery.of(context).size.width;

    final itemsPerRow = isCountryList
        ? (screenWidth < 600 ? 2 : 3)
        : (screenWidth < 600
            ? 1
            : screenWidth < 900
                ? 2
                : 3);

    final totalSpacing = (itemsPerRow - 1) * 16.0;
    final itemWidth = (screenWidth - 32 - totalSpacing) / itemsPerRow;
    final itemHeight = isCountryList ? itemWidth * 0.75 : itemWidth * 0.85;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: items.map((item) {
          final flag = item.flag;
          final hasFlag = flag?.isNotEmpty ?? false;

          String imagePath = flag ?? '';
          if (imagePath.startsWith('assets/')) {
            imagePath = imagePath.substring('assets/'.length);
          }

          return SquashableButton(
            onPressed: () {
              if (isCountryList) {
                _onCountryTapped(item as Country);
              } else {
                _onCityTapped(item as City);
              }
            },
            child: Container(
              width: itemWidth,
              constraints: BoxConstraints(minHeight: itemHeight),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: itemHeight * (isCountryList ? 0.75 : 0.8),
                    child: hasFlag
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(imagePath, fit: BoxFit.contain),
                          )
                        : const Icon(Icons.public, size: 60),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
