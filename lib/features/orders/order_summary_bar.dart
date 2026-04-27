import 'package:cosmetic_shop/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderSummaryBar extends StatefulWidget {
  const OrderSummaryBar({
    super.key,
    required this.subtotal,
    required this.deliveryCharge,
    required this.tax,
    required this.discount,
    required this.onCheckout,
    required this.onApplyPromo,
  });

  final double subtotal;
  final double deliveryCharge;
  final double tax;
  final double discount;
  final VoidCallback onCheckout;
  final ValueChanged<String> onApplyPromo;

  @override
  State<OrderSummaryBar> createState() => _OrderSummaryBarState();
}

class _OrderSummaryBarState extends State<OrderSummaryBar> {
  final _promoController = TextEditingController();
  final _currency = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  double get _total =>
      widget.subtotal + widget.deliveryCharge + widget.tax - widget.discount;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: 12,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Promo code row
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(28),
                ),
                padding: const EdgeInsets.fromLTRB(20, 4, 4, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _promoController,
                        decoration: const InputDecoration(
                          hintText: 'Promo Code',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Material(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(24),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () =>
                            widget.onApplyPromo(_promoController.text.trim()),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: Text(
                            'Apply',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Line items
              _SummaryRow(
                label: 'Sub-Total',
                value: _currency.format(widget.subtotal),
              ),
              const SizedBox(height: 8),
              _SummaryRow(
                label: 'Delivery Charge',
                value: _currency.format(widget.deliveryCharge),
              ),
              const SizedBox(height: 8),
              _SummaryRow(label: 'Tax', value: _currency.format(widget.tax)),
              if (widget.discount > 0) ...[
                const SizedBox(height: 8),
                _SummaryRow(
                  label: 'Discount',
                  value: '-${_currency.format(widget.discount)}',
                ),
              ],
              const SizedBox(height: 12),

              // Dashed divider
              const _DashedDivider(),
              const SizedBox(height: 12),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Cost',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _currency.format(_total),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Checkout button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Material(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(32),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: widget.onCheckout,
                    child: const Center(
                      child: Text(
                        'Proceed to Checkout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13.5,
            color: Color(0xFF9CA3AF),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 4.0;
        const dashSpace = 4.0;
        final dashCount = (constraints.maxWidth / (dashWidth + dashSpace))
            .floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            dashCount,
            (_) => Container(
              width: dashWidth,
              height: 1,
              color: const Color(0xFFD1D5DB),
            ),
          ),
        );
      },
    );
  }
}
