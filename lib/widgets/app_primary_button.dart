// // Plain circular icon button
// AppCircleButton(
//   icon: Icons.favorite_border,
//   color: AppColors.primary,
//   onTap: () {},
// )

// // Always-expanded CTA
// AppPrimaryButton(
//   icon: Icons.shopping_bag_outlined,
//   label: 'Add to Cart',
//   backgroundColor: AppColors.primary,
//   expandedWidth: 220,
//   onTap: () {},
// )

// // Floating action-style icon-only
// AppPrimaryButton(
//   icon: Icons.add,
//   expanded: false,
//   onTap: () {},
// )
// lib/core/widgets/app_primary_button.dart
import 'package:flutter/material.dart';

/// Morphing primary CTA — collapses to a circular icon, expands to a pill with label.
///
/// Animates `width` and swaps content between [icon]-only and [label] + [icon]
/// based on [expanded].
class AppPrimaryButton extends StatefulWidget {
  const AppPrimaryButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.label,
    this.expanded = true,
    this.height = 56,
    this.collapsedWidth = 56,
    this.expandedWidth = 168,
    this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.borderRadius,
    this.shadow = true,
  });

  final VoidCallback onTap;
  final IconData icon;
  final String? label;
  final bool expanded;
  final double height;
  final double collapsedWidth;
  final double expandedWidth;
  final Color? backgroundColor;
  final Color foregroundColor;
  final BorderRadius? borderRadius;
  final bool shadow;

  @override
  State<AppPrimaryButton> createState() => _AppPrimaryButtonState();
}

class _AppPrimaryButtonState extends State<AppPrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? Theme.of(context).primaryColor;
    final radius =
        widget.borderRadius ?? BorderRadius.circular(widget.height / 2);

    final isExpanded = widget.expanded && widget.label != null;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
          height: widget.height,
          width: isExpanded ? widget.expandedWidth : widget.collapsedWidth,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: radius,
            boxShadow: widget.shadow
                ? [
                    BoxShadow(
                      color: bg.withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: isExpanded
                ? Row(
                    key: const ValueKey('expanded'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.label!,
                        style: TextStyle(
                          color: widget.foregroundColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        widget.icon,
                        color: widget.foregroundColor,
                        size: 18,
                      ),
                    ],
                  )
                : Center(
                    key: const ValueKey('collapsed'),
                    child: Icon(
                      widget.icon,
                      color: widget.foregroundColor,
                      size: 22,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
