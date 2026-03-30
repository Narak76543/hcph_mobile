import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/core/network/api_client.dart';
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

  final recentPosts = <PostModel>[
    PostModel(
      partName: 'PRO X SUPERLIGHT 2 SE',
      compatibleModel: 'Fits MSI Cyborg',
      shopName: 'GTC Computer',
      price: 55.00,
      imageUrl: 'assets/images/l-m.webp',
    ),
    PostModel(
      partName: 'ASUS ROG 240W Power Adapter',
      compatibleModel: 'Fits ROG Strix G15',
      shopName: 'Gold One Computer',
      price: 89.99,
      imageUrl: 'assets/images/asus_adp.webp',
    ),
    PostModel(
      partName: 'YETI GX',
      compatibleModel: 'LIGHTSYNC RGB',
      shopName: 'Dynamic Computer',
      price: 799.00,
      imageUrl: 'assets/images/l-mice.webp',
    ),
    PostModel(
      partName: 'Crucial 1TB NVMe SSD',
      compatibleModel: 'M.2 PCIe Gen 4',
      shopName: 'Speed Tech KH',
      price: 75.00,
      imageUrl: 'assets/images/crucal.png',
    ),
  ].obs;

  final ApiClient _apiClient = ApiClient();

  @override
  void onInit() {
    super.onInit();
    _fetchCategoriesFromBackend();
    _fetchBrandsFromBackend();
  }

  Future<void> refreshHome() async {
    await Future.wait([
      _fetchCategoriesFromBackend(),
      _fetchBrandsFromBackend(),
    ]);
  }

  Future<void> _fetchCategoriesFromBackend() async {
    try {
      final response = await _apiClient.getRequest('/part-categories/');
      if (response != null && response is List) {
        categories.value = response.map((e) {
          final String name = e['name'] ?? 'Category';
          final String slug = e['slug'] ?? '';
          return CategoryModel(
            id: e['id']?.toString() ?? '',
            name: name,
            slug: slug,
            icon: _getIconForSlug(slug),
          );
        }).toList();
      }
    } catch (e) {
      print("[HomeController] Error fetching categories: $e");
      _loadDummyCategories();
    }
  }

  Future<void> _fetchBrandsFromBackend() async {
    try {
      final response = await _apiClient.getRequest('/laptop-brands/', queryParameters: {'limit': '30'});
      if (response != null) {
        List<dynamic> list = [];
        if (response is List) {
          list = response;
        } else if (response is Map<String, dynamic> && response['data'] is List) {
          list = response['data'] as List;
        }

        brands.value = list.map((e) {
          return BrandModel(
            id: e['id']?.toString() ?? '',
            name: e['name']?.toString() ?? 'Brand',
            slug: e['slug']?.toString() ?? '',
            imageUrl: e['brand_img_url']?.toString(), // newly added backend field
          );
        }).toList();
      }
    } catch (e) {
      print("[HomeController] Error fetching brands: $e");
    }
  }

  IconData _getIconForSlug(String slug) {
    if (slug.contains('ram') || slug.contains('memory'))
      return Icons.memory_rounded;
    if (slug.contains('ssd') ||
        slug.contains('storage') ||
        slug.contains('hdd'))
      return Icons.storage_rounded;
    if (slug.contains('battery')) return Icons.battery_charging_full_rounded;
    if (slug.contains('charger') ||
        slug.contains('psu') ||
        slug.contains('power'))
      return Icons.cable_rounded;
    if (slug.contains('screen') ||
        slug.contains('monitor') ||
        slug.contains('display'))
      return Icons.laptop_chromebook_rounded;
    if (slug.contains('cpu') || slug.contains('processor'))
      return Icons.developer_board_rounded;
    if (slug.contains('gpu') ||
        slug.contains('graphics') ||
        slug.contains('video'))
      return Icons.grid_view_rounded;
    if (slug.contains('motherboard') || slug.contains('mainboard'))
      return Icons.account_tree_rounded;
    if (slug.contains('case') || slug.contains('chassis'))
      return Icons.dns_rounded;
    if (slug.contains('cooler') ||
        slug.contains('cooling') ||
        slug.contains('fan'))
      return Icons.ac_unit_rounded;
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
