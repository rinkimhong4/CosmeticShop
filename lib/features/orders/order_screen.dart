import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmetic_shop/core/data/app_data.dart';
import 'package:cosmetic_shop/core/theme/app_theme.dart';
import 'package:cosmetic_shop/features/orders/choose_shipping.dart';
import 'package:cosmetic_shop/features/orders/order_summary_bar.dart';
import 'package:cosmetic_shop/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late final List<OrderItem> _orders = [...AppData.mockOrders];
  late final _slidableController = SlidableController(this);
  bool _promoApplied = false;

  final _currency = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
  final _date = DateFormat('MMM d, h:mm a');

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFF59E0B);
      case OrderStatus.processing:
        return const Color(0xFF3B82F6);
      case OrderStatus.shipped:
        return const Color(0xFF8B5CF6);
      case OrderStatus.delivered:
        return const Color(0xFF10B981);
      case OrderStatus.cancelled:
        return const Color(0xFFEF4444);
    }
  }

  IconData _statusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return CupertinoIcons.clock;
      case OrderStatus.processing:
        return CupertinoIcons.gear_alt;
      case OrderStatus.shipped:
        return CupertinoIcons.cube_box;
      case OrderStatus.delivered:
        return CupertinoIcons.checkmark_seal_fill;
      case OrderStatus.cancelled:
        return CupertinoIcons.xmark_circle_fill;
    }
  }

  void _removeOrder(OrderItem order) {
    final removedIndex = _orders.indexOf(order);

    AdaptiveAlertDialog.show(
      context: context,
      title: order.productName,
      message: 'Are you sure?',
      actions: [
        AlertAction(
          title: 'Cancel',
          style: AlertActionStyle.cancel,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        AlertAction(
          title: 'Confirm',
          style: AlertActionStyle.primary,
          onPressed: () {
            setState(() => _orders.removeAt(removedIndex));
          },
        ),
      ],
    );
  }

  void _archiveOrder(OrderItem order) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('${order.productName} archived'),
        ),
      );
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      _orders
        ..clear()
        ..addAll(AppData.mockOrders);
    });
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = _orders.fold<double>(0, (sum, o) => sum + o.total);
    const delivery = 10.0;
    final tax = subtotal * 0.12;
    final discount = _promoApplied ? 20.0 : 0.0;

    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(title: 'Orders'),
      body: Column(
        children: [
          Expanded(
            child: _orders.isEmpty
                ? _EmptyState(onRefresh: _refresh)
                : SlidableAutoCloseBehavior(
                    child: RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(top: 120),
                        itemCount: _orders.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final order = _orders[index];
                          return _OrderCard(
                            key: ValueKey(order.id),
                            order: order,
                            currency: _currency,
                            date: _date,
                            statusColor: _statusColor(order.status),
                            statusIcon: _statusIcon(order.status),
                            onTap: () {},
                            onArchive: () => _archiveOrder(order),
                            onDelete: () => _removeOrder(order),
                            controller: _slidableController,
                          );
                        },
                      ),
                    ),
                  ),
          ),
          if (_orders.isNotEmpty)
            OrderSummaryBar(
              subtotal: subtotal,
              deliveryCharge: delivery,
              tax: tax,
              discount: discount,
              onApplyPromo: (code) {
                if (code.isEmpty) return;
                setState(() => _promoApplied = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text('Promo "$code" applied'),
                  ),
                );
              },
              onCheckout: () {
                // navigate to checkout
                // Navigator.push(context, )
                Get.to(() => ChooseShippingScreen());
              },
            ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatefulWidget {
  const _OrderCard({
    super.key,
    required this.order,
    required this.currency,
    required this.date,
    required this.statusColor,
    required this.statusIcon,
    required this.onTap,
    required this.onArchive,
    required this.onDelete,
    required this.controller,
    this.onQuantityChanged,
  });

  final OrderItem order;
  final NumberFormat currency;
  final DateFormat date;
  final Color statusColor;
  final IconData statusIcon;
  final VoidCallback onTap;
  final VoidCallback onArchive;
  final VoidCallback onDelete;
  final SlidableController controller;
  final ValueChanged<int>? onQuantityChanged;

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  late int _quantity = widget.order.quantity;

  void _setQuantity(int value) {
    if (value < 1) return;
    setState(() => _quantity = value);
    widget.onQuantityChanged?.call(value);
  }

  Widget _buildQuantitySelector() {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _qtyButton(
            CupertinoIcons.minus,
            _quantity > 1 ? () => _setQuantity(_quantity - 1) : null,
          ),
          SizedBox(
            width: 28,
            child: Text(
              '$_quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          _qtyButton(CupertinoIcons.plus, () => _setQuantity(_quantity + 1)),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback? onTap) {
    final disabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Icon(
          icon,
          size: 14,
          color: disabled
              ? AppColors.gray.withValues(alpha: 0.4)
              : AppColors.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lineTotal = widget.order.price * _quantity;

    return Slidable(
      key: ValueKey(widget.order.id),
      groupTag: 'orders',
      closeOnScroll: true,
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.5,
        dismissible: DismissiblePane(
          onDismissed: widget.onDelete,
          closeOnCancel: true,
        ),
        children: [
          _SlideAction(
            icon: CupertinoIcons.archivebox_fill,
            label: 'Archive',
            background: const Color(0xFF6B7280),
            onPressed: widget.onArchive,
            isFirst: true,
          ),
          _SlideAction(
            icon: CupertinoIcons.trash_fill,
            label: 'Delete',
            background: const Color(0xFFEF4444),
            onPressed: widget.onDelete,
            isLast: true,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: widget.order.imageUrl,
                      width: 74,
                      height: 74,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        width: 72,
                        height: 72,
                        color: Colors.grey.shade200,
                      ),
                      errorWidget: (_, __, ___) => Container(
                        width: 72,
                        height: 72,
                        color: Colors.grey.shade200,
                        child: Icon(
                          CupertinoIcons.photo,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Middle content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top row: brand + status pill
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.order.brand.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade500,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                            _StatusPill(
                              color: widget.statusColor,
                              icon: widget.statusIcon,
                              label: widget.order.status.label,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Product name
                        Text(
                          widget.order.productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                          ),
                        ),
                        // if (widget.order.variant != null) ...[
                        //   const SizedBox(height: 2),
                        //   Text(
                        //     widget.order.variant!,
                        //     style: TextStyle(
                        //       fontSize: 12,
                        //       color: Colors.grey.shade600,
                        //     ),
                        //   ),
                        // ],
                        const SizedBox(height: 4),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.currency.format(lineTotal),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildQuantitySelector(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.color,
    required this.icon,
    required this.label,
  });

  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideAction extends StatelessWidget {
  const _SlideAction({
    required this.icon,
    required this.label,
    required this.background,
    required this.onPressed,
    this.isFirst = false,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final Color background;
  final VoidCallback onPressed;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.horizontal(
      left: isFirst ? const Radius.circular(16) : Radius.zero,
      right: isLast ? const Radius.circular(16) : Radius.zero,
    );

    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: isFirst ? 0 : 6),
        child: Material(
          color: background,
          borderRadius: radius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 22),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Icon(CupertinoIcons.bag, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'No orders yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              'Pull down to refresh',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }
}
