import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:anylife/widgets/responsive_layout.dart';
import 'squashbutton.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final buttons = [
      SquashableButton(
        onPressed: () {
          // Navigate to Work screen
        },
        child: SizedBox(
          width: 30,
          height: 30,
          child: SvgPicture.asset(
            'icons/work-alt-svgrepo-com.svg',
            colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
          ),
        ),
      ),
      SquashableButton(
        onPressed: () {
          // Navigate to Devices screen
        },
        child: SizedBox(
          width: 30,
          height: 30,
          child: SvgPicture.asset(
            'icons/devices-svgrepo-com.svg',
            colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
          ),
        ),
      ),
      SquashableButton(
        onPressed: () {
          // Navigate to Schedule screen
        },
        child: SizedBox(
          width: 30,
          height: 30,
          child: SvgPicture.asset(
            'icons/calendar-lines-pen-svgrepo-com.svg',
            colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
          ),
        ),
      ),
      SquashableButton(
        onPressed: () {
          // Navigate to Relationships screen
        },
        child: SizedBox(
          width: 30,
          height: 30,
          child: SvgPicture.asset(
            'icons/heart-svgrepo-com.svg',
            colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
          ),
        ),
      ),
      SquashableButton(
        onPressed: () {
          // Navigate to Go Outside screen
        },
        child: SizedBox(
          width: 30,
          height: 30,
          child: SvgPicture.asset(
            'icons/globe-alt-svgrepo-com.svg',
            colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
          ),
        ),
      ),
    ];

    return ResponsiveLayout(
      breakpoint: 500,
      narrowChild: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: buttons,
        ),
      ),
      wideChild: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: buttons,
          ),
        ),
      ),
    );
  }
}
