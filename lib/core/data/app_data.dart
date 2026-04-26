import 'package:cosmetic_shop/features/reviews/review_screen.dart';
import 'package:cosmetic_shop/models/models.dart';
import 'package:flutter/material.dart';

class AppData {
  AppData._();

  static final reviews = const [
    Review(
      name: 'Dale Thiel',
      avatar: 'https://i.pravatar.cc/100?img=12',
      timeAgo: '11 months ago',
      rating: 5.0,
      comment:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt',
      verified: true,
    ),
    Review(
      name: 'Tiffany Nitzsche',
      avatar: 'https://i.pravatar.cc/100?img=47',
      timeAgo: '11 months ago',
      rating: 5.0,
      comment:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt',
      verified: true,
    ),
    Review(
      name: 'Marcus Johnson',
      avatar: 'https://i.pravatar.cc/100?img=33',
      timeAgo: '10 months ago',
      rating: 4.0,
      comment:
          'Great product, exactly as described. Shipping was fast and packaging was secure.',
      verified: true,
    ),
  ];

  static final banners = [
    BannerItem(
      contentTitle1: 'Beauty Sale',
      contentTitle2: 'Skin Care',
      discountPercentage: '50',
      buttonTitle: 'Shop Now',
      imageUrl:
          'https://static.vecteezy.com/system/resources/thumbnails/066/665/709/small/elegant-beauty-portrait-with-soft-makeup-and-confident-expression-png.png',
      onTapBtn: () {},
    ),
    BannerItem(
      contentTitle1: 'Mega Deal',
      contentTitle2: 'Lipsticks',
      discountPercentage: '30',
      buttonTitle: 'Grab It',
      imageUrl:
          'https://img.freepik.com/free-photo/portrait-beautiful-stylish-young-woman-with-colorful-flowers-head_158538-3920.jpg',
      onTapBtn: () {
        print("banner 2");
      },
    ),
    BannerItem(
      contentTitle1: 'Limited Time',
      contentTitle2: 'Fragrances',
      discountPercentage: '40',
      buttonTitle: 'Explore',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTl83DVbUTJWfHyNwv0yHaa19IB0t2rOgQnyA&s',
      onTapBtn: () {},
    ),
  ];

  //
  static final List<CategoryItem> categories = [
    CategoryItem(icon: Icons.beach_access_outlined, label: 'Sun'),
    CategoryItem(icon: Icons.spa_outlined, label: 'Spa'),
    CategoryItem(icon: Icons.face_outlined, label: 'Face'),
    CategoryItem(icon: Icons.brush_outlined, label: 'Makeup'),
    CategoryItem(icon: Icons.water_drop_outlined, label: 'Skin Care'),
    CategoryItem(icon: Icons.local_florist_outlined, label: 'Fragrance'),
    CategoryItem(icon: Icons.healing_outlined, label: 'Body Care'),
    CategoryItem(icon: Icons.cut_outlined, label: 'Hair'),
  ];
  // product

  static final List<ProductItem> products = [
    ProductItem(
      id: 'p1',
      name: 'Hydrating Face Serum',
      price: 24.99,
      originalPrice: 39.99,
      category: 'Skin Care',
      description: 'Lightweight hydrating serum with hyaluronic acid.',
      rating: 4.5,
      reviewCount: 128,
      imageUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdHrS6nMtjRFpAtfdGEN1EiGPFVC5UtEUOTQ&s',
        'https://natlawreview.com/sites/default/files/2024-03/Makeup%20cosmetics%20.jpg',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSbSAECpr1YJMCMXfACTKZMU3zQJ9yIW90JcA&s',
      ],
      isFavorite: true,
    ),
    ProductItem(
      id: 'p2',
      name: 'Matte Lipstick',
      price: 18.50,
      category: 'Makeup',
      description: 'Long-lasting matte finish.',
      rating: 4.2,
      reviewCount: 87,
      imageUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTl83DVbUTJWfHyNwv0yHaa19IB0t2rOgQnyA&s',
      ],
    ),
    ProductItem(
      id: 'p3',
      name: 'Vitamin C Brightening Cream',
      price: 32.00,
      originalPrice: 45.00,
      category: 'Skin Care',
      description: 'Brightens and evens skin tone.',
      rating: 4.7,
      reviewCount: 215,
      imageUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTl83DVbUTJWfHyNwv0yHaa19IB0t2rOgQnyA&s',
      ],
    ),
    ProductItem(
      id: 'p4',
      name: 'Rose Body Mist',
      price: 14.99,
      category: 'Fragrance',
      description: 'Light floral scent for everyday wear.',
      rating: 4.0,
      reviewCount: 56,
      imageUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTl83DVbUTJWfHyNwv0yHaa19IB0t2rOgQnyA&s',
      ],
    ),
  ];
  // orders

  static final List<OrderItem> mockOrders = [
    OrderItem(
      id: 'ORD-1001',
      productName: 'Hydrating Rose Serum',
      brand: 'Glow Lab',
      imageUrl:
          'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400',
      price: 32.50,
      quantity: 1,
      orderDate: DateTime.now().subtract(const Duration(hours: 3)),
      status: OrderStatus.processing,
      variant: '30ml',
    ),
    OrderItem(
      id: 'ORD-1002',
      productName: 'Matte Liquid Lipstick',
      brand: 'Velvet & Co.',
      imageUrl:
          'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=400',
      price: 18.00,
      quantity: 2,
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
      status: OrderStatus.shipped,
      variant: 'Ruby Red',
    ),
    OrderItem(
      id: 'ORD-1003',
      productName: 'Vitamin C Brightening Cream',
      brand: 'PureSkin',
      imageUrl:
          'https://images.unsplash.com/photo-1570194065650-d99fb4bedf0a?w=400',
      price: 45.99,
      quantity: 1,
      orderDate: DateTime.now().subtract(const Duration(days: 2)),
      status: OrderStatus.delivered,
      variant: '50ml',
    ),
    OrderItem(
      id: 'ORD-1004',
      productName: 'Sakura Body Lotion',
      brand: 'Bloom',
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=400',
      price: 24.00,
      quantity: 1,
      orderDate: DateTime.now().subtract(const Duration(days: 3)),
      status: OrderStatus.delivered,
    ),
    OrderItem(
      id: 'ORD-1005',
      productName: 'Charcoal Cleansing Foam',
      brand: 'Pure Detox',
      imageUrl:
          'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=400',
      price: 16.50,
      quantity: 3,
      orderDate: DateTime.now().subtract(const Duration(days: 5)),
      status: OrderStatus.delivered,
      variant: '150ml',
    ),
    OrderItem(
      id: 'ORD-1006',
      productName: 'Silk Eye Shadow Palette',
      brand: 'Velvet & Co.',
      imageUrl:
          'https://images.unsplash.com/photo-1583241800698-9c2e0b3c0f08?w=400',
      price: 52.00,
      quantity: 1,
      orderDate: DateTime.now().subtract(const Duration(days: 7)),
      status: OrderStatus.cancelled,
      variant: 'Sunset',
    ),
    OrderItem(
      id: 'ORD-1007',
      productName: 'Argan Hair Oil',
      brand: 'Glow Lab',
      imageUrl:
          'https://images.unsplash.com/photo-1599751449128-eb7249c3d6b1?w=400',
      price: 28.00,
      quantity: 1,
      orderDate: DateTime.now().subtract(const Duration(minutes: 45)),
      status: OrderStatus.pending,
      variant: '100ml',
    ),
    OrderItem(
      id: 'ORD-1008',
      productName: 'SPF 50 Sunscreen Gel',
      brand: 'PureSkin',
      imageUrl:
          'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=400',
      price: 22.00,
      quantity: 2,
      orderDate: DateTime.now().subtract(const Duration(days: 4)),
      status: OrderStatus.shipped,
    ),
    OrderItem(
      id: 'ORD-1009',
      productName: 'Retinol Night Cream',
      brand: 'Glow Lab',
      imageUrl:
          'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400',
      price: 64.00,
      quantity: 1,
      orderDate: DateTime.now().subtract(const Duration(days: 10)),
      status: OrderStatus.delivered,
      variant: '30ml',
    ),
    OrderItem(
      id: 'ORD-1010',
      productName: 'Lavender Bath Salts',
      brand: 'Bloom',
      imageUrl:
          'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=400',
      price: 14.50,
      quantity: 2,
      orderDate: DateTime.now().subtract(const Duration(hours: 8)),
      status: OrderStatus.processing,
      variant: '500g',
    ),
  ];
}
