import 'dart:io';

import 'package:cosmetic_shop/core/constants/app_icons.dart';
import 'package:cosmetic_shop/core/theme/app_theme.dart';
import 'package:cosmetic_shop/features/main_navigation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  HomeHeaderDelegate({required this.topPadding});

  final double topPadding;

  static const double _expandedContent = 150;
  static const double _collapsedContent = 79;

  @override
  double get minExtent => _collapsedContent + topPadding;

  @override
  double get maxExtent => _expandedContent + topPadding;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final range = maxExtent - minExtent;
    final t = (shrinkOffset / range).clamp(0.0, 1.0);

    final expandedOpacity = (1 - t * 1.6).clamp(0.0, 1.0);
    final collapsedOpacity = ((t - 0.55) / 0.45).clamp(0.0, 1.0);
    final radius = (28 * (1 - t)).clamp(0.0, 28.0);

    return Material(
      color: AppColors.primary,
      elevation: t > 0.95 ? 2 : 0,
      shadowColor: Colors.black26,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(radius)),
        child: Stack(
          children: [
            Positioned(
              top: topPadding,
              left: 0,
              right: 0,
              child: IgnorePointer(
                ignoring: t > 0.5,
                child: Opacity(
                  opacity: expandedOpacity,
                  child: _ExpandedHeader(
                    onCartTap: () {},
                    onNotificationTap: () {},
                    onSearchTap: () {
                      MainNavigationScope.of(context).goToTab(MainTab.explore);
                    },
                    onScanTap: () {},
                    onFilterTap: () {},
                  ),
                ),
              ),
            ),
            Positioned(
              top: topPadding,
              left: 0,
              right: 0,
              height: _collapsedContent,
              child: IgnorePointer(
                ignoring: t < 0.5,
                child: Opacity(
                  opacity: collapsedOpacity,
                  child: _CollapsedHeader(
                    onSearchTap: () {
                      MainNavigationScope.of(context).goToTab(MainTab.explore);
                    },

                    onScanTap: () {},
                    onNotificationTap: () {},
                    hasNotification: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(HomeHeaderDelegate oldDelegate) =>
      oldDelegate.topPadding != topPadding;
}

class _NativePressable extends StatefulWidget {
  const _NativePressable({
    required this.child,
    required this.onTap,
    this.borderRadius = 12,
    this.haptic = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double borderRadius;
  final bool haptic;

  @override
  State<_NativePressable> createState() => _NativePressableState();
}

class _NativePressableState extends State<_NativePressable> {
  bool _pressed = false;

  void _handleTap() {
    if (widget.haptic) HapticFeedback.lightImpact();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap == null ? null : _handleTap,
          splashColor: Colors.white.withValues(alpha: 0.15),
          highlightColor: Colors.white.withValues(alpha: 0.08),
          child: widget.child,
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap == null ? null : _handleTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 120),
        opacity: _pressed ? 0.55 : 1.0,
        child: widget.child,
      ),
    );
  }
}

class _ExpandedHeader extends StatelessWidget {
  const _ExpandedHeader({
    required this.onCartTap,
    required this.onNotificationTap,
    required this.onSearchTap,
    required this.onScanTap,
    required this.onFilterTap,
    this.location = 'New York, USA',
    this.hasNotification = true,
  });

  final String location;
  final bool hasNotification;
  final VoidCallback onCartTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onSearchTap;
  final VoidCallback onScanTap;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _LocationBlock(location: location, onTap: () {}),
              ),
              _IconButtonBox(icon: AppIcons.cart, onTap: onCartTap),
              const SizedBox(width: 12),
              _IconButtonBox(
                icon: AppIcons.notification,
                showDot: hasNotification,
                onTap: onNotificationTap,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _SearchField(onTap: onSearchTap, onScanTap: onScanTap),
              ),
              const SizedBox(width: 12),
              _IconButtonBox(
                icon: AppIcons.filter,
                size: 52,
                bordered: true,
                onTap: onFilterTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CollapsedHeader extends StatelessWidget {
  const _CollapsedHeader({
    this.onSearchTap,
    this.onScanTap,
    this.onNotificationTap,
    this.hasNotification = false,
  });

  final VoidCallback? onSearchTap;
  final VoidCallback? onScanTap;
  final VoidCallback? onNotificationTap;
  final bool hasNotification;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: _SearchField(onTap: onSearchTap, onScanTap: onScanTap),
          ),
          const SizedBox(width: 12),
          _IconButtonBox(
            icon: AppIcons.notification,
            showDot: hasNotification,
            onTap: onNotificationTap,
            size: 52,
            bordered: true,
          ),
        ],
      ),
    );
  }
}

class _LocationBlock extends StatelessWidget {
  const _LocationBlock({required this.location, this.onTap});

  final String location;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final pinIcon = Platform.isIOS
        ? CupertinoIcons.location_solid
        : Icons.location_on;
    final chevron = Platform.isIOS
        ? CupertinoIcons.chevron_down
        : Icons.keyboard_arrow_down;

    return _NativePressable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(pinIcon, color: const Color(0xFFD4A574), size: 18),
                const SizedBox(width: 6),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(chevron, color: Colors.white, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IconButtonBox extends StatelessWidget {
  const _IconButtonBox({
    required this.icon,
    this.onTap,
    this.showDot = false,
    this.size = 44,
    this.bordered = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool showDot;
  final double size;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _NativePressable(
          onTap: onTap,
          borderRadius: 12,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: bordered
                  ? Colors.transparent
                  : Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: bordered
                  ? Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
        if (showDot)
          Positioned(
            top: 8,
            right: 8,
            child: IgnorePointer(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({this.onTap, this.onScanTap});

  final VoidCallback? onTap;
  final VoidCallback? onScanTap;

  @override
  Widget build(BuildContext context) {
    final isIOS = Platform.isIOS;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: isIOS ? _buildIOS() : _buildAndroid(),
    );
  }

  Widget _buildIOS() {
    return Stack(
      children: [
        AbsorbPointer(
          child: CupertinoSearchTextField(
            placeholder: 'Search',
            padding: EdgeInsetsGeometry.symmetric(vertical: 16),
            backgroundColor: Colors.white,
            suffixIcon: Icon(AppIcons.scan, size: 0),
            suffixMode: OverlayVisibilityMode.never,
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _NativePressable(
                onTap: onScanTap,
                borderRadius: 8,
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    CupertinoIcons.qrcode_viewfinder,
                    color: CupertinoColors.secondaryLabel,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAndroid() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(AppIcons.search, color: AppColors.gray, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Search',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.gray,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          _NativePressable(
            onTap: onScanTap,
            borderRadius: 8,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(AppIcons.scan, color: AppColors.gray, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
