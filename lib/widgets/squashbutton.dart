import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SquashableButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double squash;
  final Duration animationDuration;

  const SquashableButton({
    super.key,
    required this.child,
    this.onPressed,
    this.squash = 0.05,
    this.animationDuration = const Duration(milliseconds: 100),
  });

  @override
  SquashableButtonState createState() => SquashableButtonState();
}

class SquashableButtonState extends State<SquashableButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0 - widget.squash,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    _controller.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(_) {
    _controller.reverse();
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
