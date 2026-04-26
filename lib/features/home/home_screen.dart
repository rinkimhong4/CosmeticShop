import 'package:cosmetic_shop/core/data/app_data.dart';
import 'package:cosmetic_shop/core/utils/section_header.dart';
import 'package:cosmetic_shop/features/home/appbar.dart';
import 'package:cosmetic_shop/features/home/category_list.dart';
import 'package:cosmetic_shop/features/orders/order_screen.dart';
import 'package:cosmetic_shop/models/models.dart';
import 'package:cosmetic_shop/widgets/banner_slider_widget.dart';
import 'package:cosmetic_shop/widgets/product_card_widget.dart';
import 'package:cosmetic_shop/widgets/product_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final banners = AppData.banners;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // app bar
          SliverPersistentHeader(
            pinned: true,
            delegate: HomeHeaderDelegate(
              topPadding: topPadding,
              onCartTap: () => Get.to(() => const OrderScreen()),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // top banner slider
                SectionHeader(title: 'Special Offers', onSeeAll: () {}),
                const SizedBox(height: 20),
                BannerSlider(banners: banners),

                // category
                const SizedBox(height: 20),
                SectionHeader(title: 'Category', onSeeAll: () {}),
                const SizedBox(height: 20),
                CategoryList(
                  items: AppData.categories
                      .map(
                        (c) => CategoryItem(
                          icon: c.icon,
                          label: c.label,
                          // onTap: () => _onCategoryTap(c),
                          onTap: () => debugPrint("Category tap ${c.label}"),
                        ),
                      )
                      .toList(),
                ),
                // recommend for you + products card
                const SizedBox(height: 20),
                SectionHeader(title: "Recommended for you", onSeeAll: () {}),
              ]),
            ),
          ),

          //  Products grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = AppData.products[index];
                return ProductCardWidget(
                  product: product,
                  // onTap: () => debugPrint('Tap product ${product.name}'),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute(
                        builder: (_) => ProductDetail(product: product),
                        fullscreenDialog: false,
                      ),
                    );
                  },
                  onFavoriteToggle: (v) =>
                      debugPrint('Fav ${product.name}: $v'),
                );
              }, childCount: AppData.products.length),
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
