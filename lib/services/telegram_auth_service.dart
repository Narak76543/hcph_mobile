// TELEGRAM LOGIN - lib/services/telegram_auth_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:school_assgn/core/network/api_config.dart';
import 'package:school_assgn/core/session/session_service.dart';

class TelegramAuthService {
  // Replace these with your actual configuration
  static const String botId = "8724350948"; // The numeric ID of your bot
  static const String backendUrl = ApiConfig.baseUrl;
  static const String deepLinkScheme =
      '${ApiConfig.baseUrl}${ApiConfig.telegramCallbackPath}';

  static final RxBool isLoading = false.obs;

  /// Launches the Telegram OAuth URL in an external browser
  static Future<void> signIn(BuildContext context) async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      final url = Uri.https("oauth.telegram.org", "/auth", {
        "bot_id": botId,
        "origin": backendUrl,
        "return_to": deepLinkScheme,
      });

      // Use external application to ensure the user is redirected back to our app
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch Telegram login URL';
      }
    } catch (e) {
      isLoading.value = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Telegram login failed: $e")));
    }
  }

  /// Handles the callback from the deep link, sending parameters to the backend
  static Future<void> handleCallback(
    Map<String, String> params,
    BuildContext context,
  ) async {
    debugPrint("DEBUG: TelegramAuthService.handleCallback received: $params");
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("$backendUrl/auth/telegram"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(params),
      );

      debugPrint("DEBUG: Backend response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        final user = data['user'];

        // Use SessionService to save the session properly (updates both disk and memory)
        final sessionService = Get.find<SessionService>();
        await sessionService.saveSession(
          accessToken: token,
          userName: user['firstname'] ?? user['username'] ?? 'User',
          userId: user['id'].toString(),
        );

        isLoading.value = false;

        debugPrint("DEBUG: Login successful. Navigating to /main-nav...");

        // Wait 200ms for stability
        await Future.delayed(const Duration(milliseconds: 200));

        // Use correct route from AppRoutes.mainNav
        Get.offAllNamed(
          '/main-nav',
          arguments: {
            'welcomeName': user['firstname'] ?? user['username'] ?? 'User',
          },
        );
      } else {
        final error = jsonDecode(response.body)['detail'] ?? "Server error";
        debugPrint("DEBUG: Backend error: $error");
        throw error;
      }
    } catch (e) {
      debugPrint("DEBUG: Telegram handleCallback Exception: $e");
      isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Telegram login failed. Please try again."),
        ),
      );
    }
  }
}
