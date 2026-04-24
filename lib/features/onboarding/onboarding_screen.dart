import 'package:cosmetic_shop/core/theme/app_theme.dart';
import 'package:cosmetic_shop/core/utils/wide_scoop_clipper.dart';
import 'package:cosmetic_shop/core/widgets/app_circle_button.dart';
import 'package:cosmetic_shop/core/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────────────────────────────────────

class OnboardingItem {
  final String image;
  final String titleStart;
  final String titleHighlight;
  final String titleEnd;
  final String description;

  const OnboardingItem({
    required this.image,
    required this.titleStart,
    required this.titleHighlight,
    required this.titleEnd,
    required this.description,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.onFinish});

  final VoidCallback? onFinish;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _items = <OnboardingItem>[
    OnboardingItem(
      image: 'assets/images/test.png',
      titleStart: 'Discover ',
      titleHighlight: 'Beauty and Cosmetic',
      titleEnd: ' Products',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt',
    ),
    OnboardingItem(
      image: 'assets/images/test.png',
      titleStart: 'Shop with ',
      titleHighlight: 'Ease and Style',
      titleEnd: ' Anywhere',
      description:
          'Browse, favorite, and purchase your essentials in just a few taps from the comfort of home.',
    ),
    OnboardingItem(
      image: 'assets/images/test.png',
      titleStart: 'Fast ',
      titleHighlight: 'Doorstep Delivery',
      titleEnd: ' Today',
      description:
          'Get your beauty products delivered straight to your door, fresh and on time.',
    ),
  ];

  late final PageController _pageController;
  int _currentIndex = 0;

  bool get _isFirst => _currentIndex == 0;
  bool get _isLast => _currentIndex == _items.length - 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _animateTo(int page) async {
    HapticFeedback.lightImpact();
    await _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeOutCubic,
    );
  }

  void _onNext() => _isLast ? _finish() : _animateTo(_currentIndex + 1);
  void _onPrevious() {
    if (!_isFirst) _animateTo(_currentIndex - 1);
  }

  void _finish() {
    HapticFeedback.mediumImpact();
    widget.onFinish?.call();
    // Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _SkipButton(visible: !_isLast, onPressed: _finish),
            Expanded(
              flex: 5,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (i) {
                  HapticFeedback.selectionClick();
                  setState(() => _currentIndex = i);
                },
                itemBuilder: (_, index) => _ParallaxImage(
                  image: _items[index].image,
                  controller: _pageController,
                  index: index,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: _BottomPanel(
                item: _items[_currentIndex],
                currentIndex: _currentIndex,
                itemCount: _items.length,
                isFirst: _isFirst,
                isLast: _isLast,
                onNext: _onNext,
                onPrevious: _onPrevious,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Skip button (fades out on last page)
// ─────────────────────────────────────────────────────────────────────────────

class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.visible, required this.onPressed});

  final bool visible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Align(
        alignment: Alignment.topRight,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: visible ? 1 : 0,
          child: IgnorePointer(
            ignoring: !visible,
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8),
              child: TextButton(
                onPressed: onPressed,
                child: const Text(
                  'Skip',
                  style: TextStyle(color: AppColors.gray, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Image area with parallax + scale + fade as user swipes
// ─────────────────────────────────────────────────────────────────────────────

class _ParallaxImage extends StatelessWidget {
  const _ParallaxImage({
    required this.image,
    required this.controller,
    required this.index,
  });

  final String image;
  final PageController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        var page = index.toDouble();
        if (controller.hasClients && controller.position.hasContentDimensions) {
          page = controller.page ?? page;
        }
        final delta = page - index; // -1 .. 1
        final absDelta = delta.abs().clamp(0.0, 1.0);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Center(
            child: Transform.translate(
              offset: Offset(-delta * 60, absDelta * 16),
              child: Transform.scale(
                scale: 1 - absDelta * 0.18,
                child: Opacity(
                  opacity: (1 - absDelta * 0.7).clamp(0.0, 1.0),
                  child: Image.asset(image, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Static white scoop panel hosting animated text + controls
// ─────────────────────────────────────────────────────────────────────────────

class _BottomPanel extends StatelessWidget {
  const _BottomPanel({
    required this.item,
    required this.currentIndex,
    required this.itemCount,
    required this.isFirst,
    required this.isLast,
    required this.onNext,
    required this.onPrevious,
  });

  final OnboardingItem item;
  final int currentIndex;
  final int itemCount;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WideScoopClipper(scoopDepth: 70, scoopWidth: 700),
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(32, 90, 32, 24),
        child: Column(
          children: [
            Expanded(
              child: _AnimatedTextBlock(indexKey: currentIndex, item: item),
            ),
            _OnboardingControls(
              currentIndex: currentIndex,
              itemCount: itemCount,
              isFirst: isFirst,
              isLast: isLast,
              onNext: onNext,
              onPrevious: onPrevious,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Title + description with staggered slide+fade on every page change
// ─────────────────────────────────────────────────────────────────────────────

class _AnimatedTextBlock extends StatefulWidget {
  const _AnimatedTextBlock({required this.indexKey, required this.item});

  final int indexKey;
  final OnboardingItem item;

  @override
  State<_AnimatedTextBlock> createState() => _AnimatedTextBlockState();
}

class _AnimatedTextBlockState extends State<_AnimatedTextBlock>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _descFade;
  late final Animation<Offset> _descSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _titleFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    _titleSlide = Tween(begin: const Offset(0, 0.35), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );
    _descFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 1.0, curve: Curves.easeOut),
    );
    _descSlide = Tween(begin: const Offset(0, 0.45), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(_AnimatedTextBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.indexKey != widget.indexKey) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeTransition(
          opacity: _titleFade,
          child: SlideTransition(
            position: _titleSlide,
            child: _OnboardingTitle(item: widget.item),
          ),
        ),
        const SizedBox(height: 20),
        FadeTransition(
          opacity: _descFade,
          child: SlideTransition(
            position: _descSlide,
            child: _OnboardingDescription(text: widget.item.description),
          ),
        ),
      ],
    );
  }
}

class _OnboardingTitle extends StatelessWidget {
  const _OnboardingTitle({required this.item});

  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.dark,
          height: 1.3,
        ),
        children: [
          TextSpan(text: item.titleStart),
          TextSpan(
            text: item.titleHighlight,
            style: const TextStyle(color: AppColors.secondary),
          ),
          TextSpan(text: item.titleEnd),
        ],
      ),
    );
  }
}

class _OnboardingDescription extends StatelessWidget {
  const _OnboardingDescription({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 15, color: AppColors.gray, height: 1.6),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom controls: back arrow • dots • morphing primary CTA
// ─────────────────────────────────────────────────────────────────────────────

class _OnboardingControls extends StatelessWidget {
  const _OnboardingControls({
    required this.currentIndex,
    required this.itemCount,
    required this.isFirst,
    required this.isLast,
    required this.onNext,
    required this.onPrevious,
  });

  final int currentIndex;
  final int itemCount;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: isFirst ? 0 : 1,
          child: IgnorePointer(
            ignoring: isFirst,
            child: AppCircleButton(
              icon: Icons.arrow_back_rounded,
              color: AppColors.primary,
              onTap: onPrevious,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: AnimatedSmoothIndicator(
              activeIndex: currentIndex,
              count: itemCount,
              effect: const ExpandingDotsEffect(
                activeDotColor: AppColors.primary,
                dotColor: AppColors.gray,
                dotHeight: 8,
                dotWidth: 8,
                expansionFactor: 3,
                spacing: 6,
              ),
            ),
          ),
        ),
        AppPrimaryButton(
          icon: Icons.arrow_forward_rounded,
          label: 'Get Started',
          expanded: isLast,
          backgroundColor: AppColors.primary,
          onTap: onNext,
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _PressScale(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 1.4),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
    );
  }
}

class _PrimaryCta extends StatelessWidget {
  const _PrimaryCta({required this.isLast, required this.onTap});

  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _PressScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        height: 56,
        width: isLast ? 168 : 56,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: isLast
              ? const Row(
                  key: ValueKey('cta'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                )
              : const Center(
                  key: ValueKey('arrow'),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
        ),
      ),
    );
  }
}

/// Lightweight tap-down scale feedback (iOS-style press response).
class _PressScale extends StatefulWidget {
  const _PressScale({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
