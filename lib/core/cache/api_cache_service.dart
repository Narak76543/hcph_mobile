import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CachedApiResponse {
  const CachedApiResponse({
    required this.data,
    required this.cachedAt,
    required this.expiresAt,
  });

  final dynamic data;
  final DateTime cachedAt;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

class ApiCacheService extends GetxService {
  static const String boxName = 'api_response_cache';
  static const Duration defaultTtl = Duration(minutes: 10);

  late final Box<dynamic> _box;
  final Map<String, Future<dynamic>> _inFlight = {};

  Future<ApiCacheService> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<dynamic>(boxName);
    return this;
  }

  String buildKey(
    String method,
    Uri uri, {
    String? bearerToken,
  }) {
    final tokenScope = bearerToken == null || bearerToken.isEmpty
        ? 'public'
        : bearerToken.hashCode.toString();
    return base64Url.encode(utf8.encode('$method|$tokenScope|$uri'));
  }

  Future<CachedApiResponse?> read(
    String key, {
    bool allowExpired = true,
  }) async {
    try {
      final raw = _box.get(key);
      if (raw is! Map) return null;

      final cachedAtMillis = raw['cachedAtMillis'];
      final expiresAtMillis = raw['expiresAtMillis'];
      if (cachedAtMillis is! int || expiresAtMillis is! int) return null;

      final entry = CachedApiResponse(
        data: raw['data'],
        cachedAt: DateTime.fromMillisecondsSinceEpoch(cachedAtMillis),
        expiresAt: DateTime.fromMillisecondsSinceEpoch(expiresAtMillis),
      );

      if (!allowExpired && entry.isExpired) return null;
      return entry;
    } catch (error) {
      debugPrint('[ApiCacheService] Cache read failed: $error');
      return null;
    }
  }

  Future<void> write(
    String key,
    dynamic data, {
    Duration ttl = defaultTtl,
  }) async {
    try {
      final now = DateTime.now();
      await _box.put(key, {
        'data': data,
        'cachedAtMillis': now.millisecondsSinceEpoch,
        'expiresAtMillis': now.add(ttl).millisecondsSinceEpoch,
      });
    } catch (error) {
      debugPrint('[ApiCacheService] Cache write failed: $error');
    }
  }

  bool hasInFlight(String key) => _inFlight.containsKey(key);

  Future<T> dedupe<T>(String key, Future<T> Function() request) {
    final existing = _inFlight[key];
    if (existing != null) return existing.then((value) => value as T);

    final future = request();
    _inFlight[key] = future;
    future.whenComplete(() => _inFlight.remove(key));
    return future;
  }

  Future<void> clear() => _box.clear();
}
