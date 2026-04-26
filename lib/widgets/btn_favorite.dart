import 'package:cosmetic_shop/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BtnFavorite extends StatelessWidget {
  const BtnFavorite({
    super.key,
    required this.isFavorite,
    required this.onChanged,
    this.size = 44,
  });

  final bool isFavorite;
  final ValueChanged<bool> onChanged;
  final double size;

  void _handleTap() {
    HapticFeedback.lightImpact();
    onChanged(!isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _handleTap,
        child: Container(
          height: size,
          width: size,
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              key: ValueKey(isFavorite), // forces AnimatedSwitcher to rebuild
              color: isFavorite ? Colors.red : AppColors.gray,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
