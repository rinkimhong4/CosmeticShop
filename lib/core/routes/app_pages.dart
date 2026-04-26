import 'package:cosmetic_shop/core/routes/app_routes.dart';
import 'package:cosmetic_shop/features/explore/explore_screen.dart';
import 'package:cosmetic_shop/features/main_navigation_screen.dart';
import 'package:cosmetic_shop/features/profile/profile_screen.dart';
import 'package:cosmetic_shop/features/wishlist/wish_list_screen.dart';
import 'package:get/get.dart';

class AppRouting {
  static final route = RouteView.values.map((e) {
    switch (e) {
      case RouteView.home:
        return GetPage(
          name: "/",
          page: () => MainNavigationScreen(),
          transition: Transition.noTransition,
        );
      case RouteView.explore:
        return GetPage(name: "/${e.name}", page: () => ExploreScreen());
      case RouteView.wishlist:
        return GetPage(name: "/${e.name}", page: () => WishListScreen());
      case RouteView.profile:
        return GetPage(name: "/${e.name}", page: () => ProfileScreen());
    }
  }).toList();
}
