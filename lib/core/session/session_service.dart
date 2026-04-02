import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _accessTokenKey = 'session_access_token';
  static const _userNameKey = 'session_user_name';
  static const _userIdKey = 'session_user_id';

  String? _accessToken;
  String? _userName;
  String? _userId;

  bool get isLoggedIn => (_accessToken ?? '').isNotEmpty;

  String? get accessToken => _accessToken;

  String? get userName => _userName;

  String? get userId => _userId;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString(_accessTokenKey);
    _userName = prefs.getString(_userNameKey);
    _userId = prefs.getString(_userIdKey);
  }

  Future<void> saveSession({
    required String accessToken,
    String? userName,
    String? userId,
  }) async {
    _accessToken = accessToken;
    _userName = userName;
    _userId = userId;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);

    if (userName != null && userName.trim().isNotEmpty) {
      await prefs.setString(_userNameKey, userName);
    } else {
      await prefs.remove(_userNameKey);
    }

    if (userId != null && userId.trim().isNotEmpty) {
      await prefs.setString(_userIdKey, userId);
    } else {
      await prefs.remove(_userIdKey);
    }
  }

  Future<void> clearSession() async {
    _accessToken = null;
    _userName = null;
    _userId = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userIdKey);
  }
}
