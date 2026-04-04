import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/core/network/api_client.dart';
import 'package:school_assgn/core/network/api_config.dart';
import 'package:school_assgn/features/home/models/home_models.dart';

class HomeController extends GetxController {
  final searchController = TextEditingController();

  final topUpgrades = <UpgradeModel>[
    UpgradeModel(
      title: 'Upgrade your MSI Cyborg 15 RAM',
      subtitle: 'Boost performance up to 40%',
      imageUrl: 'assets/images/msi.webp',
      discount: '20% Off',
    ),
    UpgradeModel(
      title: 'Samsung 990 PRO 2TB NVMe',
      subtitle: 'Lightning fast load times',
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/8734/8734062.png',
      discount: '15% Off',
    ),
  ].obs;

  final categories = <CategoryModel>[].obs;
  final brands = <BrandModel>[].obs;
  final selectedCategoryId = '0'.obs; // '0' represents "All Parts"
  final searchQuery = ''.obs;

  List<PostModel> get displayPosts {
    List<PostModel> filtered = recentPosts;

    if (selectedCategoryId.value != '0') {
      filtered = filtered
          .where((p) => p.categoryId == selectedCategoryId.value)
          .toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      filtered = filtered
          .where((p) =>
              p.partName.toLowerCase().contains(q) ||
              p.brand.toLowerCase().contains(q) ||
              p.model.toLowerCase().contains(q))
          .toList();
    }

    return filtered;
  }

  final recentPosts = <PostModel>[
    PostModel(
      id: '1',
      partName: 'PRO X SUPERLIGHT 2 SE',
      brand: 'Logitech',
      model: 'PRO X SUPERLIGHT 2 SE',
      compatibleModel: 'Fits MSI Cyborg',
      shopName: 'GTC Computer',
      postedBy: 'GTC Computer',
      price: 55.00,
      imageUrl: 'assets/images/l-m.webp',
    ),
    PostModel(
      id: '2',
      partName: 'ASUS ROG 240W Power Adapter',
      brand: 'ASUS',
      model: 'ROG 240W Power Adapter',
      compatibleModel: 'Fits ROG Strix G15',
      shopName: 'Gold One Computer',
      postedBy: 'Gold One Computer',
      price: 89.99,
      imageUrl: 'assets/images/asus_adp.webp',
    ),
    PostModel(
      id: '3',
      partName: 'YETI GX',
      brand: 'Logitech',
      model: 'YETI GX',
      compatibleModel: 'LIGHTSYNC RGB',
      shopName: 'Dynamic Computer',
      postedBy: 'Dynamic Computer',
      price: 799.00,
      imageUrl: 'assets/images/l-mice.webp',
    ),
    PostModel(
      id: '4',
      partName: 'Crucial 1TB NVMe SSD',
      brand: 'Crucial',
      model: '1TB NVMe SSD',
      compatibleModel: 'M.2 PCIe Gen 4',
      shopName: 'Speed Tech KH',
      postedBy: 'Speed Tech KH',
      price: 75.00,
      imageUrl: 'assets/images/crucal.png',
    ),
  ].obs;

  final ApiClient _apiClient = ApiClient();

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
    _fetchCategoriesFromBackend();
    _fetchBrandsFromBackend();
    _fetchPostsFromBackend();
  }

  Future<void> refreshHome() async {
    await Future.wait([
      _fetchCategoriesFromBackend(),
      _fetchBrandsFromBackend(),
      _fetchPostsFromBackend(),
    ]);
  }

  Future<void> _fetchCategoriesFromBackend() async {
    try {
      final response = await _apiClient.getRequest('/part-categories/');
      if (response != null) {
        List<dynamic> list = [];
        if (response is List) {
          list = response;
        } else if (response is Map<String, dynamic> &&
            response['data'] is List) {
          list = response['data'] as List;
        }

        if (list.isNotEmpty) {
          categories.value = list.map((e) {
            final String name = e['name'] ?? 'Category';
            final String slug = e['slug'] ?? '';
            String? imageUrlStr =
                (e['category_img_url'] ??
                        e['part_category_img_url'] ??
                        e['category_icon_url'] ??
                        e['part_icon_url'] ??
                        e['part_cat_img_url'] ??
                        e['part_cat_icon_url'] ??
                        e['img_url'] ??
                        e['image_url'] ??
                        e['icon_url'] ??
                        e['cat_img_url'] ??
                        e['cat_icon_url'] ??
                        e['category_img'] ??
                        e['part_category_img'] ??
                        e['cat_img'] ??
                        e['img'] ??
                        e['image'] ??
                        e['icon'] ??
                        e['category_icon'] ??
                        e['cat_icon'] ??
                        e['part_icon'] ??
                        e['part_img'])
                    ?.toString();

            // ── URL Normalization (same as used for brands) ──
            if (imageUrlStr != null && imageUrlStr.isNotEmpty) {
              if (imageUrlStr.startsWith('http://localhost:8000')) {
                imageUrlStr = imageUrlStr.replaceFirst(
                  'http://localhost:8000',
                  ApiConfig.baseUrl,
                );
              } else if (imageUrlStr.startsWith('http://127.0.0.1:8000')) {
                imageUrlStr = imageUrlStr.replaceFirst(
                  'http://127.0.0.1:8000',
                  ApiConfig.baseUrl,
                );
              } else if (!imageUrlStr.startsWith('http')) {
                imageUrlStr =
                    '${ApiConfig.baseUrl}${imageUrlStr.startsWith('/') ? imageUrlStr : '/$imageUrlStr'}';
              }
            }

            return CategoryModel(
              id: e['id']?.toString() ?? '',
              name: name,
              slug: slug,
              icon: _getIconForSlug(slug),
              imageUrl: imageUrlStr,
            );
          }).toList();
        }
      }
    } catch (e) {
      print("[HomeController] Error fetching categories: $e");
      _loadDummyCategories();
    }
  }

  Future<void> _fetchPostsFromBackend() async {
    try {
      // Use listings so we also get shop_name, part_image, and price
      final response = await _apiClient.getRequest(
        '/listings/',
        queryParameters: {'limit': '20'},
      );
      if (response != null) {
        List<dynamic> list = [];
        if (response is List) {
          list = response;
        } else if (response is Map<String, dynamic> &&
            response['data'] is List) {
          list = response['data'] as List;
        }

        if (list.isNotEmpty) {
          recentPosts.value = list
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

                // If image is still empty, use fallback
                if (imageUrl.isEmpty) {
                  imageUrl = 'assets/images/l-m.webp';
                }

                // Return model with normalized image
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
                  categoryId: model.categoryId, // Ensure categoryId is preserved
                  isVerified: model.isVerified,
                );
              })
              .cast<PostModel>()
              .toList();
        }
      }
    } catch (e) {
      print("[HomeController] Error fetching posts: $e");
    }
  }

  Future<void> _fetchBrandsFromBackend() async {
    try {
      final response = await _apiClient.getRequest(
        '/laptop-brands/',
        queryParameters: {'limit': '30'},
      );
      if (response != null) {
        List<dynamic> list = [];
        if (response is List) {
          list = response;
        } else if (response is Map<String, dynamic> &&
            response['data'] is List) {
          list = response['data'] as List;
        }

        brands.value = list.map((e) {
          return BrandModel(
            id: e['id']?.toString() ?? '',
            name: e['name']?.toString() ?? 'Brand',
            slug: e['slug']?.toString() ?? '',
            imageUrl: e['brand_img_url']
                ?.toString(), // newly added backend field
          );
        }).toList();
      }
    } catch (e) {
      print("[HomeController] Error fetching brands: $e");
    }
  }

  IconData _getIconForSlug(String slug) {
    if (slug.contains('ram') || slug.contains('memory')) {
      return Icons.memory_rounded;
    }
    if (slug.contains('ssd') ||
        slug.contains('storage') ||
        slug.contains('hdd')) {
      return Icons.storage_rounded;
    }
    if (slug.contains('battery')) return Icons.battery_charging_full_rounded;
    if (slug.contains('charger') ||
        slug.contains('psu') ||
        slug.contains('power')) {
      return Icons.cable_rounded;
    }
    if (slug.contains('screen') ||
        slug.contains('monitor') ||
        slug.contains('display')) {
      return Icons.laptop_chromebook_rounded;
    }
    if (slug.contains('cpu') || slug.contains('processor')) {
      return Icons.developer_board_rounded;
    }
    if (slug.contains('gpu') ||
        slug.contains('graphics') ||
        slug.contains('video')) {
      return Icons.grid_view_rounded;
    }
    if (slug.contains('motherboard') || slug.contains('mainboard')) {
      return Icons.account_tree_rounded;
    }
    if (slug.contains('case') || slug.contains('chassis')) {
      return Icons.dns_rounded;
    }
    if (slug.contains('cooler') ||
        slug.contains('cooling') ||
        slug.contains('fan')) {
      return Icons.ac_unit_rounded;
    }
    if (slug.contains('keyboard')) return Icons.keyboard_rounded;
    if (slug.contains('mouse')) return Icons.mouse_rounded;
    return Icons.widgets_rounded;
  }

  void _loadDummyCategories() {
    categories.value = [
      CategoryModel(
        id: '1',
        name: 'RAM',
        slug: 'ram',
        icon: Icons.memory_rounded,
      ),
      CategoryModel(
        id: '2',
        name: 'SSD',
        slug: 'ssd',
        icon: Icons.storage_rounded,
      ),
      CategoryModel(
        id: '3',
        name: 'Battery',
        slug: 'battery',
        icon: Icons.battery_charging_full_rounded,
      ),
      CategoryModel(
        id: '4',
        name: 'Charger',
        slug: 'charger',
        icon: Icons.cable_rounded,
      ),
      CategoryModel(
        id: '5',
        name: 'Screen',
        slug: 'screen',
        icon: Icons.laptop_chromebook_rounded,
      ),
    ];
  }
}
