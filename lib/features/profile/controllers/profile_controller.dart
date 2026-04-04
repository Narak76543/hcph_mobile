import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_assgn/core/network/api_client.dart';
import 'package:school_assgn/core/network/api_config.dart';
import 'package:school_assgn/core/network/api_exception.dart';
import 'package:school_assgn/core/session/session_service.dart';
import 'package:school_assgn/features/home/controllers/home_controller.dart';
import 'package:school_assgn/features/home/models/home_models.dart';
import 'package:school_assgn/features/main_nav/controllers/main_nav_controller.dart';
import 'package:school_assgn/widget/under_construction_view.dart';
import 'package:school_assgn/features/profile/views/laptop_detail_view.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';
import 'package:school_assgn/features/profile/views/manual_laptop_entry_view.dart';
import 'package:school_assgn/core/theme/theme_service.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:geolocator/geolocator.dart';

class ProfileController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final RxString userName = 'Sarat Narak'.obs;
  final RxString userBadge = 'Member'.obs;
  final RxString userRole = 'technical'.obs;
  final RxString userAvatarUrl = 'assets/images/norton_university.png'.obs;
  final Rx<String?> selectedShopImage = Rx<String?>(null);

  final RxString userRoleIcon = 'assets/images/user.png'.obs;
  final Rx<Color> userRoleColor = AppColor.kGoogleBlue.obs;
  final RxBool isTechnicalRole = false.obs;
  final RxInt shopViews = 0.obs;
  final RxBool hasRequestedRole = false.obs;

  // Shop Profile Data
  final RxString shopId = ''.obs;
  final RxString shopName = 'My Shop'.obs;
  final RxString shopAddress = ''.obs;
  final RxString shopPhone = ''.obs;
  final RxString shopTelegram = ''.obs;
  final RxString shopImageUrl = ''.obs;

  // Detailed Address Fields
  final RxString shopProvince = ''.obs;
  final RxString shopDistrict = ''.obs;
  final RxString shopAddrDetail = ''.obs;
  final RxString shopGMapUrl = ''.obs;
  final RxList<PostModel> myListings = <PostModel>[].obs;
  final RxBool isListingsLoading = false.obs;

  // Settings
  final RxBool isDarkMode = false.obs;
  final RxBool isKhmerLanguage = false.obs;

  // Request form controllers (kept here so the sheet is stateless)
  final shopNameCtrl = TextEditingController();
  final shopAddressCtrl = TextEditingController(); // Legacy or summary
  final shopPhoneCtrl = TextEditingController();
  final shopTelegramCtrl = TextEditingController();
  final shopReasonCtrl = TextEditingController();

  final shopProvinceCtrl = TextEditingController();
  final shopDistrictCtrl = TextEditingController();
  final shopAddrDetailCtrl = TextEditingController();
  final shopGMapUrlCtrl = TextEditingController();
  final RxBool isRequestLoading = false.obs;
  final RxBool isShopUpdating = false.obs;
  final RxBool isLocationLoading = false.obs;

  // --- Post Hardware Basic Controllers ---
  final hardwareBrandCtrl = TextEditingController();
  final hardwareModelCtrl = TextEditingController();
  final hardwarePriceCtrl = TextEditingController();

  // --- RAM Spec Controllers ---
  final hardwareRamTypeCtrl = TextEditingController();
  final hardwareRamCapacityGbCtrl = TextEditingController();
  final hardwareRamBusMhzCtrl = TextEditingController();
  final hardwareRamFormFactorCtrl = TextEditingController();
  final hardwareRamLatencyCtrl = TextEditingController();

  final hardwareCpuCtrl = TextEditingController();
  final hardwareGpuCtrl = TextEditingController();
  final hardwareRamSlotsCtrl = TextEditingController();
  final hardwareMaxRamCtrl = TextEditingController();
  // --- SSD Spec Controllers ---
  final hardwareSsdTypeCtrl = TextEditingController();
  final hardwareSsdCapacityGbCtrl = TextEditingController();
  final hardwareSsdFormFactorCtrl = TextEditingController();
  final hardwareSsdInterfaceCtrl = TextEditingController();
  final hardwareSsdReadSpeedCtrl = TextEditingController();
  final hardwareSsdWriteSpeedCtrl = TextEditingController();

  // --- HDD Spec Controllers ---
  final hardwareHddCapacityGbCtrl = TextEditingController();
  final hardwareHddRpmCtrl = TextEditingController();
  final hardwareHddFormFactorCtrl = TextEditingController();
  final hardwareHddCacheMbCtrl = TextEditingController();

  final hardwareHddBayCtrl =
      TextEditingController(); // still for laptop context
  final hardwareScreenSizeCtrl = TextEditingController();
  final hardwareResolutionCtrl = TextEditingController();
  final hardwareRefreshRateCtrl = TextEditingController();

  // --- Thermal Paste Specs ---
  final hardwareThermalConductivityCtrl = TextEditingController();
  final hardwareThermalTypeCtrl = TextEditingController();
  final hardwareThermalWeightCtrl = TextEditingController();

  // --- Battery Spec Controllers ---
  final hardwareBatteryWhCtrl = TextEditingController();
  final hardwareBatteryMahCtrl = TextEditingController();
  final hardwareBatteryCellsCtrl = TextEditingController();
  final hardwareBatteryVoltageCtrl = TextEditingController();
  final hardwareBatteryTypeCtrl = TextEditingController();
  final hardwareBatteryConnectorCtrl = TextEditingController();

  // --- Display Spec Controllers ---
  final hardwareDisplaySizeInchCtrl = TextEditingController();
  final hardwareDisplayResolutionCtrl = TextEditingController();
  final hardwareDisplayRefreshRateCtrl = TextEditingController();
  final hardwareDisplayPanelTypeCtrl = TextEditingController();
  final hardwareDisplayConnectorPinCtrl = TextEditingController();
  final hardwareDisplayBrightnessNitCtrl = TextEditingController();

  // --- Cooling Fan Spec Controllers ---
  final hardwareFanSizeMmCtrl = TextEditingController();
  final hardwareFanConnectorCtrl = TextEditingController();
  final hardwareFanMaxRpmCtrl = TextEditingController();
  final hardwareFanTypeCtrl = TextEditingController();

  // --- Charger Spec Controllers ---
  final hardwareChargerWattageCtrl = TextEditingController();
  final hardwareChargerVoltageCtrl = TextEditingController();
  final hardwareChargerConnectorCtrl = TextEditingController();
  final hardwareChargerStandardCtrl = TextEditingController();

  final RxString selectedCategoryIdForPost = ''.obs;
  final RxBool isPostingHardware = false.obs;
  final Rx<String?> selectedHardwareImage = Rx<String?>(null);

  // --- Manual Laptop Entry Controllers ---
  final manualBrandCtrl = TextEditingController();
  final manualModelCtrl = TextEditingController();
  final manualCpuCtrl = TextEditingController();
  final manualRamSlotsCtrl = TextEditingController();
  final manualRamTypeCtrl = TextEditingController();
  final manualMaxRamCtrl = TextEditingController();
  final manualRamBaseCtrl = TextEditingController();
  final manualSsdSlotsCtrl = TextEditingController();
  final manualSsdInterfaceCtrl = TextEditingController();
  final manualSsdFormFactorCtrl = TextEditingController();
  final manualHasHddBay = false.obs;
  final manualDisplaySizeCtrl = TextEditingController();
  final manualDisplayResCtrl = TextEditingController();
  final RxBool isSavingManualLaptop = false.obs;
  final RxString manualBrandId = ''.obs;
  final RxString manualCpuBrand =
      'Intel'.obs; // Default: Intel, AMD, Xeon, Other

  // --- Discrete Selectors for Manual Specs ---
  final RxString manualRamType = 'DDR4'.obs;
  final RxString manualRamSlots = '2'.obs;
  final RxString manualRamBase = '8'.obs;
  final RxString manualMaxRam = '16'.obs;
  final RxString manualSsdSlots = '1'.obs;
  final RxString manualSsdInterface = 'Pcie/NVMe'.obs;
  final RxString manualAddHdd = 'No'.obs;
  final RxString manualDisplaySizeRange = '15" - 15.9"'.obs;

  final RxList<Map<String, dynamic>> filteredManualModels =
      <Map<String, dynamic>>[].obs;

  Future<void> pickHardwareImage() async {
    final picker = image_picker.ImagePicker();
    final image = await picker.pickImage(
      source: image_picker.ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      selectedHardwareImage.value = image.path;
    }
  }

  Future<void> pickShopImage() async {
    final picker = image_picker.ImagePicker();
    final image = await picker.pickImage(
      source: image_picker.ImageSource.gallery,
    );
    if (image != null) {
      selectedShopImage.value = image.path;
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      isLocationLoading.value = true;
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied.';
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final url =
          'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
      shopGMapUrlCtrl.text = url;

      Get.snackbar(
        'Location Captured',
        'Your current coordinates have been mapped successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.kGoogleBlue.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        borderRadius: 16,
        icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        'Location Error',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } finally {
      isLocationLoading.value = false;
    }
  }

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

    // Model suggestions listener
    manualModelCtrl.addListener(() {
      final query = manualModelCtrl.text.toLowerCase().trim();
      if (query.isEmpty) {
        filteredManualModels.clear();
      } else {
        filteredManualModels.value = laptopModels
            .where(
              (m) => (m['name'] ?? '').toString().toLowerCase().contains(query),
            )
            .take(5)
            .toList();
      }
    });

    // When brand pick changes, fetch models for suggestions
    ever(manualBrandId, (String id) {
      if (id.isNotEmpty) {
        fetchModelsForBrand(id);
      } else {
        laptopModels.clear();
      }
    });
  }

  Future<void> refreshProfile() async {
    await Future.wait([
      _fetchUserProfile(),
      _fetchMyLaptops(),
      _fetchMyShopParts(),
    ]);
  }

  Future<void> _fetchUserProfile() async {
    try {
      final session = Get.find<SessionService>();
      final token = session.accessToken;
      if (token == null || token.isEmpty) return;

      // Fetch user info, request and shop in parallel
      final results = await Future.wait([
        _apiClient.getRequest('/users/me', bearerToken: token),
        _apiClient
            .getRequest('/requests/my-request', bearerToken: token)
            .catchError((_) => null),
        _apiClient.getRequest('/shops/my-shop', bearerToken: token).catchError((
          e,
        ) {
          debugPrint('[ProfileController] Shop fetch error: $e');
          return null;
        }),
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

        final role = (data['role'] as String? ?? 'user').toUpperCase();
        userRole.value = role;
        isTechnicalRole.value = role == 'TECHNICAL' || role == 'ADMIN';
        userBadge.value = _roleToLabel(role);
        userRoleIcon.value = _roleToIcon(role);
        userRoleColor.value = _roleToColor(role);
      }

      // ── Pending request ──
      final requestData = results[1];
      if (requestData != null && requestData is Map<String, dynamic>) {
        final status = (requestData['status']?.toString().toUpperCase()) ?? '';

        // If approved, update shop profile info
        if (status == 'APPROVED') {
          shopName.value = requestData['shop_name'] ?? 'My Shop';
          shopAddress.value = requestData['shop_address'] ?? '';
          shopPhone.value = requestData['phone'] ?? '';
          isTechnicalRole.value = true; // Force tech role if approved
        }

        if (!isTechnicalRole.value) {
          hasRequestedRole.value = status == 'PENDING' || status == '';
        }
      }

      // ── Shop Data (TBL_Shop) ──
      final shopData = results[2];
      if (shopData != null && shopData is Map<String, dynamic>) {
        shopId.value = shopData['id']?.toString() ?? '';
        shopName.value = shopData['name'] ?? shopName.value;
        shopPhone.value = shopData['phone'] ?? '';
        shopTelegram.value = shopData['telegram_handle'] ?? '';
        shopImageUrl.value = shopData['shop_pro_img_url'] ?? '';

        // Detailed Address
        shopProvince.value = shopData['province'] ?? '';
        shopDistrict.value = shopData['district'] ?? '';
        shopAddrDetail.value = shopData['detail'] ?? '';
        shopGMapUrl.value = shopData['google_maps_url'] ?? '';

        // Update summary address
        shopAddress.value = [
          shopAddrDetail.value,
          shopDistrict.value,
          shopProvince.value,
        ].where((s) => s.isNotEmpty).join(', ');
        if (shopAddress.value.isEmpty && shopData['address'] != null) {
          shopAddress.value = shopData['address'];
        }

        isTechnicalRole.value =
            true; // If we have shop data, user is tech/admin

        // Fetch parts for this shop
        _fetchMyShopParts();
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

  String _roleToIcon(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'assets/images/protection.png';
      case 'technical':
        return 'assets/images/screw-driver.png';
      case 'user':
      default:
        return 'assets/images/user.png';
    }
  }

  Color _roleToColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return AppColor.kGoogleBlue;
      case 'technical':
        return AppColor.kGoogleGreen;
      case 'user':
      default:
        return AppColor.kGoogleBlue; // Professional blue for standard members
    }
  }

  void toggleTheme(bool value) {
    Get.find<ThemeService>().toggleTheme();
    isDarkMode.value = Get.find<ThemeService>().isDarkMode.value;
  }

  void toggleLanguage(bool value) => isKhmerLanguage.value = value;

  // ─────────────────────── Laptop Model Methods ───────────────────────

  Future<void> _fetchMyShopParts() async {
    if (shopId.value.isEmpty || shopId.value == 'test-shop-id') return;

    try {
      isListingsLoading.value = true;
      final session = Get.find<SessionService>();
      final token = session.accessToken;

      // Fetch listings for this shop so we show price + shop meta
      final response = await _apiClient.getRequest(
        '/listings/',
        queryParameters: {'shop_id': shopId.value, 'limit': '50'},
        bearerToken: token,
      );

      List<dynamic> list = [];
      if (response is List) {
        list = response;
      } else if (response is Map<String, dynamic> && response['data'] is List) {
        list = response['data'] as List;
      }

      myListings.value = list
          .map((e) {
            final model = PostModel.fromJson(Map<String, dynamic>.from(e));

            // Normalize image URL
            String imageUrl = model.imageUrl;
            if (imageUrl.isNotEmpty) {
              if (imageUrl.startsWith('http://localhost:8000')) {
                imageUrl = imageUrl.replaceFirst(
                  'http://localhost:8000',
                  ApiConfig.baseUrl,
                );
              } else if (imageUrl.startsWith('http://127.0.0.1:8000')) {
                imageUrl = imageUrl.replaceFirst(
                  'http://127.0.0.1:8000',
                  ApiConfig.baseUrl,
                );
              } else if (!imageUrl.startsWith('http')) {
                imageUrl =
                    '${ApiConfig.baseUrl}${imageUrl.startsWith('/') ? imageUrl : '/$imageUrl'}';
              }
            }

            return PostModel(
              id: model.id,
              partName: model.partName,
              brand: model.brand,
              model: model.model,
              compatibleModel: model.compatibleModel,
              shopName: model.shopName,
              postedBy: model.postedBy,
              ownerFullName: model.ownerFullName,
              ownerUserId: model.ownerUserId,
              price: model.price,
              imageUrl: imageUrl,
              isVerified: model.isVerified,
            );
          })
          .cast<PostModel>()
          .toList();
    } catch (e) {
      debugPrint('[ProfileController] Could not fetch shop parts: $e');
    } finally {
      isListingsLoading.value = false;
    }
  }

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

  Future<void> fetchLaptopBrands() async {
    try {
      isLaptopLoading.value = true;
      final session = Get.find<SessionService>();
      final response = await _apiClient.getRequest(
        '/laptop-brands/',
        queryParameters: {'limit': '100'},
        bearerToken: session.accessToken,
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

  Future<void> fetchModelsForBrand(String brandId) async {
    try {
      isModelsLoading.value = true;
      laptopModels.clear();
      final session = Get.find<SessionService>();
      final response = await _apiClient.getRequest(
        '/laptop-models/',
        queryParameters: {'brand_id': brandId, 'limit': '100'},
        bearerToken: session.accessToken,
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

  Future<void> saveManualLaptop() async {
    try {
      isSavingManualLaptop.value = true;
      final session = Get.find<SessionService>();
      final token = session.accessToken;

      if (manualBrandId.value.isEmpty || manualModelCtrl.text.trim().isEmpty) {
        throw Exception('Brand and Model name are required.');
      }

      // Step 1: Create a Laptop Model
      final String modelName = manualModelCtrl.text.trim();
      final String slug = modelName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
      
      final Map<String, dynamic> modelPayload = {
        'brand_id': manualBrandId.value,
        'name': modelName,
        'slug': slug,
        'cpu': '${manualCpuBrand.value} ${manualCpuCtrl.text.trim()}',
        'form_factor': 'Laptop', // Default field for schema
      };

      debugPrint('[ProfileController] Step 1: POST /laptop-models/');
      final modelResponse = await _apiClient.postJson(
        '/laptop-models/',
        body: modelPayload,
        bearerToken: token,
      );

      final String modelId = modelResponse['id']?.toString() ?? '';
      if (modelId.isEmpty) {
        throw Exception('Failed to create laptop model entry.');
      }

      // Step 2: Create Specifications for that model
      final Map<String, dynamic> specPayload = {
        'model_id': modelId,
        'ram_slots': int.tryParse(manualRamSlots.value) ?? 1,
        'ram_type': manualRamType.value,
        'max_ram_gg': int.tryParse(manualMaxRam.value) ?? 16, // Field name from backend schema
        'ram_base_gb': int.tryParse(manualRamBase.value) ?? 8,
        'ssd_slots': int.tryParse(manualSsdSlots.value) ?? 1,
        'ssd_interface': manualSsdInterface.value,
        'has_hdd_bay': manualAddHdd.value == 'Yes',
        'display_size': manualDisplaySizeRange.value,
        'display_resolution': manualDisplayResCtrl.text.trim(),
      };

      debugPrint('[ProfileController] Step 2: POST /laptop-specs/');
      await _apiClient.postJson(
        '/laptop-specs/',
        body: specPayload,
        bearerToken: token,
      );

      // Step 3: Link the model to the User (My Laptops)
      debugPrint('[ProfileController] Step 3: POST /my-laptops/');
      await _apiClient.postJson(
        '/my-laptops/',
        body: {'laptop_model_id': modelId},
        bearerToken: token,
      );

      // Final Step: Refresh the profile to reflect changes
      await _fetchMyLaptops();
      
      Get.back(); // close view
      Get.snackbar(
        'Laptop Profile Created',
        'Your custom hardware configuration has been successfully saved to the database.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.kGoogleBlue,
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        borderRadius: 16,
        icon: const Icon(Icons.cloud_done_rounded, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      debugPrint('[ProfileController] Manual save error: $e');
      Get.snackbar(
        'Database Sync Failed',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isSavingManualLaptop.value = false;
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
        backgroundColor: AppColor.kGoogleGreen.withValues(alpha: 0.95),
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
        backgroundColor: Colors.red.withValues(alpha: 0.9),
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
        backgroundColor: AppColor.kAuthAccent.withValues(alpha: 0.95),
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
    fetchLaptopBrands();

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
                          color: AppColor.kGoogleBlue.withValues(alpha: 0.1),
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
                    return Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
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
                              // ... (keep existing Brand item code)
                              String? imageUrlStr = brand['brand_img_url']
                                  ?.toString();
                              if (imageUrlStr != null &&
                                  imageUrlStr.isNotEmpty) {
                                if (imageUrlStr.startsWith(
                                  'http://localhost:8000',
                                )) {
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
                                  imageUrlStr =
                                      '${ApiConfig.baseUrl}${imageUrlStr.startsWith('/') ? imageUrlStr : '/$imageUrlStr'}';
                                }
                              }

                              return InkWell(
                                onTap: () {
                                  selectedBrand.value = brand;
                                  fetchModelsForBrand(brand['id']?.toString() ?? '');
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.kAuthSurface,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColor.kAuthBorder.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColor.kAuthBorder.withValues(
                                          alpha: 0.3,
                                        ),
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
                                          color: AppColor.kGoogleBlue
                                              .withValues(alpha: 0.08),
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
                                                errorBuilder: (_, _, _) => Icon(
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
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildManualEntryOption(ctx),
                      ],
                    );
                  }

                  // Models list
                  if (laptopModels.isEmpty) {
                    return Column(
                      children: [
                        const SizedBox(height: 40),
                        Icon(
                          Icons.search_off_rounded,
                          color: AppColor.kAuthTextSecondary.withValues(
                            alpha: 0.3,
                          ),
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        AppText(
                          'No models found for this brand',
                          variant: AppTextVariant.caption,
                          color: AppColor.kAuthTextSecondary,
                        ),
                        const Spacer(),
                        _buildManualEntryOption(ctx),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
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

                            final alreadySaved = myLaptops.any(
                              (l) => l['laptop_model_id'] == model['id'],
                            );

                            return Obx(() {
                              final saving = isSavingLaptop.value;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: alreadySaved
                                      ? AppColor.kGoogleGreen.withValues(
                                          alpha: 0.05,
                                        )
                                      : AppColor.kAuthSurface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: alreadySaved
                                        ? AppColor.kGoogleGreen.withValues(
                                            alpha: 0.3,
                                          )
                                        : AppColor.kAuthBorder.withValues(
                                            alpha: 0.6,
                                          ),
                                  ),
                                  boxShadow: alreadySaved
                                      ? []
                                      : [
                                          BoxShadow(
                                            color: AppColor.kAuthBorder
                                                .withValues(alpha: 0.2),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    await fetchSpecsForModel(model['id']);
                                    if (selectedModelSpec.value != null) {
                                      Get.to(
                                        () => LaptopDetailView(
                                          modelName: model['name'] ?? 'Detail',
                                          spec: selectedModelSpec.value!,
                                        ),
                                      );
                                    } else if (!isSpecsLoading.value) {
                                      Get.snackbar(
                                        'Spec not found',
                                        "Currently we don't have specifications for this model.",
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    }
                                  },
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
                                                ? AppColor.kGoogleGreen
                                                      .withValues(alpha: 0.15)
                                                : AppColor.kAuthAccent
                                                      .withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: Icon(
                                            alreadySaved
                                                ? Icons.check_circle_rounded
                                                : Icons
                                                      .laptop_chromebook_rounded,
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
                                                model['name'] ??
                                                    'Unknown Model',
                                                variant: AppTextVariant.title,
                                                fontSize: 15,
                                              ),
                                              if (subtitle.isNotEmpty) ...[
                                                const SizedBox(height: 4),
                                                AppText(
                                                  subtitle,
                                                  variant:
                                                      AppTextVariant.caption,
                                                  fontSize: 12,
                                                ),
                                              ],
                                              GestureDetector(
                                                onTap: () async {
                                                  await fetchSpecsForModel(
                                                    model['id'],
                                                  );
                                                  if (selectedModelSpec.value !=
                                                      null) {
                                                    Get.to(
                                                      () => LaptopDetailView(
                                                        modelName:
                                                            model['name'] ??
                                                            'Detail',
                                                        spec: selectedModelSpec
                                                            .value!,
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 8,
                                                      ),
                                                  child: AppText(
                                                    'View Hardware Detail ›',
                                                    variant:
                                                        AppTextVariant.label,
                                                    color: AppColor.kGoogleBlue,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (saving)
                                          const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        else if (alreadySaved)
                                          _buildSavedBadge()
                                        else
                                          IconButton(
                                            onPressed: () =>
                                                saveLaptopModel(model['id']),
                                            icon: Icon(
                                              Icons.add_circle_rounded,
                                              color: AppColor.kAuthAccent,
                                              size: 28,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildManualEntryOption(ctx),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManualEntryOption(BuildContext context) {
    return Obx(() {
      if (!isTechnicalRole.value) return const SizedBox.shrink();

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.kGoogleBlue.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.kGoogleBlue.withValues(alpha: 0.2)),
        ),
        child: InkWell(
          onTap: () {
            Get.back(); // close current sheet
            showManualLaptopEntry(context);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColor.kGoogleBlue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_note_rounded,
                    color: AppColor.kGoogleBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText(
                        "Can't find your model?",
                        variant: AppTextVariant.title,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      AppText(
                        "Input details manually",
                        variant: AppTextVariant.caption,
                        color: AppColor.kGoogleBlue,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColor.kGoogleBlue,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      );
    });
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
              Row(
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
            border: Border.all(
              color: AppColor.kAuthBorder.withValues(alpha: 0.6),
            ),
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
        backgroundColor: Colors.orange.withValues(alpha: 0.9),
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
        backgroundColor: AppColor.kGoogleBlue.withValues(alpha: 0.95),
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
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        borderRadius: 16,
      );
    } finally {
      isRequestLoading.value = false;
    }
  }

  Future<void> createShopProfile() async {
    try {
      isShopUpdating.value = true;
      final session = Get.find<SessionService>();
      final token = session.accessToken;
      if (token == null) return;

      final fields = {
        'name': shopNameCtrl.text.trim(),
        'phone': shopPhoneCtrl.text.trim(),
        'telegram_handle': shopTelegramCtrl.text.trim(),
        'province': shopProvinceCtrl.text.trim(),
        'district': shopDistrictCtrl.text.trim(),
        'detail': shopAddrDetailCtrl.text.trim(),
        'google_maps_url': shopGMapUrlCtrl.text.trim(),
      };

      final response = await _apiClient.postMultipart(
        '/shops/',
        fields: fields,
        fileFieldName: 'shop_pro_img', // or whatever your backend expects
        filePath: selectedShopImage.value,
        bearerToken: token,
      );

      if (response['id'] != null) {
        shopId.value = response['id'].toString();
        shopName.value = response['name'] ?? shopNameCtrl.text.trim();
        shopPhone.value = response['phone'] ?? shopPhoneCtrl.text.trim();
        shopTelegram.value =
            response['telegram_handle'] ?? shopTelegramCtrl.text.trim();

        shopProvince.value =
            response['province'] ?? shopProvinceCtrl.text.trim();
        shopDistrict.value =
            response['district'] ?? shopDistrictCtrl.text.trim();
        shopAddrDetail.value =
            response['detail'] ?? shopAddrDetailCtrl.text.trim();
        shopGMapUrl.value =
            response['google_maps_url'] ?? shopGMapUrlCtrl.text.trim();

        shopAddress.value = [
          shopAddrDetail.value,
          shopDistrict.value,
          shopProvince.value,
        ].where((s) => s.isNotEmpty).join(', ');

        shopImageUrl.value = response['shop_pro_img_url'] ?? '';
      }

      selectedShopImage.value = null; // Clear local picker
      Get.back(); // close sheet
      _showShopSuccessDialog();
    } catch (e) {
      Get.snackbar(
        'Creation Failed',
        e.toString().replaceFirst('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isShopUpdating.value = false;
    }
  }

  Future<void> updateShopProfile() async {
    try {
      isShopUpdating.value = true;
      final session = Get.find<SessionService>();
      final token = session.accessToken;
      if (token == null) return;

      final fields = {
        'name': shopNameCtrl.text.trim(),
        'phone': shopPhoneCtrl.text.trim(),
        'telegram_handle': shopTelegramCtrl.text.trim(),
        'province': shopProvinceCtrl.text.trim(),
        'district': shopDistrictCtrl.text.trim(),
        'detail': shopAddrDetailCtrl.text.trim(),
        'google_maps_url': shopGMapUrlCtrl.text.trim(),
      };

      // Use patchMultipart for updates
      final response = await _apiClient.patchMultipart(
        '/shops/me',
        fields: fields,
        fileFieldName: 'shop_pro_img',
        filePath: selectedShopImage.value,
        bearerToken: token,
      );

      // Update local state
      shopName.value = response['name'] ?? shopNameCtrl.text.trim();
      shopPhone.value = response['phone'] ?? shopPhoneCtrl.text.trim();
      shopTelegram.value =
          response['telegram_handle'] ?? shopTelegramCtrl.text.trim();

      shopProvince.value = response['province'] ?? shopProvinceCtrl.text.trim();
      shopDistrict.value = response['district'] ?? shopDistrictCtrl.text.trim();
      shopAddrDetail.value =
          response['detail'] ?? shopAddrDetailCtrl.text.trim();
      shopGMapUrl.value =
          response['google_maps_url'] ?? shopGMapUrlCtrl.text.trim();

      shopAddress.value = [
        shopAddrDetail.value,
        shopDistrict.value,
        shopProvince.value,
      ].where((s) => s.isNotEmpty).join(', ');

      if (response['shop_pro_img_url'] != null) {
        shopImageUrl.value = response['shop_pro_img_url'];
      }

      selectedShopImage.value = null;
      Get.snackbar(
        'Success',
        'Shop profile updated securely.',
        backgroundColor: AppColor.kGoogleGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
        borderRadius: 16,
      );
    } catch (e) {
      Get.snackbar(
        'Update Failed',
        e.toString().replaceFirst('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isShopUpdating.value = false;
    }
  }

  void logout() {
    try {
      Get.find<MainNavController>().logout();
    } catch (_) {
      Get.offAllNamed('/sign-in');
    }
  }

  void clearManualEntryFields() {
    manualBrandCtrl.clear();
    manualModelCtrl.clear();
    manualCpuCtrl.clear();
    manualDisplayResCtrl.clear();
    manualBrandId.value = '';
    manualCpuBrand.value = 'Intel';
    manualRamType.value = 'DDR4';
    manualRamSlots.value = '2';
    manualRamBase.value = '8';
    manualMaxRam.value = '16';
    manualSsdSlots.value = '1';
    manualSsdInterface.value = 'Pcie/NVMe';
    manualAddHdd.value = 'No';
    manualDisplaySizeRange.value = '15" - 15.9"';
    filteredManualModels.clear();
  }

  void showManualLaptopEntry(BuildContext context) {
    clearManualEntryFields();
    if (laptopBrands.isEmpty) {
      fetchLaptopBrands();
    }
    Get.to(() => const ManualLaptopEntryView());
  }

  @override
  void onClose() {
    shopNameCtrl.dispose();
    shopAddressCtrl.dispose();
    shopPhoneCtrl.dispose();
    shopTelegramCtrl.dispose();
    shopProvinceCtrl.dispose();
    shopDistrictCtrl.dispose();
    shopAddrDetailCtrl.dispose();
    shopGMapUrlCtrl.dispose();
    shopReasonCtrl.dispose();
    hardwareBrandCtrl.dispose();
    hardwareModelCtrl.dispose();
    hardwarePriceCtrl.dispose();
    hardwareCpuCtrl.dispose();
    hardwareGpuCtrl.dispose();
    hardwareRamTypeCtrl.dispose();
    hardwareRamCapacityGbCtrl.dispose(); // Fixed name
    hardwareRamBusMhzCtrl.dispose(); // Added missing
    hardwareRamFormFactorCtrl.dispose(); // Added missing
    hardwareRamLatencyCtrl.dispose(); // Added missing
    hardwareRamSlotsCtrl.dispose();
    hardwareMaxRamCtrl.dispose();
    hardwareSsdTypeCtrl.dispose();
    hardwareSsdCapacityGbCtrl.dispose();
    hardwareSsdFormFactorCtrl.dispose();
    hardwareSsdInterfaceCtrl.dispose();
    hardwareSsdReadSpeedCtrl.dispose();
    hardwareSsdWriteSpeedCtrl.dispose();
    hardwareHddCapacityGbCtrl.dispose();
    hardwareHddRpmCtrl.dispose();
    hardwareHddFormFactorCtrl.dispose();
    hardwareHddCacheMbCtrl.dispose();
    hardwareHddBayCtrl.dispose();
    hardwareDisplaySizeInchCtrl.dispose();
    hardwareDisplayResolutionCtrl.dispose();
    hardwareDisplayRefreshRateCtrl.dispose();
    hardwareDisplayPanelTypeCtrl.dispose();
    hardwareDisplayConnectorPinCtrl.dispose();
    hardwareDisplayBrightnessNitCtrl.dispose();
    hardwareThermalConductivityCtrl.dispose();
    hardwareThermalTypeCtrl.dispose();
    hardwareThermalWeightCtrl.dispose();
    hardwareBatteryWhCtrl.dispose();
    hardwareBatteryMahCtrl.dispose();
    hardwareBatteryCellsCtrl.dispose();
    hardwareBatteryVoltageCtrl.dispose();
    hardwareBatteryTypeCtrl.dispose();
    hardwareBatteryConnectorCtrl.dispose();
    hardwareChargerWattageCtrl.dispose();
    hardwareChargerVoltageCtrl.dispose();
    hardwareChargerConnectorCtrl.dispose();
    hardwareChargerStandardCtrl.dispose();
    hardwareFanSizeMmCtrl.dispose();
    hardwareFanConnectorCtrl.dispose();
    hardwareFanMaxRpmCtrl.dispose();
    hardwareFanTypeCtrl.dispose();
    manualBrandCtrl.dispose();
    manualModelCtrl.dispose();
    manualCpuCtrl.dispose();
    manualRamSlotsCtrl.dispose();
    manualRamTypeCtrl.dispose();
    manualMaxRamCtrl.dispose();
    manualRamBaseCtrl.dispose();
    manualSsdSlotsCtrl.dispose();
    manualSsdInterfaceCtrl.dispose();
    manualSsdFormFactorCtrl.dispose();
    manualDisplaySizeCtrl.dispose();
    manualDisplayResCtrl.dispose();
    super.onClose();
  }

  CategoryModel get selectedPostCategory {
    final homeCtrl = Get.find<HomeController>();
    return homeCtrl.categories.firstWhere(
      (c) => c.id == selectedCategoryIdForPost.value,
      orElse: () => CategoryModel(id: '0', name: 'Other', slug: 'other'),
    );
  }

  bool categoryMatches(CategoryModel category, List<String> keywords) {
    final haystack = '${category.name} ${category.slug}'.toLowerCase();
    return keywords.any(haystack.contains);
  }

  int get filledHardwareSpecCount {
    final controllers = [
      hardwareCpuCtrl,
      hardwareGpuCtrl,
      hardwareRamTypeCtrl,
      hardwareRamCapacityGbCtrl,
      hardwareRamBusMhzCtrl,
      hardwareRamFormFactorCtrl,
      hardwareRamLatencyCtrl,
      hardwareRamSlotsCtrl,
      hardwareMaxRamCtrl,
      hardwareSsdTypeCtrl,
      hardwareSsdCapacityGbCtrl,
      hardwareSsdFormFactorCtrl,
      hardwareSsdInterfaceCtrl,
      hardwareSsdReadSpeedCtrl,
      hardwareSsdWriteSpeedCtrl,
      hardwareHddCapacityGbCtrl,
      hardwareHddRpmCtrl,
      hardwareHddFormFactorCtrl,
      hardwareHddCacheMbCtrl,
      hardwareThermalConductivityCtrl,
      hardwareThermalTypeCtrl,
      hardwareThermalWeightCtrl,
      hardwareBatteryWhCtrl,
      hardwareBatteryMahCtrl,
      hardwareBatteryCellsCtrl,
      hardwareBatteryVoltageCtrl,
      hardwareBatteryTypeCtrl,
      hardwareBatteryConnectorCtrl,
      hardwareDisplaySizeInchCtrl,
      hardwareDisplayResolutionCtrl,
      hardwareDisplayRefreshRateCtrl,
      hardwareDisplayPanelTypeCtrl,
      hardwareDisplayConnectorPinCtrl,
      hardwareDisplayBrightnessNitCtrl,
      hardwareFanSizeMmCtrl,
      hardwareFanConnectorCtrl,
      hardwareFanMaxRpmCtrl,
      hardwareFanTypeCtrl,
      hardwareChargerWattageCtrl,
      hardwareChargerVoltageCtrl,
      hardwareChargerConnectorCtrl,
      hardwareChargerStandardCtrl,
    ];

    return controllers.where((ctrl) => ctrl.text.trim().isNotEmpty).length;
  }

  void _putSpec(
    Map<String, dynamic> specs,
    String key,
    TextEditingController controller,
  ) {
    final raw = controller.text.trim();
    if (raw.isEmpty) return;

    final intValue = int.tryParse(raw);
    if (intValue != null) {
      specs[key] = intValue;
      return;
    }

    final doubleValue = double.tryParse(raw);
    if (doubleValue != null) {
      specs[key] = doubleValue;
      return;
    }

    specs[key] = raw;
  }

  void _validateTechnicalForm(CategoryModel category) {
    if (selectedCategoryIdForPost.value.isEmpty) {
      throw 'Select a hardware category first.';
    }
    if (hardwareBrandCtrl.text.trim().isEmpty) {
      throw 'Brand is required.';
    }
    if (hardwareModelCtrl.text.trim().isEmpty) {
      throw 'Model name is required.';
    }
    if (hardwarePriceCtrl.text.trim().isEmpty) {
      throw 'Price is required.';
    }

    if (categoryMatches(category, ['ram', 'memory'])) {
      if (hardwareRamCapacityGbCtrl.text.trim().isEmpty) {
        throw 'RAM Capacity (GB) is required.';
      }
      if (hardwareRamTypeCtrl.text.trim().isEmpty) {
        throw 'RAM Type is required.';
      }
      if (hardwareRamBusMhzCtrl.text.trim().isEmpty) {
        throw 'RAM Bus Speed (MHz) is required.';
      }
      if (hardwareRamFormFactorCtrl.text.trim().isEmpty) {
        throw 'RAM Form Factor is required.';
      }
    }
  }

  Map<String, dynamic> _buildPartSpecs(CategoryModel category) {
    final specs = <String, dynamic>{};

    if (categoryMatches(category, ['cpu', 'gpu', 'motherboard'])) {
      _putSpec(specs, 'cpu_model', hardwareCpuCtrl);
      _putSpec(specs, 'gpu_model', hardwareGpuCtrl);
    }

    if (categoryMatches(category, ['ram', 'memory'])) {
      _putSpec(specs, 'capacity_gb', hardwareRamCapacityGbCtrl);
      _putSpec(specs, 'ram_type', hardwareRamTypeCtrl);
      _putSpec(specs, 'bus_mhz', hardwareRamBusMhzCtrl);
      _putSpec(specs, 'form_factor', hardwareRamFormFactorCtrl);
      _putSpec(specs, 'latency', hardwareRamLatencyCtrl);
    }

    if (categoryMatches(category, ['ssd'])) {
      _putSpec(specs, 'ssd_type', hardwareSsdTypeCtrl);
      _putSpec(specs, 'capacity_gb', hardwareSsdCapacityGbCtrl);
      _putSpec(specs, 'form_factor', hardwareSsdFormFactorCtrl);
      _putSpec(specs, 'interface', hardwareSsdInterfaceCtrl);
      _putSpec(specs, 'read_speed_mbps', hardwareSsdReadSpeedCtrl);
      _putSpec(specs, 'write_speed_mbps', hardwareSsdWriteSpeedCtrl);
    }

    if (categoryMatches(category, ['hdd', 'hhd'])) {
      _putSpec(specs, 'capacity_gb', hardwareHddCapacityGbCtrl);
      _putSpec(specs, 'rpm', hardwareHddRpmCtrl);
      _putSpec(specs, 'form_factor', hardwareHddFormFactorCtrl);
      _putSpec(specs, 'cache_mb', hardwareHddCacheMbCtrl);
    }

    if (categoryMatches(category, ['screen', 'display', 'monitor'])) {
      _putSpec(specs, 'size_inch', hardwareDisplaySizeInchCtrl);
      _putSpec(specs, 'resolution', hardwareDisplayResolutionCtrl);
      _putSpec(specs, 'refresh_rate_hz', hardwareDisplayRefreshRateCtrl);
      _putSpec(specs, 'panel_type', hardwareDisplayPanelTypeCtrl);
      _putSpec(specs, 'connector_pin', hardwareDisplayConnectorPinCtrl);
      _putSpec(specs, 'brightness_nits', hardwareDisplayBrightnessNitCtrl);
    }

    if (categoryMatches(category, ['thermal', 'paste'])) {
      _putSpec(specs, 'conductivity_wmk', hardwareThermalConductivityCtrl);
      _putSpec(specs, 'thermal_type', hardwareThermalTypeCtrl);
      _putSpec(specs, 'weight_g', hardwareThermalWeightCtrl);
    }

    if (categoryMatches(category, ['fan', 'cooling'])) {
      _putSpec(specs, 'size_mm', hardwareFanSizeMmCtrl);
      _putSpec(specs, 'connector', hardwareFanConnectorCtrl);
      _putSpec(specs, 'max_rpm', hardwareFanMaxRpmCtrl);
      _putSpec(specs, 'fan_type', hardwareFanTypeCtrl);
    }

    if (categoryMatches(category, ['battery'])) {
      _putSpec(specs, 'capacity_wh', hardwareBatteryWhCtrl);
      _putSpec(specs, 'capacity_mah', hardwareBatteryMahCtrl);
      _putSpec(specs, 'cells', hardwareBatteryCellsCtrl);
      _putSpec(specs, 'voltage_v', hardwareBatteryVoltageCtrl);
      _putSpec(specs, 'battery_type', hardwareBatteryTypeCtrl);
      _putSpec(specs, 'connector_type', hardwareBatteryConnectorCtrl);
    }

    if (categoryMatches(category, ['charger', 'adapter'])) {
      _putSpec(specs, 'wattage_w', hardwareChargerWattageCtrl);
      _putSpec(specs, 'voltage_v', hardwareChargerVoltageCtrl);
      _putSpec(specs, 'connector_type', hardwareChargerConnectorCtrl);
      _putSpec(specs, 'charging_standard', hardwareChargerStandardCtrl);
    }

    return specs;
  }

  String _buildSpecificationSummary(
    String brand,
    String modelName,
    Map<String, dynamic> partSpecs,
  ) {
    final fragments = <String>['Brand: $brand', 'Model: $modelName'];

    partSpecs.forEach((key, value) {
      final label = key
          .split('_')
          .map(
            (segment) => segment.isEmpty
                ? segment
                : '${segment[0].toUpperCase()}${segment.substring(1)}',
          )
          .join(' ');
      fragments.add('$label: $value');
    });

    return fragments.join(', ');
  }

  String _normalizePostingError(Object error) {
    if (error is ApiException &&
        error.statusCode == 422 &&
        error.message.contains('part_specs') &&
        error.message.contains('valid dict')) {
      return 'Backend rejected `part_specs` during image upload. FastAPI is receiving multipart text instead of a real object. The app retried an alternate format, but your `/parts/` endpoint still needs to accept JSON-parsed `part_specs` with multipart uploads.';
    }

    return error.toString().replaceFirst('Exception: ', '');
  }

  void _clearHardwareForm() {
    hardwareBrandCtrl.clear();
    hardwareModelCtrl.clear();
    hardwarePriceCtrl.clear();
    selectedHardwareImage.value = null;
    hardwareCpuCtrl.clear();
    hardwareGpuCtrl.clear();
    hardwareRamTypeCtrl.clear();
    hardwareRamCapacityGbCtrl.clear();
    hardwareRamBusMhzCtrl.clear();
    hardwareRamFormFactorCtrl.clear();
    hardwareRamLatencyCtrl.clear();
    hardwareRamSlotsCtrl.clear();
    hardwareMaxRamCtrl.clear();
    hardwareSsdTypeCtrl.clear();
    hardwareSsdCapacityGbCtrl.clear();
    hardwareSsdFormFactorCtrl.clear();
    hardwareSsdInterfaceCtrl.clear();
    hardwareSsdReadSpeedCtrl.clear();
    hardwareSsdWriteSpeedCtrl.clear();
    hardwareHddCapacityGbCtrl.clear();
    hardwareHddRpmCtrl.clear();
    hardwareHddFormFactorCtrl.clear();
    hardwareHddCacheMbCtrl.clear();
    hardwareHddBayCtrl.clear();
    hardwareDisplaySizeInchCtrl.clear();
    hardwareDisplayResolutionCtrl.clear();
    hardwareDisplayRefreshRateCtrl.clear();
    hardwareDisplayPanelTypeCtrl.clear();
    hardwareDisplayConnectorPinCtrl.clear();
    hardwareDisplayBrightnessNitCtrl.clear();
    hardwareThermalConductivityCtrl.clear();
    hardwareThermalTypeCtrl.clear();
    hardwareThermalWeightCtrl.clear();
    hardwareBatteryWhCtrl.clear();
    hardwareBatteryMahCtrl.clear();
    hardwareBatteryCellsCtrl.clear();
    hardwareBatteryVoltageCtrl.clear();
    hardwareBatteryTypeCtrl.clear();
    hardwareBatteryConnectorCtrl.clear();
    hardwareChargerWattageCtrl.clear();
    hardwareChargerVoltageCtrl.clear();
    hardwareChargerConnectorCtrl.clear();
    hardwareChargerStandardCtrl.clear();
    hardwareFanSizeMmCtrl.clear();
    hardwareFanConnectorCtrl.clear();
    hardwareFanMaxRpmCtrl.clear();
    hardwareFanTypeCtrl.clear();
  }

  Future<void> postHardwareListing() async {
    try {
      isPostingHardware.value = true;
      final session = Get.find<SessionService>();
      final token = session.accessToken;
      if (token == null) throw 'Authentication required.';

      if (shopId.value.isEmpty) {
        throw 'Shop ID is empty. Please set up your shop profile first.';
      }
      if (shopId.value == 'test-shop-id') {
        throw 'Shop not set up. Please complete your shop profile before posting hardware.';
      }

      final category = selectedPostCategory;
      _validateTechnicalForm(category);

      final brand = hardwareBrandCtrl.text.trim();
      final modelName = hardwareModelCtrl.text.trim();
      final price = double.tryParse(hardwarePriceCtrl.text.trim());
      if (price == null) {
        throw 'Price must be a valid number.';
      }

      final partSpecs = _buildPartSpecs(category);
      final specification = _buildSpecificationSummary(
        brand,
        modelName,
        partSpecs,
      );

      if (selectedHardwareImage.value != null) {
        debugPrint('📤 Image selected: ${selectedHardwareImage.value}');

        final imageFile = File(selectedHardwareImage.value!);
        if (await imageFile.exists()) {
          final fileSize = await imageFile.length();
          debugPrint('✅ File exists - Size: $fileSize bytes');
        } else {
          print(
            '❌ ERROR: File does not exist at path: ${selectedHardwareImage.value!}',
          );
          throw 'Image file not found at ${selectedHardwareImage.value!}';
        }

        // Upload with image file using field name that backend recognizes
        try {
          print(
            '📤 Attempting multipart upload with fileFieldName="product_image"',
          );
          debugPrint('📤 Brand: $brand, Model: $modelName');
          debugPrint('📤 Spec: $specification');
          debugPrint('📤 File path: ${selectedHardwareImage.value}');
          await _apiClient.postMultipart(
            '/parts/',
            fields: {
              'category_id': selectedCategoryIdForPost.value,
              'brand': brand,
              'model_name': modelName,
              'specification': specification,
              'price': price.toString(),
            },
            fileFieldName:
                'product_image', // Backend looks for file in this field first
            filePath: selectedHardwareImage.value!,
            bearerToken: token,
          );
          debugPrint('✅ Multipart upload successful!');
        } catch (e) {
          debugPrint('❌ Multipart upload failed: $e');
          rethrow;
        }
      } else {
        debugPrint('📤 No image - using JSON upload');
        final body = {
          'category_id': selectedCategoryIdForPost.value,
          'brand': brand,
          'model_name': modelName,
          'specification': specification,
          'price': price,
        };
        debugPrint('📤 Body: ${jsonEncode(body)}');
        await _apiClient.postJson('/parts/', body: body, bearerToken: token);
      }

      await _fetchMyShopParts();
      Get.back();
      Get.snackbar(
        'Success',
        '${category.name} listing posted successfully.',
        backgroundColor: AppColor.kGoogleGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      _clearHardwareForm();
    } catch (e) {
      Get.snackbar(
        'Posting Failed',
        _normalizePostingError(e),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isPostingHardware.value = false;
    }
  }

  final Rx<LaptopSpecModel?> selectedModelSpec = Rx<LaptopSpecModel?>(null);
  final RxBool isSpecsLoading = false.obs;

  Future<void> fetchSpecsForModel(String modelId) async {
    try {
      isSpecsLoading.value = true;
      selectedModelSpec.value = null; // Clear previous

      // Assuming you have an endpoint like /laptop-specs/?model_id=...
      final response = await _apiClient.getRequest(
        '/laptop-specs/',
        queryParameters: {'model_id': modelId},
      );

      if (response != null) {
        // If it returns a list, take the first one; if a single object, parse directly
        if (response is List && response.isNotEmpty) {
          selectedModelSpec.value = LaptopSpecModel.fromJson(response[0]);
        } else if (response is Map<String, dynamic>) {
          selectedModelSpec.value = LaptopSpecModel.fromJson(response);
        }
      }
    } catch (e) {
      debugPrint('[ProfileController] Could not fetch specs: $e');
    } finally {
      isSpecsLoading.value = false;
    }
  }

  void _showShopSuccessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColor.kBackground,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: AppColor.kGoogleGreen,
                size: 64,
              ),
              const SizedBox(height: 24),
              const AppText(
                'Shop Created Successfully!',
                variant: AppTextVariant.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              AppText(
                'Your shop is now ready. Start adding your hardware listings.',
                variant: AppTextVariant.body,
                color: AppColor.kAuthTextSecondary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.kGoogleGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Get Started'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.kGoogleGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.white, size: 14),
          SizedBox(width: 4),
          AppText(
            'Saved',
            variant: AppTextVariant.label,
            color: Colors.white,
            fontSize: 11,
          ),
        ],
      ),
    );
  }

  void showUnderConstruction() {
    Get.to(() => const UnderConstructionView());
  }

  Future<void> deleteListing(String postId) async {
    try {
      final session = Get.find<SessionService>();
      final token = session.accessToken;
      if (token == null) throw 'Authentication required.';

      // Remove item from list immediately for better UX
      myListings.removeWhere((item) => item.id == postId);

      await _apiClient.deleteJson('/listings/$postId', bearerToken: token);

      // Refresh the list from server
      await _fetchMyShopParts();
      Get.snackbar(
        'Success',
        'Listing deleted successfully.',
        backgroundColor: AppColor.kGoogleGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      // Refresh list to restore deleted item if deletion failed
      await _fetchMyShopParts();
      Get.snackbar(
        'Delete Failed',
        'Failed to delete listing: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      debugPrint('[ProfileController] Could not delete listing: $e');
    }
  }
}
