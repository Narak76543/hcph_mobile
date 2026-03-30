import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:school_assgn/core/network/api_config.dart';
import 'package:school_assgn/core/network/api_exception.dart';

class ApiClient {
  ApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

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
        if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
      },
      body: fields,
    );

    return _handleResponse(response);
  }

  Future<dynamic> getRequest(
    String path, {
    Map<String, String>? queryParameters,
    String? bearerToken,
  }) async {
    Uri uri = _buildUri(path);
    if (queryParameters != null) {
      uri = uri.replace(queryParameters: queryParameters);
    }
    final response = await _httpClient.get(
      uri,
      headers: {
        'Accept': 'application/json',
        if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
      },
    );

    final decoded = _decodeBody(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        message: _extractErrorMessage(decoded),
        statusCode: response.statusCode,
        data: decoded,
      );
    }
    return decoded;
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
        if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
      },
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required Map<String, String> fields,
    String? fileFieldName,
    String? filePath,
    String? bearerToken,
  }) async {
    final request = http.MultipartRequest('POST', _buildUri(path));

    request.headers['Accept'] = 'application/json';
    if (bearerToken != null) {
      request.headers['Authorization'] = 'Bearer $bearerToken';
    }

    request.fields.addAll(fields);

    if (fileFieldName != null &&
        filePath != null &&
        filePath.trim().isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath(
          fileFieldName,
          filePath,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> patchMultipart(
    String path, {
    required Map<String, String> fields,
    String? fileFieldName,
    String? filePath,
    String? bearerToken,
  }) async {
    final request = http.MultipartRequest('PATCH', _buildUri(path));

    request.headers['Accept'] = 'application/json';
    if (bearerToken != null) {
      request.headers['Authorization'] = 'Bearer $bearerToken';
    }

    request.fields.addAll(fields);

    if (fileFieldName != null &&
        filePath != null &&
        filePath.trim().isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath(
          fileFieldName,
          filePath,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return _handleResponse(response);
  }

  Uri _buildUri(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('${ApiConfig.baseUrl}$normalizedPath');
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final decoded = _decodeBody(response.body);

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

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return <String, dynamic>{'data': decoded};
  }

  dynamic _decodeBody(String body) {
    if (body.trim().isEmpty) {
      return null;
    }

    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  String _extractErrorMessage(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      final detail = decoded['detail'];
      if (detail is String && detail.trim().isNotEmpty) {
        return detail;
      }
      if (detail is List && detail.isNotEmpty) {
        final first = detail.first;
        if (first is Map<String, dynamic> && first['msg'] is String) {
          return first['msg'] as String;
        }
      }
      if (decoded['message'] is String) {
        return decoded['message'] as String;
      }
    }

    if (decoded is String && decoded.trim().isNotEmpty) {
      return decoded;
    }

    return 'Request failed. Please try again.';
  }
}
