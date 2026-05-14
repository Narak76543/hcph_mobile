import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/core/network/api_client.dart';
import 'package:school_assgn/core/network/api_config.dart';
import 'package:school_assgn/core/session/session_service.dart';
import 'package:school_assgn/features/home/controllers/home_controller.dart';
import 'package:school_assgn/features/home/models/home_models.dart';

enum AlertKind { priceDrop, compatibility, savedPart, shop, system }

class AlertItem {
  const AlertItem({
    required this.title,
    required this.subtitle,
    required this.kind,
    this.createdAt,
    this.isUnread = false,
  });

  final String title;
  final String subtitle;
  final AlertKind kind;
  final DateTime? createdAt;
  final bool isUnread;

  factory AlertItem.fromJson(Map<String, dynamic> json) {
    final rawTitle =
        json['title'] ??
        json['message'] ??
        json['body'] ??
        json['name'] ??
        'New alert';
    final rawSubtitle =
        json['subtitle'] ??
        json['description'] ??
        json['source'] ??
        json['shop_name'] ??
        'Hardware update';

    return AlertItem(
      title: rawTitle.toString(),
      subtitle: rawSubtitle.toString(),
      kind: _parseKind(json['type'] ?? json['kind'] ?? json['category']),
      createdAt: _parseDate(
        json['created_at'] ?? json['createdAt'] ?? json['posted_at'],
      ),
      isUnread:
          json['is_unread'] == true ||
          json['unread'] == true ||
          json['read_at'] == null,
    );
  }

  static AlertKind _parseKind(dynamic value) {
    final key = value?.toString().toLowerCase() ?? '';
    if (key.contains('price')) return AlertKind.priceDrop;
    if (key.contains('compat')) return AlertKind.compatibility;
    if (key.contains('saved') || key.contains('bookmark')) {
      return AlertKind.savedPart;
    }
    if (key.contains('shop')) return AlertKind.shop;
    return AlertKind.system;
  }
}

class AlertProduct {
  const AlertProduct({
    required this.id,
    required this.name,
    required this.shopName,
    required this.price,
    required this.imageUrl,
    this.oldPrice,
    this.isCompatible = false,
  });

  final String id;
  final String name;
  final String shopName;
  final double price;
  final String imageUrl;
  final double? oldPrice;
  final bool isCompatible;

  String get priceText => _formatPrice(price);

  String? get oldPriceText => oldPrice == null ? null : _formatPrice(oldPrice!);

  int? get dropPercent {
    final previous = oldPrice;
    if (previous == null || previous <= price || previous <= 0) return null;
    return (((previous - price) / previous) * 100).round();
  }

  static AlertProduct fromPost(
    PostModel post, {
    bool isCompatible = false,
    double? oldPrice,
  }) {
    return AlertProduct(
      id: post.id,
      name: post.partName,
      shopName: post.shopName,
      price: post.price,
      oldPrice: oldPrice ?? _extractOldPrice(post),
      imageUrl: _normalizeImage(post.imageUrl),
      isCompatible: isCompatible,
    );
  }

  static double? _extractOldPrice(PostModel post) {
    for (final key in [
      'old_price',
      'original_price',
      'previous_price',
      'compare_at_price',
    ]) {
      final value = post.partSpecs[key];
      final parsed = _parseDouble(value);
      if (parsed != null && parsed > post.price) return parsed;
    }
    return null;
  }

  static String _normalizeImage(String url) {
    final normalized = ApiConfig.normalizeMediaUrl(url);
    return normalized.isEmpty ? 'assets/images/ss990.webp' : normalized;
  }
}

class AlertsController extends GetxController {
  AlertsController({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  final priceDrops = <AlertProduct>[].obs;
  final savedParts = <AlertProduct>[].obs;
  final recentAlerts = <AlertItem>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  bool _usedFallback = false;

  bool get usedFallback => _usedFallback;

  int get unreadCount => recentAlerts.where((alert) => alert.isUnread).length;

  int get compatibleCount =>
      savedParts.where((product) => product.isCompatible).length;

  @override
  void onInit() {
    super.onInit();
    refreshAlerts();
  }

  Future<void> refreshAlerts() async {
    isLoading.value = true;
    errorMessage.value = '';
    _usedFallback = false;

    try {
      await Future.wait([
        _fetchRecentAlerts(),
        _fetchPriceDrops(),
        _fetchSavedParts(),
      ]);

      if (priceDrops.isEmpty && savedParts.isEmpty && recentAlerts.isEmpty) {
        _loadFallbackData();
      }
    } catch (e) {
      debugPrint('[AlertsController] Refresh error: $e');
      errorMessage.value = 'Could not load alerts right now.';
      if (priceDrops.isEmpty && savedParts.isEmpty && recentAlerts.isEmpty) {
        _loadFallbackData();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchRecentAlerts() async {
    final token = _accessToken;
    final response = await _firstSuccessfulRequest([
      () => _apiClient.getRequest('/alerts/', bearerToken: token),
      () => _apiClient.getRequest('/notifications/', bearerToken: token),
    ]);

    final list = _extractList(response);
    if (list.isEmpty) return;

    recentAlerts.value = list
        .whereType<Map>()
        .map((item) => AlertItem.fromJson(Map<String, dynamic>.from(item)))
        .take(10)
        .toList();
  }

  Future<void> _fetchPriceDrops() async {
    final response = await _firstSuccessfulRequest([
      () => _apiClient.getRequest(
        '/listings/price-drops/',
        queryParameters: {'limit': '10'},
      ),
      () =>
          _apiClient.getRequest('/listings/', queryParameters: {'limit': '20'}),
    ]);

    final products = _extractPosts(response);
    final mapped = products
        .map(
          (post) =>
              AlertProduct.fromPost(post, isCompatible: _isCompatible(post)),
        )
        .where((product) => product.price > 0)
        .toList();

    final drops = mapped.where((product) => product.oldPrice != null).toList();
    priceDrops.value = (drops.isNotEmpty ? drops : mapped).take(8).toList();

    if (recentAlerts.isEmpty && products.isNotEmpty) {
      recentAlerts.value = products.take(4).map((post) {
        return AlertItem(
          title: '${post.partName} is available now',
          subtitle: _joinMeta([_formatPrice(post.price), post.shopName]),
          kind: AlertKind.shop,
          createdAt: post.postedAt,
        );
      }).toList();
    }
  }

  Future<void> _fetchSavedParts() async {
    final token = _accessToken;
    final response = await _firstSuccessfulRequest([
      () => _apiClient.getRequest('/saved-parts/', bearerToken: token),
      () => _apiClient.getRequest('/saved-listings/', bearerToken: token),
      () => _apiClient.getRequest('/bookmarks/', bearerToken: token),
    ]);

    final products = _extractPosts(response);
    if (products.isEmpty) return;

    savedParts.value = products
        .map(
          (post) =>
              AlertProduct.fromPost(post, isCompatible: _isCompatible(post)),
        )
        .take(6)
        .toList();
  }

  Future<dynamic> _firstSuccessfulRequest(
    List<Future<dynamic> Function()> requests,
  ) async {
    Object? lastError;
    for (final request in requests) {
      try {
        final response = await request();
        if (_extractList(response).isNotEmpty) return response;
      } catch (e) {
        lastError = e;
        debugPrint('[AlertsController] Request failed: $e');
      }
    }
    if (lastError != null) {
      debugPrint('[AlertsController] No endpoint matched.');
    }
    return const [];
  }

  List<PostModel> _extractPosts(dynamic response) {
    return _extractList(response).whereType<Map>().map((item) {
      final data = Map<String, dynamic>.from(item);
      final listing = data['listing'];
      final source = listing is Map ? Map<String, dynamic>.from(listing) : data;
      final post = PostModel.fromJson(source);
      return post.copyWith(
        imageUrl: ApiConfig.normalizeMediaUrl(post.imageUrl),
      );
    }).toList();
  }

  List<dynamic> _extractList(dynamic response) {
    if (response is List) return response;
    if (response is Map<String, dynamic>) {
      for (final key in [
        'data',
        'results',
        'items',
        'notifications',
        'alerts',
      ]) {
        final value = response[key];
        if (value is List) return value;
      }
    }
    return const [];
  }

  bool _isCompatible(PostModel post) {
    try {
      if (!Get.isRegistered<HomeController>()) return false;
      return Get.find<HomeController>().isCompatibleWithDevice(post);
    } catch (_) {
      return false;
    }
  }

  String? get _accessToken {
    try {
      return Get.find<SessionService>().accessToken;
    } catch (_) {
      return null;
    }
  }

  void _loadFallbackData() {
    _usedFallback = true;
    priceDrops.value = const [
      AlertProduct(
        id: 'fallback-ssd',
        name: 'Samsung 990 PRO 2TB',
        shopName: 'TechMart Pro',
        price: 89,
        oldPrice: 99,
        imageUrl: 'assets/images/990.png',
        isCompatible: true,
      ),
      AlertProduct(
        id: 'fallback-ram',
        name: 'Crucial DDR5 32GB Kit',
        shopName: 'Norton Parts',
        price: 105.99,
        oldPrice: 119,
        imageUrl: 'assets/images/crucal.png',
        isCompatible: true,
      ),
    ];
    savedParts.value = const [
      AlertProduct(
        id: 'saved-ram',
        name: 'Corsair Vengeance DDR5',
        shopName: 'Saved watch',
        price: 124,
        imageUrl: 'assets/images/crucal.png',
        isCompatible: true,
      ),
      AlertProduct(
        id: 'saved-ssd',
        name: 'WD_BLACK SN850X',
        shopName: 'Saved watch',
        price: 149.99,
        imageUrl: 'assets/images/990.webp',
      ),
    ];
    recentAlerts.value = [
      AlertItem(
        title: 'Samsung 990 PRO dropped 10%',
        subtitle: 'TechMart Pro',
        kind: AlertKind.priceDrop,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isUnread: true,
      ),
      AlertItem(
        title: 'New compatible RAM found',
        subtitle: 'Matches your saved laptop',
        kind: AlertKind.compatibility,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}

double? _parseDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) {
    return double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), ''));
  }
  return null;
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is num) {
    final raw = value.toInt();
    return DateTime.fromMillisecondsSinceEpoch(
      raw < 10000000000 ? raw * 1000 : raw,
    );
  }
  return DateTime.tryParse(value.toString());
}

String _formatPrice(double price) {
  final isWhole = price == price.roundToDouble();
  return '\$${price.toStringAsFixed(isWhole ? 0 : 2)}';
}

String _joinMeta(List<String> values) {
  return values.where((value) => value.trim().isNotEmpty).join(' • ');
}
