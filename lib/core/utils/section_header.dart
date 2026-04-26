import 'dart:ui';

import 'package:cosmetic_shop/core/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const SectionHeader({super.key, required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onSeeAll,
          child: const Text(
            'See All',
            style: TextStyle(fontSize: 14, color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
