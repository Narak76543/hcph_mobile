class ApiConfig {
  ApiConfig._();

  /// Local FastAPI backend on your Wi-Fi/LAN.
  ///
  /// Change this value when your computer's IPv4 address changes.
  /// You can also override it at run/build time:
  /// flutter run --dart-define=API_BASE_URL=http://192.168.0.198:8000
  /// InnoTech Internet
  static const String localNetworkBaseUrl = 'http://192.168.0.198:8000';

  // G108 Norton Wifi
  // static const String localNetworkBaseUrl = 'http://172.16.42.87:8000';

  // Hot spot ip
  // static const String localNetworkBaseUrl = 'http://10.245.111.184:8000';
  // Norton Main Wifi
  // static const String localNetworkBaseUrl = 'http://172.16.22.9:8000';

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: localNetworkBaseUrl,
  );

  static const String telegramCallbackPath = '/auth/telegram/callback';

  static const String loginPath = '/users/login';

  /// Change this if your backend uses a different create-user endpoint.
  static const String registerPath = '/users/register';

  static String normalizeMediaUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty || trimmed.startsWith('assets/')) return trimmed;

    final uri = Uri.tryParse(trimmed);
    if (uri != null && uri.hasAbsolutePath && uri.path.startsWith('/media/')) {
      return '$baseUrl${uri.path}${uri.hasQuery ? '?${uri.query}' : ''}';
    }

    if (!trimmed.startsWith('http')) {
      return '$baseUrl${trimmed.startsWith('/') ? trimmed : '/$trimmed'}';
    }

    return trimmed;
  }
}
