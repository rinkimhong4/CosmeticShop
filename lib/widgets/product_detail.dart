import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmetic_shop/core/constants/app_icons.dart';
import 'package:cosmetic_shop/core/theme/app_theme.dart';
import 'package:cosmetic_shop/features/reviews/review_screen.dart';
import 'package:cosmetic_shop/models/models.dart';
import 'package:cosmetic_shop/widgets/banner_slider_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetail extends StatefulWidget {
  final ProductItem product;

  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int _currentIndex = 0;
  
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final hasDiscount = product.originalPrice != null;

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        // title: product.name,
        useNativeToolbar: true,
        actions: [
          AdaptiveAppBarAction(
            onPressed: () {},
            iosSymbol: 'heart',
            icon: Icons.favorite_border_rounded,
          ),
          AdaptiveAppBarAction(
            onPressed: () {},
            iosSymbol: 'square.and.arrow.up',
            icon: Icons.share,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  _buildImageGallery(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 12),
                        Text(
                          product.name,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildPriceRow(hasDiscount),
                        const SizedBox(height: 24),
                        _Section(
                          title: 'Description',
                          child: Text(
                            'A premium ${product.category.toLowerCase()} product crafted with high-quality ingredients to nourish and enhance your natural beauty. Dermatologically tested and suitable for daily use.',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: AppColors.gray,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _Section(
                          title: 'Product Details',
                          child: _buildDetails(),
                        ),
                        const SizedBox(height: 20),
                        _Section(title: 'Seller', child: _buildSeller()),
                        const SizedBox(height: 20),
                        _Section(title: 'Reviews', child: _buildReviews()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
      // bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildImageGallery() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 400,
          width: double.infinity,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.product.imageUrl.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (_, index) {
              return CachedNetworkImage(
                imageUrl: widget.product.imageUrl[index],
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (_, __) => const Center(
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.background,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.gray,
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.product.imageUrl.length > 1)
          Positioned(
            bottom: 12,
            child: DotIndicator(
              count: widget.product.imageUrl.length,
              currentIndex: _currentIndex,
            ),
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.product.category,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
            const SizedBox(width: 4),
            Text(
              widget.product.rating.toString(),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Text(
              ' (124 reviews)',
              style: TextStyle(fontSize: 12, color: AppColors.gray),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceRow(bool hasDiscount) {
    return Row(
      crossAxisAlignment: .end,
      children: [
        Text(
          "\$${widget.product.price}",
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (hasDiscount) ...[
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              "\$${widget.product.originalPrice}",
              style: TextStyle(
                color: AppColors.gray,
                fontSize: 14,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetails() {
    const details = {
      'Brand': 'Glow Beauty',
      'Volume': '50 ml',
      'Made in': 'France',
      'Skin type': 'All types',
    };
    return Column(
      children: details.entries.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  e.key,
                  style: TextStyle(fontSize: 13, color: AppColors.gray),
                ),
              ),
              Text(
                e.value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSeller() {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Icon(Icons.storefront_rounded, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              const Text(
                'Glow Beauty Official',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Text(
                '4.8 · 12.5k followers',
                style: TextStyle(fontSize: 12, color: AppColors.gray),
              ),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('Visit'),
        ),
      ],
    );
  }

  Widget _buildReviews() {
    final rating = widget.product.rating;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Text(
              rating.toString(),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      Icons.star_rounded,
                      color: i < rating.floor()
                          ? Colors.amber
                          : AppColors.gray.withValues(alpha: 0.3),
                      size: 18,
                    );
                  }),
                ),
                const SizedBox(height: 2),
                Text(
                  'Based on 124 reviews',
                  style: TextStyle(fontSize: 12, color: AppColors.gray),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ReviewScreen(product: widget.product),
              ),
            );
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              'See all reviews →',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: .start,
                children: [
                  // _buildQuantitySelector(),
                  Text(
                    "Total Price",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray,
                    ),
                  ),
                  Text(
                    '\$${widget.product.price.toString()}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              Expanded(
                child: CupertinoButton.filled(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(30),
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      Icon(AppIcons.cart, size: 20, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Add to Cart',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    //
                  },
                ),
              ),
              // Expanded(
              //   child: GestureDetector(
              //     onTap: () {},
              //     behavior: HitTestBehavior.opaque,
              //     child: Container(
              //       padding: const EdgeInsets.symmetric(vertical: 12),
              //       decoration: BoxDecoration(
              //         color: AppColors.primary,
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //       child:
              //       Row(
              //         mainAxisAlignment: .center,
              //         children: const [
              //           Icon(
              //             Icons.shopping_bag_outlined,
              //             size: 20,
              //             color: Colors.white,
              //           ),
              //           SizedBox(width: 8),
              //           Text(
              //             'Add to Cart',
              //             style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 15,
              //               fontWeight: FontWeight.w600,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}
