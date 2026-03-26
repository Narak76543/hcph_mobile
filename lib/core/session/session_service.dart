import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _accessTokenKey = 'session_access_token';
  static const _userNameKey = 'session_user_name';

  String? _accessToken;
  String? _userName;

  bool get isLoggedIn => (_accessToken ?? '').isNotEmpty;

  String? get accessToken => _accessToken;

  String? get userName => _userName;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString(_accessTokenKey);
    _userName = prefs.getString(_userNameKey);
  }

  Future<void> saveSession({
    required String accessToken,
    String? userName,
  }) async {
    _accessToken = accessToken;
    _userName = userName;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);

    if (userName != null && userName.trim().isNotEmpty) {
      await prefs.setString(_userNameKey, userName);
    } else {
      await prefs.remove(_userNameKey);
    }
  }

  Future<void> clearSession() async {
    _accessToken = null;
    _userName = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_userNameKey);
  }
}
