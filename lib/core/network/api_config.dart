class ApiConfig {
  ApiConfig._();

  /// Local FastAPI backend on your Wi-Fi/LAN.
  ///
  /// Change this value when your computer's IPv4 address changes.
  /// You can also override it at run/build time:
  /// flutter run --dart-define=API_BASE_URL=http://192.168.0.198:8000
  static const String localNetworkBaseUrl = 'http://192.168.0.198:8000';

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: localNetworkBaseUrl,
  );

  static const String telegramCallbackPath = '/auth/telegram/callback';

  static const String loginPath = '/users/login';

  /// Change this if your backend uses a different create-user endpoint.
  static const String registerPath = '/users/register';
}