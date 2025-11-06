import 'package:flutter/material.dart';
import '../../models/player_model.dart';

class ProfileBar extends StatelessWidget {
  final PlayerModel player;

  const ProfileBar({super.key, required this.player});

  String _getFormattedAge(int ageInMonths) {
    int years = ageInMonths ~/ 12;
    int months = ageInMonths % 12;

    String ageString = '';
    if (years > 0) {
      ageString += '$years year${years > 1 ? 's' : ''}';
    }

    if (months > 0) {
      if (ageString.isNotEmpty) {
        ageString += ' ';
      }
      ageString += '$months month${months > 1 ? 's' : ''}';
    }

    if (ageString.isEmpty) {
      return 'Newborn';
    }

    return '$ageString old';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      color: colors.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            player.fullName,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: colors.onSurface,
            ),
          ),
          Text(
            _getFormattedAge(player.ageInMonths),
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              color: colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
