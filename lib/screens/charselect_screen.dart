import 'package:anylife/screens/customlife_screen.dart';
import 'package:anylife/screens/settings_screen.dart';
import 'package:anylife/screens/timeline_screen.dart';
import 'package:anylife/widgets/fade_transition_page_route.dart';
import 'package:anylife/widgets/responsive_layout.dart';
import 'package:anylife/widgets/squashbutton.dart';
import 'package:flutter/material.dart';

class CharSelectScreen extends StatelessWidget {
  const CharSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final buttonTextStyle = TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: colors.onSurface,
    );

    Widget buildStrokedButton(String text, VoidCallback onPressed) {
      return SquashableButton(
        onPressed: onPressed,
        child: Container(
          width: 160,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: colors.primary, width: 4),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: buttonTextStyle,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Anylife', style: textTheme.headlineMedium),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ResponsiveLayout(
            wideChild: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildStrokedButton(
                  'New Life',
                  () => Navigator.push(
                    context,
                    FadeTransitionPageRoute(page: const TimelineScreen()),
                  ),
                ),
                const SizedBox(width: 24),
                buildStrokedButton(
                  'Custom Life',
                  () => Navigator.push(
                    context,
                    FadeTransitionPageRoute(page: const CustomLifeScreen()),
                  ),
                ),
              ],
            ),
            narrowChild: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildStrokedButton(
                  'New Life',
                  () => Navigator.push(
                    context,
                    FadeTransitionPageRoute(page: const TimelineScreen()),
                  ),
                ),
                const SizedBox(height: 24),
                buildStrokedButton(
                  'Custom Life',
                  () => Navigator.push(
                    context,
                    FadeTransitionPageRoute(page: const CustomLifeScreen()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
