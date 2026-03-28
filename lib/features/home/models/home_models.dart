import 'package:flutter/material.dart';

class UpgradeModel {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String discount;

  UpgradeModel({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.discount,
  });
}

class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final IconData icon;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
  });
}

class PostModel {
  final String partName;
  final String compatibleModel;
  final String shopName;
  final double price;
  final String imageUrl;
  final bool isVerified;

  PostModel({
    required this.partName,
    required this.compatibleModel,
    required this.shopName,
    required this.price,
    required this.imageUrl,
    this.isVerified = true,
  });
}

class BrandModel {
  final String id;
  final String name;
  final String slug;
  final String? imageUrl;

  BrandModel({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
  });
}
