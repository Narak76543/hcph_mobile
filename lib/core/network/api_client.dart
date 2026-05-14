import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:school_assgn/core/cache/api_cache_service.dart';
import 'package:school_assgn/core/network/api_config.dart';
import 'package:school_assgn/core/network/api_exception.dart';

class ApiClient {
  ApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  static const Duration requestTimeout = Duration(seconds: 12);

  final http.Client _httpClient;

  Future<Map<String, dynamic>> postForm(
    String path, {
    required Map<String, String> fields,
    String? bearerToken,
  }) async {
    final response = await _httpClient.post(
      _buildUri(path),
      headers: {
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
        if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
      },
      body: fields,
    ).timeout(requestTimeout);

    return _handleResponse(response);
  }

  Future<dynamic> getRequest(
    String path, {
    Map<String, String>? queryParameters,
    String? bearerToken,
    bool forceRefresh = false,
    bool cacheResponse = true,
    bool returnCachedOnError = true,
    Duration cacheDuration = ApiCacheService.defaultTtl,
  }) async {
    Uri uri = _buildUri(path);
    if (queryParameters != null) {
      uri = uri.replace(queryParameters: queryParameters);
    }
    final cache = _cacheService;
    final cacheKey = cache?.buildKey('GET', uri, bearerToken: bearerToken);
    final cached = cacheKey == null
        ? null
        : await cache?.read(cacheKey, allowExpired: true);

    if (!forceRefresh && cached != null && !cached.isExpired) {
      return cached.data;
    }

    try {
      final request = () async {
        final response = await _httpClient.get(
          uri,
          headers: {
            'Accept': 'application/json',
            'ngrok-skip-browser-warning': 'true',
            if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
          },
        ).timeout(requestTimeout);

        final decoded = _decodeBody(response.body);

        if (response.statusCode < 200 || response.statusCode >= 300) {
          throw ApiException(
            message: _extractErrorMessage(decoded),
            statusCode: response.statusCode,
            data: decoded,
          );
        }

        if (cacheResponse && cache != null && cacheKey != null) {
          await cache.write(cacheKey, decoded, ttl: cacheDuration);
        }
        return decoded;
      };

      if (cache != null && cacheKey != null) {
        return await cache.dedupe(cacheKey, request);
      }
      return await request();
    } catch (error) {
      if (returnCachedOnError && cached != null) {
        debugPrint('[ApiClient] Returning cached data for $uri after: $error');
        return cached.data;
      }
      rethrow;
    }
  }

  Future<dynamic> getCachedRequest(
    String path, {
    Map<String, String>? queryParameters,
    String? bearerToken,
    bool allowExpired = true,
  }) async {
    Uri uri = _buildUri(path);
    if (queryParameters != null) {
      uri = uri.replace(queryParameters: queryParameters);
    }

    final cache = _cacheService;
    if (cache == null) return null;
    final cacheKey = cache.buildKey('GET', uri, bearerToken: bearerToken);
    return (await cache.read(cacheKey, allowExpired: allowExpired))?.data;
  }

  Future<void> getCachedThenFresh(
    String path, {
    Map<String, String>? queryParameters,
    String? bearerToken,
    Duration cacheDuration = ApiCacheService.defaultTtl,
    required void Function(dynamic data) onData,
    void Function(Object error)? onError,
  }) async {
    final cached = await getCachedRequest(
      path,
      queryParameters: queryParameters,
      bearerToken: bearerToken,
    );

    if (cached != null) {
      onData(cached);
    }

    try {
      final fresh = await getRequest(
        path,
        queryParameters: queryParameters,
        bearerToken: bearerToken,
        forceRefresh: true,
        cacheDuration: cacheDuration,
      );
      if (cached == null || jsonEncode(cached) != jsonEncode(fresh)) {
        onData(fresh);
      }
    } catch (error) {
      if (cached == null) {
        onError?.call(error);
      } else {
        debugPrint('[ApiClient] Fresh refresh failed for $path: $error');
      }
    }
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    required Map<String, dynamic> body,
    String? bearerToken,
  }) async {
    final response = await _httpClient.post(
      _buildUri(path),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
        if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
      },
      body: jsonEncode(body),
    ).timeout(requestTimeout);

    final decoded = _handleResponse(response);
    unawaited(_clearApiCache());
    return decoded;
  }

  Future<Map<String, dynamic>> deleteJson(
    String path, {
    String? bearerToken,
  }) async {
    final response = await _httpClient.delete(
      _buildUri(path),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
        if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
      },
    ).timeout(requestTimeout);

    final decoded = _handleResponse(response);
    unawaited(_clearApiCache());
    return decoded;
  }

  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required Map<String, String> fields,
    String? fileFieldName,
    String? filePath,
    Map<String, String>? extraFiles, // fieldName -> filePath
    String? bearerToken,
  }) async {
    final request = http.MultipartRequest('POST', _buildUri(path));

    request.headers['Accept'] = 'application/json';
    request.headers['ngrok-skip-browser-warning'] = 'true';
    if (bearerToken != null) {
      request.headers['Authorization'] = 'Bearer $bearerToken';
    }

    request.fields.addAll(fields);

    // Debug: Log all fields being sent
    print('🔍 Multipart Fields:');
    request.fields.forEach((key, value) {
      print(
        '  - $key: ${value.length > 50 ? '${value.substring(0, 50)}...' : value}',
      );
    });

    Future<void> addFile(String field, String path) async {
      if (path.trim().isEmpty) return;
      request.files.add(
        await http.MultipartFile.fromPath(
          field,
          path,
          contentType: _guessMediaType(path),
        ),
      );
      print('📎 File added: fieldName=$field, path=$path');
    }

    if (fileFieldName != null && filePath != null) {
      await addFile(fileFieldName, filePath);
    }

    if (extraFiles != null) {
      for (final entry in extraFiles.entries) {
        await addFile(entry.key, entry.value);
      }
    }

    print('📊 Multipart request files count: ${request.files.length}');

    final streamed = await request.send().timeout(requestTimeout);
    final response = await http.Response.fromStream(streamed);
    final decoded = _handleResponse(response);
    unawaited(_clearApiCache());
    return decoded;
  }

  Future<Map<String, dynamic>> patchMultipart(
    String path, {
    required Map<String, String> fields,
    String? fileFieldName,
    String? filePath,
    Map<String, String>? extraFiles, // fieldName -> filePath
    String? bearerToken,
  }) async {
    final request = http.MultipartRequest('PATCH', _buildUri(path));

    request.headers['Accept'] = 'application/json';
    request.headers['ngrok-skip-browser-warning'] = 'true';
    if (bearerToken != null) {
      request.headers['Authorization'] = 'Bearer $bearerToken';
    }

    request.fields.addAll(fields);

    Future<void> addFile(String field, String path) async {
      if (path.trim().isEmpty) return;
      request.files.add(
        await http.MultipartFile.fromPath(
          field,
          path,
          contentType: _guessMediaType(path),
        ),
      );
    }

    if (fileFieldName != null && filePath != null) {
      await addFile(fileFieldName, filePath);
    }

    if (extraFiles != null) {
      for (final entry in extraFiles.entries) {
        await addFile(entry.key, entry.value);
      }
    }

    final streamed = await request.send().timeout(requestTimeout);
    final response = await http.Response.fromStream(streamed);
    final decoded = _handleResponse(response);
    unawaited(_clearApiCache());
    return decoded;
  }

  Uri _buildUri(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('${ApiConfig.baseUrl}$normalizedPath');
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final decoded = _decodeBody(response.body);

    print('📬 Response status: ${response.statusCode}');
    print(
      '📬 Response body: ${response.body.length > 200 ? '${response.body.substring(0, 200)}...' : response.body}',
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        message: _extractErrorMessage(decoded),
        statusCode: response.statusCode,
        data: decoded,
      );
    }

    if (decoded == null) {
      return <String, dynamic>{};
    }

    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }

    return <String, dynamic>{'data': decoded};
  }

  dynamic _decodeBody(String body) {
    if (body.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(body);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
      return decoded;
    } catch (_) {
      return body;
    }
  }

  String _extractErrorMessage(dynamic decoded) {
    if (decoded is Map) {
      final detail = decoded['detail'];
      if (detail is String && detail.trim().isNotEmpty) {
        return detail;
      }
      if (detail is List && detail.isNotEmpty) {
        final first = detail.first;
        if (first is Map && first['msg'] is String) {
          final msg = first['msg'] as String;
          final loc = first['loc'];
          if (loc is List && loc.isNotEmpty) {
            final path = loc.map((e) => e.toString()).join('.');
            return '$path: $msg';
          }
          return msg;
        }
      }
      if (decoded['message'] is String) {
        return decoded['message'] as String;
      }
    }

    if (decoded is String && decoded.trim().isNotEmpty) {
      if (decoded.contains('<!DOCTYPE html>') || decoded.contains('<html')) {
        return 'Server returned an HTML page instead of data. This usually means Ngrok is blocking the request with a warning page. Open the Ngrok URL in your browser once to "Visit Site".';
      }
      return decoded;
    }

    return 'Request failed. Please try again.';
  }

  // Basic content-type detection to avoid forcing JPEG for PNG/WebP files.
  MediaType? _guessMediaType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return MediaType('image', 'png');
    if (lower.endsWith('.webp')) return MediaType('image', 'webp');
    if (lower.endsWith('.gif')) return MediaType('image', 'gif');
    // default to jpeg for common camera images
    return MediaType('image', 'jpeg');
  }

  ApiCacheService? get _cacheService {
    try {
      return Get.find<ApiCacheService>();
    } catch (_) {
      return null;
    }
  }

  Future<void> _clearApiCache() async {
    try {
      await _cacheService?.clear();
    } catch (error) {
      debugPrint('[ApiClient] Cache invalidation failed: $error');
    }
  }
}
