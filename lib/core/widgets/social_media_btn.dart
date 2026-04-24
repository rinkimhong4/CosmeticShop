import 'package:cosmetic_shop/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SocialMediaBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const SocialMediaBtn({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              // color: AppColors.primary,
              border: Border.all(color: AppColors.gray, width: 1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24),
          ),
        ),
      ],
    );
  }
}
