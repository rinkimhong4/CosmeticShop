import 'dart:ui';

import 'package:flutter/cupertino.dart';

class BannerItem {
  final String contentTitle1;
  final String contentTitle2;
  final String? contentTitle3;
  final String discountPercentage;
  final String buttonTitle;
  final String imageUrl;
  final VoidCallback onTapBtn;

  const BannerItem({
    required this.contentTitle1,
    required this.contentTitle2,
    this.contentTitle3,
    required this.discountPercentage,
    required this.buttonTitle,
    required this.imageUrl,
    required this.onTapBtn,
  });
}

class CategoryItem {
  final IconData icon;
  final String? label;
  final VoidCallback? onTap;

  const CategoryItem({required this.icon, this.label, this.onTap});
}

// lib/models/product_item.dart
class ProductItem {
  final String id;
  final String name;
  final double price;
  final String category;
  final String description;
  final double rating;
  final int reviewCount;
  final List<String> imageUrl;
  final bool isFavorite;
  final double? originalPrice; // null = no discount

  const ProductItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    required this.rating,
    this.reviewCount = 0,
    required this.imageUrl,
    this.isFavorite = false,
    this.originalPrice,
  });

  bool get isOnSale => originalPrice != null && originalPrice! > price;

  int get discountPercent {
    if (!isOnSale) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  ProductItem copyWith({
    String? id,
    String? name,
    double? price,
    String? category,
    String? description,
    double? rating,
    int? reviewCount,
    String? imageUrl,
    bool? isFavorite,
    double? originalPrice,
  }) {
    return ProductItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      imageUrl: imageUrl != null ? [imageUrl] : this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      originalPrice: originalPrice ?? this.originalPrice,
    );
  }
}

// Reviews

class Review {
  final String name;
  final String avatar;
  final String timeAgo;
  final double rating;
  final String comment;
  final bool verified;

  const Review({
    required this.name,
    required this.avatar,
    required this.timeAgo,
    required this.rating,
    required this.comment,
    required this.verified,
  });
}

// order

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled;

  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

@immutable
class OrderItem {
  const OrderItem({
    required this.id,
    required this.productName,
    required this.brand,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.orderDate,
    required this.status,
    this.variant,
  });

  final String id;
  final String productName;
  final String brand;
  final String imageUrl;
  final double price;
  final int quantity;
  final DateTime orderDate;
  final OrderStatus status;
  final String? variant;

  double get total => price * quantity;

  OrderItem copyWith({
    String? id,
    String? productName,
    String? brand,
    String? imageUrl,
    double? price,
    int? quantity,
    DateTime? orderDate,
    OrderStatus? status,
    String? variant,
  }) {
    return OrderItem(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      brand: brand ?? this.brand,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      variant: variant ?? this.variant,
    );
  }
}

// shipping

class ShippingOption {
  const ShippingOption({
    required this.id,
    required this.name,
    required this.price,
    required this.arrival,
    required this.icon,
  });

  final String id;
  final String name;
  final double price;
  final DateTime arrival;
  final IconData icon;
}

@immutable
class ShippingAddress {
  const ShippingAddress({
    required this.id,
    required this.label,
    required this.address,
  });

  final String id;
  final String label;
  final String address;
}
