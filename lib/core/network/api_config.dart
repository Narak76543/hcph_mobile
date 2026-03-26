class ApiConfig {
  ApiConfig._();

  /// Override at build time:
  /// flutter run --dart-define=API_BASE_URL=http://192.168.1.5:8000
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://grateful-usable-hedy.ngrok-free.dev',
  );

  static const String loginPath = '/users/login';

  /// Change this if your backend uses a different create-user endpoint.
  static const String registerPath = '/users/register';
}
