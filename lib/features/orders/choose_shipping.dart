import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:cosmetic_shop/core/data/app_data.dart';
import 'package:cosmetic_shop/core/theme/app_theme.dart';
import 'package:cosmetic_shop/widgets/choose_shipping_card.dart';
import 'package:cosmetic_shop/features/orders/shipping_address.dart';
import 'package:cosmetic_shop/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChooseShippingScreen extends StatefulWidget {
  const ChooseShippingScreen({super.key, this.initialSelectedId});

  final String? initialSelectedId;

  @override
  State<ChooseShippingScreen> createState() => _ChooseShippingScreenState();
}

class _ChooseShippingScreenState extends State<ChooseShippingScreen> {
  late String? _selectedId = widget.initialSelectedId;
  final _currency = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
  final _date = DateFormat('EEE, MMM d');

  ShippingOption? get _selectedOption {
    if (_selectedId == null) return null;
    return AppData.shippingOptions.firstWhereOrNull((o) => o.id == _selectedId);
  }

  Future<void> _continue() async {
    final option = _selectedOption;
    if (option == null) {
      Get.snackbar(
        'No option selected',
        'Please choose a shipping method first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final address = await Get.to<ShippingAddress>(
      () => const ShippingAddressScreen(),
    );

    if (address == null) return;
    if (!mounted) return;

    Navigator.of(
      context,
    ).pop(ShippingSelection(option: option, address: address));
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = _selectedId != null;

    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(
        useNativeToolbar: true,
        title: 'Choose Shipping',
      ),
      body: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 120, left: 16, right: 16),
        itemCount: AppData.shippingOptions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final option = AppData.shippingOptions[index];
          return ChooseShippingCard(
            option: option,
            selected: _selectedId == option.id,
            currency: _currency,
            date: _date,
            onTap: () => setState(() => _selectedId = option.id),
          );
        },
      ),
      floatingActionButton: AdaptiveFloatingActionButton(
        onPressed: hasSelection ? _continue : null,
        backgroundColor: hasSelection
            ? AppColors.primary
            : AppColors.gray.withValues(alpha: 0.4),
        foregroundColor: AppColors.white,
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}

class ShippingSelection {
  const ShippingSelection({required this.option, required this.address});

  final ShippingOption option;
  final ShippingAddress address;
}
