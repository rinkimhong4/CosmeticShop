import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:cosmetic_shop/core/data/app_data.dart';
import 'package:cosmetic_shop/core/theme/app_theme.dart';
import 'package:cosmetic_shop/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    setState(() => _orders.remove(order));

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('${order.productName} removed'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() => _orders.insert(removedIndex, order));
            },
          ),
        ),
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
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(useNativeToolbar: true, title: 'Orders'),

      body: _orders.isEmpty
          ? _EmptyState(onRefresh: _refresh)
          : Padding(
              padding: const EdgeInsets.only(top: 120.0),
              child: SlidableAutoCloseBehavior(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
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
                        onTap: () {
                          // navigate to order detail
                        },
                        onArchive: () => _archiveOrder(order),
                        onDelete: () => _removeOrder(order),
                        controller: _slidableController,
                      );
                    },
                  ),
                ),
              ),
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

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  int _quantity = 0;
  Widget _buildQuantitySelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _qtyButton(Icons.remove, () {
            if (_quantity > 1) setState(() => _quantity--);
          }),
          SizedBox(
            width: 32,
            child: Text(
              '$_quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          _qtyButton(Icons.add, () => setState(() => _quantity++)),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Image.network(
                      widget.order.imageUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.order.brand,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),

                            // _StatusPill(
                            //   color: widget.statusColor,
                            //   icon: widget.statusIcon,
                            //   label: widget.order.status.label,
                            // ),
                            _buildQuantitySelector(),
                          ],
                        ),
                        const SizedBox(height: 4),
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
                        if (widget.order.variant != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            widget.order.variant!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              widget.currency.format(widget.order.total),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              widget.date.format(widget.order.orderDate),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
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
