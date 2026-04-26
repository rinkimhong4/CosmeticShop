import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmetic_shop/core/theme/app_theme.dart';
import 'package:cosmetic_shop/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeaveReview extends StatefulWidget {
  final ProductItem product;

  const LeaveReview({super.key, required this.product});

  @override
  State<LeaveReview> createState() => _LeaveReviewState();
}

class _LeaveReviewState extends State<LeaveReview> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String get _ratingLabel {
    switch (_rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return 'Tap to rate';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(useNativeToolbar: true, title: 'Write a Review'),
      body: Padding(
        padding: const EdgeInsets.only(top: 120),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                children: [
                  _buildProductHeader(),
                  const SizedBox(height: 32),
                  _buildRatingSection(),
                  const SizedBox(height: 32),
                  _buildCommentSection(),
                  const SizedBox(height: 24),
                  _buildPhotoUpload(),
                ],
              ),
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductHeader() {
    final imageUrl = widget.product.imageUrl.isNotEmpty
        ? widget.product.imageUrl.first
        : '';

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            placeholder: (_, _) => Container(
              width: 64,
              height: 64,
              color: AppColors.gray.withValues(alpha: 0.15),
            ),
            errorWidget: (_, _, _) => Container(
              width: 64,
              height: 64,
              color: AppColors.gray.withValues(alpha: 0.15),
              child: Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.gray,
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.category,
                style: TextStyle(fontSize: 12, color: AppColors.gray),
              ),
              const SizedBox(height: 4),
              Text(
                widget.product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '\$${widget.product.price.toString()}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    child: AdaptiveButton(
                      color: AppColors.primary,
                      onPressed: () {
                        debugPrint("Re-Order Tapped");
                      },
                      label: 'Re-order',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      children: [
        const Text(
          'How would you rate this product?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final starIndex = i + 1;
            final filled = starIndex <= _rating;
            return GestureDetector(
              onTap: () => setState(() => _rating = starIndex),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  filled ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 44,
                  color: filled
                      ? Colors.amber
                      : AppColors.gray.withOpacity(0.4),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        Text(
          _ratingLabel,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _rating > 0 ? AppColors.primary : AppColors.gray,
          ),
        ),
      ],
    );
  }

  Widget _buildCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Share your experience',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.gray.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: CupertinoTextField(
            controller: _commentController,
            placeholder: 'What did you like or dislike about this product?',
            placeholderStyle: TextStyle(color: AppColors.gray, fontSize: 14),
            style: const TextStyle(fontSize: 14, height: 1.5),
            decoration: const BoxDecoration(),
            padding: const EdgeInsets.symmetric(vertical: 14),
            maxLines: 6,
            minLines: 4,
            maxLength: 500,
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add photos (optional)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildAddPhotoButton(),
              // When you have selected photos, map them here:
              // ..._photos.map(_buildPhotoTile),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddPhotoButton() {
    return GestureDetector(
      onTap: () => debugPrint('Open photo picker'),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.gray.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.gray.withOpacity(0.3),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.camera, size: 24, color: AppColors.gray),
            const SizedBox(height: 4),
            Text('Add', style: TextStyle(fontSize: 12, color: AppColors.gray)),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final canSubmit = _rating > 0;

    return ColoredBox(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: GestureDetector(
              onTap: canSubmit ? _submitReview : null,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: canSubmit
                      ? AppColors.primary
                      : AppColors.gray.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    'Submit Review',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitReview() {
    debugPrint('Submitting review:');
    debugPrint('  Rating: $_rating');
    debugPrint('  Comment: ${_commentController.text}');
    debugPrint('  Product: ${widget.product.name}');
    Navigator.of(context).pop();
  }
}
