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
