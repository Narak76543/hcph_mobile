import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/core/network/api_client.dart';
import 'package:school_assgn/core/network/api_config.dart';
import 'package:school_assgn/features/home/controllers/home_controller.dart';
import 'package:school_assgn/features/home/models/home_models.dart';
import 'package:school_assgn/features/profile/controllers/profile_controller.dart';

class SearchFeatureController extends GetxController {
  SearchFeatureController({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;
  final searchController = TextEditingController();

  final products = <PostModel>[].obs;
  final searchQuery = ''.obs;
  final fitsYourDeviceOnly = true.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text.trim();
    });
    fetchProducts();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> refreshSearch() => fetchProducts();

  Future<void> fetchProducts() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _apiClient.getRequest(
        '/listings/',
        queryParameters: {'limit': '50'},
      );

      final list = _extractList(response);
      final loadedProducts = list
          .map((e) => PostModel.fromJson(Map<String, dynamic>.from(e)))
          .map(_withNormalizedImage)
          .toList();
      products.value = loadedProducts;
    } catch (e) {
      errorMessage.value = 'Could not load products right now.';
      debugPrint('[SearchFeatureController] Error fetching products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<PostModel> get displayProducts {
    final query = searchQuery.value.toLowerCase();

    return products.where((post) {
      if (fitsYourDeviceOnly.value && !isCompatibleWithDevice(post)) {
        return false;
      }

      if (query.isEmpty) return true;

      return post.partName.toLowerCase().contains(query) ||
          post.brand.toLowerCase().contains(query) ||
          post.model.toLowerCase().contains(query) ||
          post.shopName.toLowerCase().contains(query);
    }).toList();
  }

  bool isCompatibleWithDevice(PostModel post) {
    if (Get.isRegistered<HomeController>()) {
      return Get.find<HomeController>().isCompatibleWithDevice(post);
    }
    return false;
  }

  String? get selectedLaptopName {
    if (!Get.isRegistered<ProfileController>()) return null;
    final profile = Get.find<ProfileController>();
    if (profile.myLaptops.isEmpty) return null;

    final laptopModel = profile.myLaptops.first['laptop_model'];
    if (laptopModel is Map && laptopModel['name'] != null) {
      return laptopModel['name'].toString();
    }
    return null;
  }

  List<dynamic> _extractList(dynamic response) {
    if (response is List) return response;
    if (response is Map<String, dynamic>) {
      final data = response['data'];
      if (data is List) return data;
      final results = response['results'];
      if (results is List) return results;
    }
    return const [];
  }

  PostModel _withNormalizedImage(PostModel model) {
    var imageUrl = _normalizeMediaUrl(model.imageUrl);
    final ownerProfileImageUrl = _normalizeMediaUrl(model.ownerProfileImageUrl);

    if (imageUrl.isEmpty) {
      imageUrl = 'assets/images/ss990.webp';
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
      ownerProfileImageUrl: ownerProfileImageUrl,
      postedAt: model.postedAt,
      price: model.price,
      imageUrl: imageUrl,
      categoryId: model.categoryId,
      categorySlug: model.categorySlug,
      isVerified: model.isVerified,
      partSpecs: model.partSpecs,
    );
  }

  String _normalizeMediaUrl(String url) {
    return ApiConfig.normalizeMediaUrl(url);
  }
}
