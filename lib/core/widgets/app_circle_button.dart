// lib/core/widgets/app_circle_button.dart
import 'package:flutter/material.dart';

/// Outlined circular icon button with press-scale feedback.
class AppCircleButton extends StatefulWidget {
  const AppCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 48,
    this.iconSize = 20,
    this.color,
    this.borderColor,
    this.backgroundColor = Colors.transparent,
    this.borderWidth = 1.4,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final Color? color;
  final Color? borderColor;
  final Color backgroundColor;
  final double borderWidth;

  @override
  State<AppCircleButton> createState() => _AppCircleButtonState();
}

class _AppCircleButtonState extends State<AppCircleButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final tint = widget.color ?? Theme.of(context).primaryColor;
    final border = widget.borderColor ?? tint;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            shape: BoxShape.circle,
            border: Border.all(color: border, width: widget.borderWidth),
          ),
          child: Icon(widget.icon, color: tint, size: widget.iconSize),
        ),
      ),
    );
  }
}
