import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:cosmetic_shop/core/data/app_data.dart';
import 'package:cosmetic_shop/core/theme/app_theme.dart';
import 'package:cosmetic_shop/features/reviews/leave_review_screen.dart';
import 'package:cosmetic_shop/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  final ProductItem product;
  const ReviewScreen({super.key, required this.product});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  String _selectedFilter = 'Verified';
  final reviews = AppData.reviews;

  final _distribution = const {5: 0.78, 4: 0.55, 3: 0.30, 2: 0.18, 1: 0.05};

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        useNativeToolbar: true,
        title: 'Reviews',
        actions: [
          AdaptiveAppBarAction(
            iosSymbol: 'plus',
            icon: Icons.add,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LeaveReview(product: widget.product),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 120),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          children: [
            _buildSummary(),
            const SizedBox(height: 28),
            const SizedBox(height: 16),
            _buildFilterChips(),
            const SizedBox(height: 20),
            ...reviews.map(_buildReviewCard),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                widget.product.rating.toString(),
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (_) => const Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '(${widget.product.reviewCount.toString()} Reviews)',
                style: TextStyle(fontSize: 13, color: AppColors.gray),
              ),
            ],
          ),
        ),

        Expanded(
          child: Column(
            children: _distribution.entries
                .map((e) => _buildDistributionRow(e.key, e.value))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDistributionRow(int star, double fraction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 14,
            child: Text(
              '$star',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  Container(
                    height: 6,
                    color: AppColors.gray.withValues(alpha: 0.15),
                  ),
                  FractionallySizedBox(
                    widthFactor: fraction,
                    child: Container(height: 6, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final chips = ['Filter', 'Verified', 'Latest', 'Detailed Reviews'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: chips.map((label) {
          final selected = label == _selectedFilter;
          final isFilterDropdown = label == 'Filter';
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = label),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : AppColors.gray.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    if (isFilterDropdown) ...[
                      Icon(
                        Icons.tune,
                        size: 14,
                        color: selected ? Colors.white : AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: selected ? Colors.white : AppColors.primary,
                      ),
                    ),
                    if (isFilterDropdown) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: selected ? Colors.white : AppColors.primary,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(review.avatar),
                  ),
                  if (review.verified)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          size: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  review.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                review.timeAgo,
                style: TextStyle(fontSize: 12, color: AppColors.gray),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.comment,
            style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.gray),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ...List.generate(5, (i) {
                return Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: i < review.rating.floor()
                      ? Colors.amber
                      : AppColors.gray.withValues(alpha: 0.3),
                );
              }),
              const SizedBox(width: 6),
              Text(
                review.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
