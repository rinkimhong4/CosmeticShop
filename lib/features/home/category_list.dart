import 'package:cosmetic_shop/core/theme/app_theme.dart';
import 'package:cosmetic_shop/models/models.dart';
import 'package:flutter/cupertino.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({
    super.key,
    required this.items,
    this.itemSize = 62,
    this.spacing = 14,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final List<CategoryItem> items;
  final double itemSize;
  final double spacing;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    // Circle + 6px gap + ~2 lines of 12sp text ≈ 32px → reserve ~38 for label area.
    final totalHeight = itemSize + 38;

    return SizedBox(
      height: totalHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: spacing),
        itemBuilder: (context, index) =>
            _CategoryTile(item: items[index], size: itemSize),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.item, required this.size});

  final CategoryItem item;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        // Fixed width = circle size, so label below has a width to wrap into.
        width: size,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Center(child: Icon(item.icon, color: AppColors.primary)),
            ),
            if (item.label != null) ...[
              const SizedBox(height: 6),
              Text(
                item.label!,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
