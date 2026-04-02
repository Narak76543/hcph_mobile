import 'package:school_assgn/core/network/api_client.dart';
import 'package:school_assgn/core/network/api_config.dart';
import 'package:school_assgn/core/network/api_exception.dart';
import 'package:school_assgn/core/auth/google_account_sync.dart';

class AuthApiService {
  AuthApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) {
    return _apiClient.postForm(
      ApiConfig.loginPath,
      fields: {'username': username, 'password': password},
    );
  }

  Future<Map<String, dynamic>> register({
    required String firstname,
    required String lastname,
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
    String? firstnameLc,
    String? lastnameLc,
  }) async {
    final fields = <String, String>{
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'email': email,
      'phone_number': phoneNumber,
      'password': password,
      'firstname_lc': ?firstnameLc,
      'lastname_lc': ?lastnameLc,
    };

    return _apiClient.postMultipart(ApiConfig.registerPath, fields: fields);
  }

  Future<Map<String, dynamic>> ensureGoogleUserInBackendAndLogin({
    required String firebaseUid,
    required String email,
    String? displayName,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final generatedPassword = buildGoogleLinkedPassword(firebaseUid);
    final names = _splitDisplayName(displayName, normalizedEmail);
    final username = _buildGoogleUsername(normalizedEmail, firebaseUid);
    final phoneNumber = _buildGooglePhone(firebaseUid);

    try {
      await register(
        firstname: names.firstname,
        lastname: names.lastname,
        firstnameLc: names.firstname.toLowerCase(),
        lastnameLc: names.lastname.toLowerCase(),
        username: username,
        email: normalizedEmail,
        phoneNumber: phoneNumber,
        password: generatedPassword,
      );
    } on ApiException catch (error) {
      if (!_isAlreadyExistsError(error)) {
        rethrow;
      }
    }

    try {
      return await login(username: username, password: generatedPassword);
    } on ApiException catch (usernameError) {
      try {
        return await login(
          username: normalizedEmail,
          password: generatedPassword,
        );
      } on ApiException {
        throw usernameError;
      }
    }
  }

  ({String firstname, String lastname}) _splitDisplayName(
    String? displayName,
    String email,
  ) {
    final compactName = (displayName ?? '').trim().replaceAll(
      RegExp(r'\s+'),
      ' ',
    );
    if (compactName.isNotEmpty) {
      final parts = compactName.split(' ');
      final firstname = parts.first;
      final lastname = parts.length > 1 ? parts.sublist(1).join(' ') : 'User';
      return (firstname: firstname, lastname: lastname);
    }

    final fallback = email.split('@').first.trim();
    final firstname = fallback.isEmpty ? 'Google' : fallback;
    return (firstname: firstname, lastname: 'User');
  }

  String _buildGoogleUsername(String email, String firebaseUid) {
    final localPart = email.split('@').first.toLowerCase();
    final base = localPart.replaceAll(RegExp(r'[^a-z0-9_]'), '_');
    final safeBase = base.isEmpty ? 'google_user' : base;

    final compactUid = firebaseUid
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
        .toLowerCase();
    final suffix = compactUid.isEmpty
        ? '000000'
        : compactUid.substring(
            0,
            compactUid.length > 6 ? 6 : compactUid.length,
          );

    return '${safeBase}_$suffix';
  }

  String _buildGooglePhone(String firebaseUid) {
    var hash = 0;
    for (final codeUnit in firebaseUid.codeUnits) {
      hash = (hash * 31 + codeUnit) & 0x7fffffff;
    }

    final digits = hash.toString().padLeft(10, '0');
    return digits.substring(digits.length - 10);
  }

  bool _isAlreadyExistsError(ApiException error) {
    final message = error.message.toLowerCase();
    final looksLikeConflict =
        message.contains('already') ||
        message.contains('exist') ||
        message.contains('taken') ||
        message.contains('duplicate') ||
        message.contains('unique');

    if (looksLikeConflict) {
      return true;
    }

    return error.statusCode == 409;
  }
}
