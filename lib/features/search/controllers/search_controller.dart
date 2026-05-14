import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/core/network/api_client.dart';
import 'package:school_assgn/core/network/api_config.dart';
import 'package:school_assgn/features/home/controllers/home_controller.dart';
import 'package:school_assgn/features/home/models/home_models.dart';
import 'package:school_assgn/features/profile/controllers/profile_controller.dart';

enum SearchSortOption {
  newest('Newest'),
  oldest('Oldest'),
  priceLowToHigh('Price: Low to High'),
  priceHighToLow('Price: High to Low');

  const SearchSortOption(this.label);

  final String label;
}

enum SearchConditionFilter {
  any('Any condition'),
  newOnly('New'),
  used('Used');

  const SearchConditionFilter(this.label);

  final String label;
}

class SearchFeatureController extends GetxController {
  SearchFeatureController({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;
  final searchController = TextEditingController();

  final categories = <CategoryModel>[].obs;
  final products = <PostModel>[].obs;
  final searchQuery = ''.obs;
  final selectedCategoryId = '0'.obs;
  final fitsYourDeviceOnly = true.obs;
  final sortOption = SearchSortOption.newest.obs;
  final conditionFilter = SearchConditionFilter.any.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text.trim();
    });
    refreshSearch();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> refreshSearch() async {
    await Future.wait([fetchCategories(), fetchProducts()]);
  }

  Future<void> fetchCategories() async {
    try {
      if (Get.isRegistered<HomeController>() &&
          Get.find<HomeController>().categories.isNotEmpty) {
        categories.value = Get.find<HomeController>().categories.toList();
        return;
      }

      await _apiClient.getCachedThenFresh(
        '/part-categories/',
        onData: (response) {
          final list = _extractList(response);
          categories.value = list.map((e) {
            final data = Map<String, dynamic>.from(e);
            final imageUrl =
                data['category_img_url'] ??
                data['part_category_img_url'] ??
                data['category_icon_url'] ??
                data['part_icon_url'] ??
                data['img_url'] ??
                data['image_url'] ??
                data['icon_url'];

            return CategoryModel(
              id: data['id']?.toString() ?? '',
              name: data['name']?.toString() ?? 'Category',
              slug: data['slug']?.toString() ?? '',
              imageUrl: imageUrl == null
                  ? null
                  : ApiConfig.normalizeMediaUrl(imageUrl.toString()),
            );
          }).toList();
        },
      );
    } catch (e) {
      debugPrint('[SearchFeatureController] Error fetching categories: $e');
    }
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      await _apiClient.getCachedThenFresh(
        '/listings/',
        queryParameters: {'limit': '50'},
        onData: (response) {
          final list = _extractList(response);
          final loadedProducts = list
              .map((e) => PostModel.fromJson(Map<String, dynamic>.from(e)))
              .map(_withNormalizedImage)
              .toList();
          products.value = loadedProducts;
        },
      );
    } catch (e) {
      errorMessage.value = 'Could not load products right now.';
      debugPrint('[SearchFeatureController] Error fetching products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<PostModel> get displayProducts {
    final query = searchQuery.value.toLowerCase();

    final filtered = products.where((post) {
      if (selectedCategoryId.value != '0' &&
          post.categoryId != selectedCategoryId.value) {
        return false;
      }

      if (fitsYourDeviceOnly.value && !isCompatibleWithDevice(post)) {
        return false;
      }

      if (!_matchesCondition(post)) {
        return false;
      }

      if (query.isEmpty) return true;

      return post.partName.toLowerCase().contains(query) ||
          post.brand.toLowerCase().contains(query) ||
          post.model.toLowerCase().contains(query) ||
          post.shopName.toLowerCase().contains(query) ||
          post.compatibleModel.toLowerCase().contains(query);
    }).toList();

    filtered.sort(_compareProducts);
    return filtered;
  }

  bool get hasActiveFilters =>
      selectedCategoryId.value != '0' ||
      fitsYourDeviceOnly.value ||
      sortOption.value != SearchSortOption.newest ||
      conditionFilter.value != SearchConditionFilter.any;

  void setCategory(String categoryId) {
    selectedCategoryId.value = categoryId;
  }

  void setFitsYourDeviceOnly(bool value) {
    fitsYourDeviceOnly.value = value;
  }

  void setSortOption(SearchSortOption option) {
    sortOption.value = option;
  }

  void setConditionFilter(SearchConditionFilter filter) {
    conditionFilter.value = filter;
  }

  void clearFilters() {
    selectedCategoryId.value = '0';
    fitsYourDeviceOnly.value = false;
    sortOption.value = SearchSortOption.newest;
    conditionFilter.value = SearchConditionFilter.any;
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

  int _compareProducts(PostModel a, PostModel b) {
    switch (sortOption.value) {
      case SearchSortOption.newest:
        return _dateValue(b).compareTo(_dateValue(a));
      case SearchSortOption.oldest:
        return _dateValue(a).compareTo(_dateValue(b));
      case SearchSortOption.priceLowToHigh:
        return a.price.compareTo(b.price);
      case SearchSortOption.priceHighToLow:
        return b.price.compareTo(a.price);
    }
  }

  int _dateValue(PostModel post) {
    return post.postedAt?.millisecondsSinceEpoch ?? 0;
  }

  bool _matchesCondition(PostModel post) {
    switch (conditionFilter.value) {
      case SearchConditionFilter.any:
        return true;
      case SearchConditionFilter.newOnly:
        return _postCondition(post).contains('new');
      case SearchConditionFilter.used:
        final condition = _postCondition(post);
        return condition.contains('used') || condition.contains('second');
    }
  }

  String _postCondition(PostModel post) {
    final raw =
        post.partSpecs['condition'] ??
        post.partSpecs['item_condition'] ??
        post.partSpecs['product_condition'] ??
        post.partSpecs['status'] ??
        '';
    return raw.toString().toLowerCase().trim();
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
      ownerRole: model.ownerRole,
      ownerTelegramUsername: model.ownerTelegramUsername,
      ownerProfileImageUrl: ownerProfileImageUrl,
      shopTelegramHandle: model.shopTelegramHandle,
      shopGoogleMapsUrl: model.shopGoogleMapsUrl,
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
