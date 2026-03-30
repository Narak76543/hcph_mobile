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

class LaptopSpecModel {
  final String id;
  final String modelId;
  final int? ramSlots;
  final String? ramType;
  final int? maxRamGg;
  final int? ramBaseGb;
  final int? ssdSlots;
  final String? ssdInterface;
  final String? ssdFromFactor;
  final bool? hasHddBay;
  final String? displaySize;
  final String? displayResolution;

  LaptopSpecModel({
    required this.id,
    required this.modelId,
    this.ramSlots,
    this.ramType,
    this.maxRamGg,
    this.ramBaseGb,
    this.ssdSlots,
    this.ssdInterface,
    this.ssdFromFactor,
    this.hasHddBay,
    this.displaySize,
    this.displayResolution,
  });

  // ── JSON → Dart (reading from API) ────────────────────────────────────────
  factory LaptopSpecModel.fromJson(Map<String, dynamic> json) {
    return LaptopSpecModel(
      id: json['id']?.toString() ?? '',
      modelId: json['model_id']?.toString() ?? '',
      ramSlots: json['ram_slots'] as int?,
      ramType: json['ram_type'] as String?,
      maxRamGg: json['max_ram_gg'] as int?,
      ramBaseGb: json['ram_base_gb'] as int?,
      ssdSlots: json['ssd_slots'] as int?,
      ssdInterface: json['ssd_interface'] as String?,
      ssdFromFactor: json['ssd_from_factor'] as String?,
      hasHddBay: json['has_hdd_bay'] as bool?,
      displaySize: json['display_size'] as String?,
      displayResolution: json['display_resolution'] as String?,
    );
  }

  // ── Dart → JSON (sending to API) ──────────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model_id': modelId,
      'ram_slots': ramSlots,
      'ram_type': ramType,
      'max_ram_gg': maxRamGg,
      'ram_base_gb': ramBaseGb,
      'ssd_slots': ssdSlots,
      'ssd_interface': ssdInterface,
      'ssd_from_factor': ssdFromFactor,
      'has_hdd_bay': hasHddBay,
      'display_size': displaySize,
      'display_resolution': displayResolution,
    };
  }

  // ── Parse a list from API response ────────────────────────────────────────
  static List<LaptopSpecModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => LaptopSpecModel.fromJson(json)).toList();
  }

  @override
  String toString() {
    return 'LaptopSpec(id: $id, modelId: $modelId, ramType: $ramType, '
        'maxRamGg: $maxRamGg, ssdSlots: $ssdSlots, display: $displaySize)';
  }
}
