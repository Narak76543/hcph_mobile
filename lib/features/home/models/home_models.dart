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
  final IconData? icon;
  final String? imageUrl;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.icon,
    this.imageUrl,
  });
}

class PostModel {
  final String id;
  final String partName;
  final String brand;
  final String model;
  final String compatibleModel;
  final String shopName;
  final String postedBy;
  final String ownerFullName;
  final String? ownerUserId;
  final double price;
  final String imageUrl;
  final String? categoryId;
  final String? categorySlug;
  final bool isVerified;
  final Map<String, dynamic> partSpecs; // ← NEW

  PostModel({
    required this.id,
    required this.partName,
    required this.brand,
    required this.model,
    required this.compatibleModel,
    required this.shopName,
    required this.postedBy,
    String? ownerFullName,
    this.ownerUserId,
    required this.price,
    required this.imageUrl,
    this.categoryId,
    this.categorySlug,
    this.isVerified = true,
    Map<String, dynamic>? partSpecs, // ← NEW
  }) : ownerFullName = ownerFullName ?? postedBy,
       partSpecs = partSpecs ?? {}; // ← NEW

  factory PostModel.fromJson(Map<String, dynamic> json) {
    // ====================================
    // ── Shop Name
    // ====================================
    String shop = 'Unknown Shop';
    final shopJson = json['shop'];
    if (shopJson is Map &&
        (shopJson['name'] != null || shopJson['shop_name'] != null)) {
      shop = (shopJson['name'] ?? shopJson['shop_name']).toString();
    } else if (json['owner'] is Map && json['owner']['shop_name'] != null) {
      shop = json['owner']['shop_name'].toString();
    } else if (json['seller'] is Map && json['seller']['shop_name'] != null) {
      shop = json['seller']['shop_name'].toString();
    } else if (json['shop_details'] is Map &&
        json['shop_details']['name'] != null) {
      shop = json['shop_details']['name'].toString();
    } else if (json['shop_name'] != null &&
        json['shop_name'].toString().isNotEmpty) {
      shop = json['shop_name'].toString();
    }
    //======================================= 
    //  Price
    //=======================================
    final dynamic priceRaw =
        json['price'] ??
        json['listing_price'] ??
        json['price_usd'] ??
        json['cost'] ??
        0.0;
    double priceVal = 0.0;
    if (priceRaw is num) {
      priceVal = priceRaw.toDouble();
    } else if (priceRaw is String) {
      priceVal =
          double.tryParse(priceRaw.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    }
    // =================================================
    // Part Info
    // =================================================
    final partMap = json['part'] as Map<String, dynamic>?;
    final brand =
        json['part_brand'] ?? partMap?['brand'] ?? json['brand'] ?? '';
    final model =
        json['part_model'] ??
        partMap?['model_name'] ??
        json['model_name'] ??
        json['name'] ??
        '';
    final partName =
        [brand, model]
            .where((s) => s != null && s.toString().isNotEmpty)
            .join(' ')
            .trim()
            .isNotEmpty
        ? [
            brand,
            model,
          ].whereType<String>().where((s) => s.isNotEmpty).join(' ')
        : (json['part_model'] ??
              partMap?['model_name'] ??
              json['model_name'] ??
              json['brand'] ??
              partMap?['brand'] ??
              json['name'] ??
              'Unknown Part');
    // =======================================================
    // Image
    // =======================================================
    String image = '';
    if (json['part_image'] != null &&
        json['part_image'].toString().isNotEmpty) {
      image = json['part_image'].toString();
    } else if (json['img_url'] != null &&
        json['img_url'].toString().isNotEmpty) {
      image = json['img_url'].toString();
    } else if (json['image_url'] != null &&
        json['image_url'].toString().isNotEmpty) {
      image = json['image_url'].toString();
    } else if (json['parts_img_url'] != null &&
        json['parts_img_url'].toString().isNotEmpty) {
      image = json['parts_img_url'].toString();
    } else if (partMap != null &&
        partMap['img_url'] != null &&
        partMap['img_url'].toString().isNotEmpty) {
      image = partMap['img_url'].toString();
    }

    // ==========================================
    // Compatible Model / Spec Text
    // ==========================================

    final compatibleModel =
        partMap?['specification'] ??
        json['specification'] ??
        json['description'] ??
        '';
    // ==================================================
    // Verified 
    // ==================================================
    final isVerified =
        json['is_verified'] ??
        (shopJson is Map &&
            (shopJson['status'] == 'ACTIVE' ||
                shopJson['is_verified'] == true)) ??
        true;
    // =============================================================
    // Owner
    // =============================================================
    final ownerFullName = json['owner_full_name']?.toString() ?? shop;
    final ownerUserId = json['owner_id']?.toString();
    // ==================================================================
    //  Category
    // =================================================================
    final categoryContainer = json['category'] ?? partMap?['category'];
    final categoryId =
        (json['category_id'] ??
                json['part_category_id'] ??
                partMap?['category_id'] ??
                partMap?['part_category_id'] ??
                (categoryContainer is Map ? categoryContainer['id'] : null))
            ?.toString();
    final categorySlug =
        (json['category_slug'] ??
                partMap?['category_slug'] ??
                (categoryContainer is Map ? categoryContainer['slug'] : null))
            ?.toString();
    // =========================================================================
    // ── Part Specs
    // Try to find specs from multiple possible locations in the JSON
    // =========================================================================
    Map<String, dynamic> partSpecs = {};

    // 1. Direct spec object from API
    if (json['part_specs'] is Map) {
      partSpecs = Map<String, dynamic>.from(json['part_specs']);
    }
    // 2. Nested under 'part'
    else if (partMap?['specs'] is Map) {
      partSpecs = Map<String, dynamic>.from(partMap!['specs']);
    }
    // 3. Nested under 'spec'
    else if (json['spec'] is Map) {
      partSpecs = Map<String, dynamic>.from(json['spec']);
    }
    // 4. spec_ram / spec_ssd / spec_battery etc
    else {
      for (final key in [
        'spec_ram',
        'spec_ssd',
        'spec_hdd',
        'spec_battery',
        'spec_display',
        'spec_charger',
        'spec_fan',
        'spec_thermal',
      ]) {
        if (json[key] is Map) {
          partSpecs = Map<String, dynamic>.from(json[key]);
          break;
        }
      }
    }

    return PostModel(
      id: json['id']?.toString() ?? '',
      partName: partName.toString(),
      brand: brand.toString(),
      model: model.toString(),
      compatibleModel: compatibleModel,
      shopName: shop,
      postedBy: shop,
      ownerFullName: ownerFullName,
      ownerUserId: ownerUserId,
      price: priceVal,
      imageUrl: image,
      categoryId: categoryId,
      categorySlug: categorySlug,
      isVerified: isVerified,
      partSpecs: partSpecs,
    );
  }
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
