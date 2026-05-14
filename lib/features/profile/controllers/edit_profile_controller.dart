import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_assgn/core/network/api_client.dart';
import 'package:school_assgn/features/profile/controllers/profile_controller.dart';
import 'package:school_assgn/core/session/session_service.dart';
import 'package:school_assgn/widget/success_dialog.dart';

class EditProfileController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final firstnameCtrl = TextEditingController();
  final firstnameLcCtrl = TextEditingController();
  final lastnameCtrl = TextEditingController();
  final lastnameLcCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final telegram_username = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString selectedImagePath = ''.obs;
  String? _token;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentData();
  }

  Future<void> _loadCurrentData() async {
    if (Get.isRegistered<SessionService>()) {
      _token = Get.find<SessionService>().accessToken;
    }
    try {
      // Fetch fresh data from backend to pre-fill all fields
      if (_token != null && _token!.isNotEmpty) {
        final data = await ApiClient().getRequest(
          '/users/me',
          bearerToken: _token,
        );
        if (data is Map<String, dynamic>) {
          firstnameCtrl.text = data['firstname'] as String? ?? '';
          lastnameCtrl.text = data['lastname'] as String? ?? '';
          firstnameLcCtrl.text = data['firstname_lc'] as String? ?? '';
          lastnameLcCtrl.text = data['lastname_lc'] as String? ?? '';
          usernameCtrl.text = data['username'] as String? ?? '';
          phoneCtrl.text = data['phone_number'] as String? ?? '';
          telegram_username.text = _normalizeTelegramUsername(
            data['telegram_username']?.toString() ?? '',
          );
          return;
        }
      }
    } catch (_) {}
    // Fallback: use cached ProfileController data
    if (Get.isRegistered<ProfileController>()) {
      final profileCtrl = Get.find<ProfileController>();
      final parts = profileCtrl.userName.value.split(' ');
      if (parts.isNotEmpty) firstnameCtrl.text = parts.first;
      if (parts.length > 1) lastnameCtrl.text = parts.skip(1).join(' ');
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
    }
  }

  Future<void> submit() async {
    if (firstnameCtrl.text.isEmpty || lastnameCtrl.text.isEmpty) {
      Get.snackbar('Error', 'Firstname and Lastname are required');
      return;
    }

    final telegramUsername = _normalizeTelegramUsername(
      telegram_username.text,
    );
    if (!_isValidTelegramUsername(telegramUsername)) {
      Get.snackbar(
        'Invalid Telegram username',
        'Use 5-32 characters: letters, numbers, or underscore.',
      );
      return;
    }

    isLoading.value = true;
    try {
      final fields = <String, String>{};
      if (firstnameCtrl.text.isNotEmpty) {
        fields['firstname'] = firstnameCtrl.text;
        fields['firstname_lc'] = firstnameLcCtrl.text.isNotEmpty
            ? firstnameLcCtrl.text
            : firstnameCtrl.text.toLowerCase();
      }
      if (lastnameCtrl.text.isNotEmpty) {
        fields['lastname'] = lastnameCtrl.text;
        fields['lastname_lc'] = lastnameLcCtrl.text.isNotEmpty
            ? lastnameLcCtrl.text
            : lastnameCtrl.text.toLowerCase();
      }
      if (usernameCtrl.text.isNotEmpty) fields['username'] = usernameCtrl.text;
      if (phoneCtrl.text.isNotEmpty) fields['phone_number'] = phoneCtrl.text;
      fields['telegram_username'] = telegramUsername;

      final response = await _apiClient.patchMultipart(
        '/users/me',
        fields: fields,
        fileFieldName: selectedImagePath.value.isNotEmpty
            ? 'profile_image'
            : null,
        filePath: selectedImagePath.value.isNotEmpty
            ? selectedImagePath.value
            : null,
        bearerToken: _token,
      );

      // Successfully updated profile
      if (Get.isRegistered<ProfileController>()) {
        final profileCtrl = Get.find<ProfileController>();
        final fName = response['firstname'] ?? firstnameCtrl.text;
        final lName = response['lastname'] ?? lastnameCtrl.text;
        profileCtrl.userName.value = '$fName $lName';
        if (response['profile_image_url'] != null) {
          profileCtrl.userAvatarUrl.value =
              response['profile_image_url'] as String;
        }
        await profileCtrl.refreshProfile();
      }

      Get.back();
      SuccessDialog.show(
        message: 'Your profile has been updated successfully.',
      );
    } catch (e) {
      Get.snackbar(
        'Update Failed',
        e.toString(),
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstnameCtrl.dispose();
    firstnameLcCtrl.dispose();
    lastnameCtrl.dispose();
    lastnameLcCtrl.dispose();
    usernameCtrl.dispose();
    phoneCtrl.dispose();
    telegram_username.dispose();
    super.onClose();
  }

  String _normalizeTelegramUsername(String value) {
    final trimmed = value.trim().replaceAll(RegExp(r'\s+'), '');
    if (trimmed.isEmpty) return '';

    final withoutAt = trimmed.replaceFirst(RegExp(r'^@+'), '');
    return '@$withoutAt';
  }

  bool _isValidTelegramUsername(String value) {
    if (value.isEmpty) return true;
    return RegExp(r'^@[A-Za-z0-9_]{5,32}$').hasMatch(value);
  }
}
