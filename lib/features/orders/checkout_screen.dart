import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:cosmetic_shop/features/orders/shipping_address.dart';
import 'package:cosmetic_shop/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(title: 'Checkout'),
      body: ListView(
        padding: const EdgeInsets.only(top: 120),
        children: [Text("data")],
      ),
    );
  }
}
