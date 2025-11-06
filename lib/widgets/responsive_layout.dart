
import 'package:flutter/material.dart';

/// A responsive widget that chooses between a narrow and a wide layout.
///
/// Builds [narrowChild] for screen widths less than or equal to [breakpoint]
/// and [wideChild] for screen widths greater than [breakpoint].
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.narrowChild,
    required this.wideChild,
    this.breakpoint = 400.0,
  });

  /// The widget to display on narrow screens.
  final Widget narrowChild;

  /// The widget to display on wide screens.
  final Widget wideChild;

  /// The width at which to switch from narrow to wide.
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > breakpoint) {
          return wideChild;
        } else {
          return narrowChild;
        }
      },
    );
  }
}
