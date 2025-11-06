import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anylife/utils/theme_manager.dart';
import 'package:anylife/utils/measurement_manager.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showMeasurementOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Consumer<MeasurementManager>(
          builder: (context, measurementManager, _) {
            return Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Measurements',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),

                  // HEIGHT
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Height',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    trailing: DropdownButton<String>(
                      value: measurementManager.heightUnit,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          measurementManager.setHeightUnit(newValue);
                        }
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'ft',
                          child: Text('Feet and Inches'),
                        ),
                        DropdownMenuItem(
                          value: 'cm',
                          child: Text('Centimeters'),
                        ),
                      ],
                    ),
                  ),

                  // WEIGHT
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Weight',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    trailing: DropdownButton<String>(
                      value: measurementManager.weightUnit,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          measurementManager.setWeightUnit(newValue);
                        }
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'kg',
                          child: Text('Kilograms'),
                        ),
                        DropdownMenuItem(
                          value: 'lbs',
                          child: Text('Pounds'),
                        ),
                        DropdownMenuItem(
                          value: 'st',
                          child: Text('Stones'),
                        ),
                      ],
                    ),
                  ),

                  // SPEED
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Speed',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    trailing: DropdownButton<String>(
                      value: measurementManager.speedUnit,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          measurementManager.setSpeedUnit(newValue);
                        }
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'mph',
                          child: Text('mph'),
                        ),
                        DropdownMenuItem(
                          value: 'kmh',
                          child: Text('km/h'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          // THEME TOGGLE
          Consumer<ThemeManager>(
            builder: (context, themeManager, _) {
              return ListTile(
                leading: Icon(
                  themeManager.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                title: Text(
                  themeManager.isDarkMode ? 'Light Mode' : 'Dark Mode',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: themeManager.toggleTheme,
              );
            },
          ),

          // MEASUREMENT SETTINGS
          ListTile(
            leading: const Icon(Icons.straighten),
            title: Text(
              'Measurements',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () => _showMeasurementOptions(context),
          ),
        ],
      ),
    );
  }
}
