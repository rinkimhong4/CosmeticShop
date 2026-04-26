import 'dart:io';

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:cosmetic_shop/core/constants/app_icons.dart';
import 'package:cosmetic_shop/core/theme/app_theme.dart';
import 'package:cosmetic_shop/features/explore/explore_screen.dart';
import 'package:cosmetic_shop/features/home/home_screen.dart';
import 'package:cosmetic_shop/features/profile/profile_screen.dart';
import 'package:cosmetic_shop/features/wishlist/wish_list_screen.dart';
import 'package:flutter/material.dart';

class MainTab {
  static const home = 0;
  static const explore = 1;
  static const wishlist = 2;
  static const profile = 3;
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  static final bool _isIOS = Platform.isIOS;

  final List<Widget> _pages = const [
    HomeScreen(),
    ExploreScreen(),
    WishListScreen(),
    ProfileScreen(),
  ];

  void _goToTab(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MainNavigationScope(
      currentIndex: _currentIndex,
      goToTab: _goToTab,
      child: _isIOS ? _buildIOS() : _buildAndroid(),
    );
  }

  Widget _buildIOS() {
    return AdaptiveScaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: AdaptiveBottomNavigationBar(
        useNativeBottomBar: true,
        selectedIndex: _currentIndex,
        onTap: _goToTab,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.gray,
        items: const [
          AdaptiveNavigationDestination(icon: 'house.fill', label: 'Home'),
          AdaptiveNavigationDestination(
            icon: 'magnifyingglass.circle.fill',
            label: 'Explore',
          ),
          AdaptiveNavigationDestination(icon: 'heart.fill', label: 'Wishlist'),
          AdaptiveNavigationDestination(
            icon: 'person.circle.fill',
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  static final List<_NavItem> _navItems = [
    _NavItem(icon: AppIcons.home, label: 'Home'),
    _NavItem(icon: AppIcons.explore, label: 'Explore'),
    _NavItem(icon: AppIcons.wishlist, label: 'Wishlist'),
    _NavItem(icon: AppIcons.profile, label: 'Profile'),
  ];

  Widget _buildAndroid() {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        height: 72,
        indicatorColor: AppColors.primary.withValues(alpha: 0.1),
        selectedIndex: _currentIndex,
        onDestinationSelected: _goToTab,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? AppColors.primary : AppColors.gray,
          );
        }),

        destinations: List.generate(_navItems.length, (index) {
          final item = _navItems[index];
          return NavigationDestination(
            icon: Icon(item.icon, color: AppColors.primary),
            label: item.label,
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}

class MainNavigationScope extends InheritedWidget {
  const MainNavigationScope({
    super.key,
    required super.child,
    required this.goToTab,
    required this.currentIndex,
  });

  final void Function(int index) goToTab;
  final int currentIndex;

  static MainNavigationScope of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<MainNavigationScope>();
    assert(scope != null, 'MainNavigationScope not found in widget tree');
    return scope!;
  }

  @override
  bool updateShouldNotify(MainNavigationScope oldWidget) =>
      oldWidget.currentIndex != currentIndex;
}
