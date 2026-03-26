class ApiException implements Exception {
  ApiException({required this.message, this.statusCode, this.data});

  final String message;
  final int? statusCode;
  final Object? data;

  @override
  String toString() {
    final status = statusCode == null ? '' : ' (status: $statusCode)';
    return 'ApiException$status: $message';
  }
}
