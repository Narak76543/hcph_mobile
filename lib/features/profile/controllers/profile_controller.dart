import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_assgn/core/network/api_client.dart';
import 'package:school_assgn/core/network/api_config.dart';
import 'package:school_assgn/core/session/session_service.dart';
import 'package:school_assgn/features/main_nav/controllers/main_nav_controller.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';
import 'package:school_assgn/core/theme/theme_service.dart';

class ProfileController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final RxString userName = 'Sarat Narak'.obs;
  final RxString userBadge = 'Member'.obs;
  final RxString userRole = 'user'.obs;
  final RxString userAvatarUrl = 'assets/images/norton_university.png'.obs;

  final RxBool isTechnicalRole = false.obs;
  final RxInt shopViews = 0.obs;
  final RxBool hasRequestedRole = false.obs;

  // Settings
  final RxBool isDarkMode = false.obs;
  final RxBool isKhmerLanguage = false.obs;

  // Request form controllers (kept here so the sheet is stateless)
  final shopNameCtrl = TextEditingController();
  final shopAddressCtrl = TextEditingController();
  final shopPhoneCtrl = TextEditingController();
  final shopReasonCtrl = TextEditingController();
  final RxBool isRequestLoading = false.obs;

  // ── Laptop model management ──
  final RxList<Map<String, dynamic>> myLaptops = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> laptopBrands =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> laptopModels =
      <Map<String, dynamic>>[].obs;
  final Rx<Map<String, dynamic>?> selectedBrand = Rx<Map<String, dynamic>?>(
    null,
  );
  final RxBool isLaptopLoading = false.obs;
  final RxBool isModelsLoading = false.obs;
  final RxBool isSavingLaptop = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = Get.find<ThemeService>().isDarkMode.value;
    _fetchUserProfile();
    _fetchMyLaptops();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final session = Get.find<SessionService>();
      final token = session.accessToken;
      if (token == null || token.isEmpty) return;

      // Fetch user info and existing request in parallel
      final results = await Future.wait([
        _apiClient.getRequest('/users/me', bearerToken: token),
        _apiClient
            .getRequest('/requests/my-request', bearerToken: token)
            .catchError((_) => null),
      ]);

      // ── User profile ──
      final data = results[0];
      if (data is Map<String, dynamic>) {
        final first = (data['firstname'] as String? ?? '').trim();
        final last = (data['lastname'] as String? ?? '').trim();
        final fullName = [first, last].where((s) => s.isNotEmpty).join(' ');
        if (fullName.isNotEmpty) userName.value = fullName;

        final avatarUrl = data['profile_image_url'] as String?;
        if (avatarUrl != null && avatarUrl.isNotEmpty) {
          userAvatarUrl.value = avatarUrl;
        } else {
          userAvatarUrl.value = 'assets/images/norton_university.png';
        }

        final role = data['role'] as String? ?? 'user';
        userRole.value = role;
        isTechnicalRole.value = role == 'technical' || role == 'admin';
        userBadge.value = _roleToLabel(role);
      }

      // ── Pending request ──
      final requestData = results[1];
      if (!isTechnicalRole.value && requestData != null) {
        // /requests/my-request returns a single object (not a list)
        if (requestData is Map<String, dynamic>) {
          final status =
              (requestData['status']?.toString().toLowerCase()) ?? '';
          hasRequestedRole.value = status == 'pending' || status == '';
        }
      }
    } catch (e) {
      debugPrint('[ProfileController] Could not fetch user profile: $e');
    }
  }

  String _roleToLabel(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Administrator';
      case 'technical':
        return 'Technical Expert';
      case 'user':
        return 'User';
      default:
        return role.isNotEmpty ? role : 'Member';
    }
  }

  void toggleTheme(bool value) {
    Get.find<ThemeService>().toggleTheme();
    isDarkMode.value = Get.find<ThemeService>().isDarkMode.value;
  }

  void toggleLanguage(bool value) => isKhmerLanguage.value = value;

  // ─────────────────────── Laptop Model Methods ───────────────────────

  Future<void> _fetchMyLaptops() async {
    try {
      final session = Get.find<SessionService>();
      final token = session.accessToken;
      if (token == null || token.isEmpty) return;

      final response = await _apiClient.getRequest(
        '/my-laptops/',
        bearerToken: token,
      );
      if (response is Map<String, dynamic> && response['data'] is List) {
        myLaptops.value = List<Map<String, dynamic>>.from(
          (response['data'] as List).map((e) => Map<String, dynamic>.from(e)),
        );
      } else if (response is List) {
        myLaptops.value = List<Map<String, dynamic>>.from(
          response.map((e) => Map<String, dynamic>.from(e)),
        );
      }
    } catch (e) {
      debugPrint('[ProfileController] Could not fetch my laptops: $e');
    }
  }

  Future<void> _fetchLaptopBrands() async {
    try {
      isLaptopLoading.value = true;
      final response = await _apiClient.getRequest(
        '/laptop-brands/',
        queryParameters: {'limit': '100'},
      );
      List<dynamic> list = [];
      if (response is List) {
        list = response;
      } else if (response is Map<String, dynamic> && response['data'] is List) {
        list = response['data'] as List;
      }
      laptopBrands.value = List<Map<String, dynamic>>.from(
        list.map((e) => Map<String, dynamic>.from(e)),
      );
    } catch (e) {
      debugPrint('[ProfileController] Could not fetch laptop brands: $e');
    } finally {
      isLaptopLoading.value = false;
    }
  }

  Future<void> _fetchModelsForBrand(String brandId) async {
    try {
      isModelsLoading.value = true;
      laptopModels.clear();
      final response = await _apiClient.getRequest(
        '/laptop-models/',
        queryParameters: {'brand_id': brandId, 'limit': '100'},
      );
      List<dynamic> list = [];
      if (response is List) {
        list = response;
      } else if (response is Map<String, dynamic> && response['data'] is List) {
        list = response['data'] as List;
      }
      laptopModels.value = List<Map<String, dynamic>>.from(
        list.map((e) => Map<String, dynamic>.from(e)),
      );
    } catch (e) {
      debugPrint('[ProfileController] Could not fetch models: $e');
    } finally {
      isModelsLoading.value = false;
    }
  }

  Future<void> saveLaptopModel(String modelId, {String? nickname}) async {
    try {
      isSavingLaptop.value = true;
      final session = Get.find<SessionService>();
      await _apiClient.postJson(
        '/my-laptops/',
        body: {
          'laptop_model_id': modelId,
          if (nickname != null && nickname.isNotEmpty) 'nickname': nickname,
        },
        bearerToken: session.accessToken,
      );
      await _fetchMyLaptops();
      Get.back(); // close sheet
      Get.snackbar(
        'Laptop Saved!',
        'Your laptop model has been added to your profile.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.kGoogleGreen.withOpacity(0.95),
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        borderRadius: 16,
        icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Failed to Save',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        borderRadius: 16,
      );
    } finally {
      isSavingLaptop.value = false;
    }
  }

  Future<void> removeLaptop(String laptopId) async {
    try {
      final session = Get.find<SessionService>();
      await _deleteRequest('/my-laptops/$laptopId', session.accessToken);
      await _fetchMyLaptops();
      Get.snackbar(
        'Laptop Removed',
        'Removed from your profile.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.kAuthAccent.withOpacity(0.95),
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        borderRadius: 16,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      debugPrint('[ProfileController] Could not remove laptop: $e');
    }
  }

  Future<void> _deleteRequest(String path, String? token) async {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('${ApiConfig.baseUrl}$normalizedPath');
    final response = await http.delete(
      uri,
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode >= 300) {
      throw Exception('Delete failed: ${response.statusCode}');
    }
  }

  void showSetLaptopSheet(BuildContext context) {
    selectedBrand.value = null;
    laptopModels.clear();
    _fetchLaptopBrands();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.kBgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollCtrl) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColor.kAuthBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              Obx(() {
                final brand = selectedBrand.value;
                return Row(
                  children: [
                    if (brand != null)
                      GestureDetector(
                        onTap: () {
                          selectedBrand.value = null;
                          laptopModels.clear();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: AppColor.kAuthAccent,
                            size: 20,
                          ),
                        ),
                      ),
                    const Icon(
                      Icons.laptop_mac_rounded,
                      color: AppColor.kGoogleBlue,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppText(
                        brand == null ? 'Select Brand' : 'Select Model',
                        variant: AppTextVariant.title,
                        fontSize: 18,
                      ),
                    ),
                    if (brand != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.kGoogleBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: AppText(
                          brand['name'] ?? '',
                          variant: AppTextVariant.body,
                          color: AppColor.kGoogleBlue,
                          fontSize: 12,
                        ),
                      ),
                  ],
                );
              }),
              const SizedBox(height: 6),
              Obx(
                () => AppText(
                  selectedBrand.value == null
                      ? 'Choose your laptop brand first'
                      : 'Pick your exact laptop model',
                  variant: AppTextVariant.caption,
                  color: AppColor.kAuthTextSecondary,
                ),
              ),
              const SizedBox(height: 16),
              // List
              Expanded(
                child: Obx(() {
                  if (isLaptopLoading.value || isModelsLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColor.kAuthAccent,
                      ),
                    );
                  }

                  // Show brands or models
                  if (selectedBrand.value == null) {
                    if (laptopBrands.isEmpty) {
                      return Center(
                        child: AppText(
                          'No brands available',
                          variant: AppTextVariant.caption,
                          color: AppColor.kAuthTextSecondary,
                        ),
                      );
                    }
                    return GridView.builder(
                      controller: scrollCtrl,
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.85,
                          ),
                      itemCount: laptopBrands.length,
                      itemBuilder: (_, i) {
                        final brand = laptopBrands[i];

                        // Parse out the image URL. The backend might return 'localhost:8000' which won't load on real devices/emulators.
                        String? imageUrlStr = brand['brand_img_url']
                            ?.toString();
                        if (imageUrlStr != null && imageUrlStr.isNotEmpty) {
                          if (imageUrlStr.startsWith('http://localhost:8000')) {
                            imageUrlStr = imageUrlStr.replaceFirst(
                              'http://localhost:8000',
                              ApiConfig.baseUrl,
                            );
                          } else if (imageUrlStr.startsWith(
                            'http://127.0.0.1:8000',
                          )) {
                            imageUrlStr = imageUrlStr.replaceFirst(
                              'http://127.0.0.1:8000',
                              ApiConfig.baseUrl,
                            );
                          } else if (!imageUrlStr.startsWith('http')) {
                            // If it's totally relative like '/media/...'
                            imageUrlStr =
                                '${ApiConfig.baseUrl}${imageUrlStr.startsWith('/') ? imageUrlStr : '/$imageUrlStr'}';
                          }
                        }

                        return InkWell(
                          onTap: () {
                            selectedBrand.value = brand;
                            _fetchModelsForBrand(brand['id']);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.kAuthSurface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColor.kAuthBorder.withOpacity(0.5),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.kAuthBorder.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColor.kGoogleBlue.withOpacity(
                                      0.08,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  padding:
                                      imageUrlStr != null &&
                                          imageUrlStr.isNotEmpty
                                      ? const EdgeInsets.all(8)
                                      : EdgeInsets.zero,
                                  child:
                                      imageUrlStr != null &&
                                          imageUrlStr.isNotEmpty
                                      ? Image.network(
                                          imageUrlStr,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) => Icon(
                                            Icons.business_rounded,
                                            color: AppColor.kGoogleBlue,
                                            size: 24,
                                          ),
                                        )
                                      : Icon(
                                          Icons.business_rounded,
                                          color: AppColor.kGoogleBlue,
                                          size: 24,
                                        ),
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: AppText(
                                    brand['name'] ?? 'Unknown',
                                    variant: AppTextVariant.label,
                                    fontSize: 13,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  // Models list
                  if (laptopModels.isEmpty) {
                    return Center(
                      child: AppText(
                        'No models found for this brand',
                        variant: AppTextVariant.caption,
                        color: AppColor.kAuthTextSecondary,
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: scrollCtrl,
                    padding: const EdgeInsets.only(top: 8, bottom: 20),
                    itemCount: laptopModels.length,
                    itemBuilder: (_, i) {
                      final model = laptopModels[i];
                      final subtitle = [
                        if (model['cpu'] != null) model['cpu'],
                        if (model['gpu'] != null) model['gpu'],
                        if (model['release_year'] != null)
                          model['release_year'].toString(),
                      ].join(' • ');

                      // Check if already saved
                      final alreadySaved = myLaptops.any(
                        (l) => l['laptop_model_id'] == model['id'],
                      );

                      return Obx(() {
                        final saving = isSavingLaptop.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: alreadySaved
                                ? AppColor.kGoogleGreen.withOpacity(0.05)
                                : AppColor.kAuthSurface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: alreadySaved
                                  ? AppColor.kGoogleGreen.withOpacity(0.3)
                                  : AppColor.kAuthBorder.withOpacity(0.6),
                            ),
                            boxShadow: alreadySaved
                                ? []
                                : [
                                    BoxShadow(
                                      color: AppColor.kAuthBorder.withOpacity(
                                        0.2,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                          ),
                          child: InkWell(
                            onTap: alreadySaved || saving
                                ? null
                                : () => saveLaptopModel(model['id']),
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: alreadySaved
                                          ? AppColor.kGoogleGreen.withOpacity(
                                              0.15,
                                            )
                                          : AppColor.kAuthAccent.withOpacity(
                                              0.1,
                                            ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      alreadySaved
                                          ? Icons.check_circle_rounded
                                          : Icons.laptop_chromebook_rounded,
                                      color: alreadySaved
                                          ? AppColor.kGoogleGreen
                                          : AppColor.kAuthAccent,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          model['name'] ?? 'Unknown Model',
                                          variant: AppTextVariant.title,
                                          color: AppColor.kAuthTextPrimary,
                                          fontSize: 15,
                                        ),
                                        if (subtitle.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          AppText(
                                            subtitle,
                                            variant: AppTextVariant.caption,
                                            fontSize: 12,
                                            color: AppColor.kAuthTextSecondary,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  if (saving)
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColor.kAuthAccent,
                                      ),
                                    )
                                  else if (alreadySaved)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColor.kGoogleGreen,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const AppText(
                                        'Saved',
                                        variant: AppTextVariant.label,
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    )
                                  else
                                    Icon(
                                      Icons.add_circle_rounded,
                                      color: AppColor.kAuthAccent,
                                      size: 26,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showRequestRoleSheet(BuildContext context) {
    // Pre-fill phone from profile if available
    shopPhoneCtrl.clear();
    shopNameCtrl.clear();
    shopAddressCtrl.clear();
    shopReasonCtrl.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.kBgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColor.kAuthBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Row(
                children: [
                  Icon(
                    Icons.storefront_rounded,
                    color: AppColor.kGoogleBlue,
                    size: 24,
                  ),
                  SizedBox(width: 10),
                  AppText(
                    'Request Technical Role',
                    variant: AppTextVariant.title,
                    fontSize: 18,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AppText(
                'Tell us about your shop. Our team will review and approve within 24 hours.',
                variant: AppTextVariant.caption,
                color: AppColor.kAuthTextSecondary,
              ),
              const SizedBox(height: 24),
              _sheetField(
                label: 'Shop Name',
                ctrl: shopNameCtrl,
                hint: 'e.g. Gold One Computer',
              ),
              const SizedBox(height: 16),
              _sheetField(
                label: 'Shop Address',
                ctrl: shopAddressCtrl,
                hint: 'e.g. Phnom Penh, Street 271',
              ),
              const SizedBox(height: 16),
              _sheetField(
                label: 'Phone Number',
                ctrl: shopPhoneCtrl,
                hint: 'e.g. 012 345 678',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _sheetField(
                label: 'Reason',
                ctrl: shopReasonCtrl,
                hint: 'Why do you want to sell parts on HCPH?',
                maxLines: 3,
              ),
              const SizedBox(height: 28),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: isRequestLoading.value
                        ? null
                        : () => _submitRoleRequest(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.kGoogleBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: isRequestLoading.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const AppText(
                            'Submit Request',
                            variant: AppTextVariant.title,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetField({
    required String label,
    required TextEditingController ctrl,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: AppText(
            label,
            variant: AppTextVariant.label,
            color: AppColor.kAuthTextSecondary,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColor.kAuthSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColor.kAuthBorder.withOpacity(0.6)),
          ),
          child: TextField(
            controller: ctrl,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: TextStyle(
              color: AppColor.kNavPrimaryText,
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColor.kAuthTextSecondary,
                fontSize: 13,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitRoleRequest(BuildContext sheetCtx) async {
    if (shopNameCtrl.text.trim().isEmpty ||
        shopAddressCtrl.text.trim().isEmpty ||
        shopPhoneCtrl.text.trim().isEmpty ||
        shopReasonCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Missing Fields',
        'Please fill in all fields.',
        backgroundColor: Colors.orange.withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
      );
      return;
    }

    isRequestLoading.value = true;
    try {
      final session = Get.find<SessionService>();
      await _apiClient.postJson(
        '/requests/',
        body: {
          'shop_name': shopNameCtrl.text.trim(),
          'shop_address': shopAddressCtrl.text.trim(),
          'phone': shopPhoneCtrl.text.trim(),
          'reason': shopReasonCtrl.text.trim(),
        },
        bearerToken: session.accessToken,
      );

      Get.back(); // close sheet
      hasRequestedRole.value = true;
      Get.snackbar(
        'Request Submitted!',
        'Our team will review your shop application within 24 hours.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.kGoogleBlue.withOpacity(0.95),
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        borderRadius: 16,
        icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Submission Failed',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        borderRadius: 16,
      );
    } finally {
      isRequestLoading.value = false;
    }
  }

  void logout() {
    try {
      Get.find<MainNavController>().logout();
    } catch (_) {
      Get.offAllNamed('/sign-in');
    }
  }

  @override
  void onClose() {
    shopNameCtrl.dispose();
    shopAddressCtrl.dispose();
    shopPhoneCtrl.dispose();
    shopReasonCtrl.dispose();
    super.onClose();
  }
}
