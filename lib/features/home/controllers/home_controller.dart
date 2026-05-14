import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/core/network/api_client.dart';
import 'package:school_assgn/core/network/api_config.dart';
import 'package:school_assgn/features/home/models/home_models.dart';
import 'package:school_assgn/features/profile/controllers/profile_controller.dart';

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

  final verifiedShops = <Map<String, dynamic>>[].obs;
  final recentlyAdded = <PostModel>[].obs;
  final isLoadingRecent = false.obs;
  // ==============get verified shop ======================
  Future<void> _fetchVerifiedShops() async {
    try {
      await _apiClient.getCachedThenFresh(
        '/shops/verified/', // ← updated endpoint
        queryParameters: {'limit': '10'},
        onData: (response) {
        List<dynamic> list = [];
        if (response is List) {
          list = response;
        } else if (response is Map &&
            response['data'] is List) {
          list = response['data'] as List;
        }

        verifiedShops.value = list.map((e) {
          final imgUrl = ApiConfig.normalizeMediaUrl(
            e['shop_pro_img_url']?.toString() ?? '',
          );

          return <String, dynamic>{
            'id': e['id']?.toString() ?? '',
            'name': e['name']?.toString() ?? 'Unknown Shop',
            'address': e['address']?.toString() ?? '',
            'province': e['province']?.toString() ?? '',
            'district': e['district']?.toString() ?? '',
            'shop_pro_img_url': imgUrl,
            'listing_count':
                int.tryParse(e['listing_count']?.toString() ?? '0') ?? 0,
            'status': e['status']?.toString() ?? '',
          };
        }).toList();

        debugPrint(
          '[HomeController] Verified shops loaded: ${verifiedShops.length}',
        );
        },
      );
    } catch (e) {
      debugPrint('[HomeController] Error fetching verified shops: $e');
    }
  }

  // Get Recently added Item

  Future<void> _fetchRecentlyAdded() async {
    isLoadingRecent.value = true;
    try {
      await _apiClient.getCachedThenFresh(
        '/listings/recently-added/',
        queryParameters: {'limit': '10'},
        onData: (response) {
          final list = response is List ? response : <dynamic>[];
          final loadedPosts = list
            .map((e) => PostModel.fromJson(Map<String, dynamic>.from(e)))
            .map(_withNormalizedImages)
            .toList();
          recentlyAdded.value = loadedPosts;
        },
      );
    } catch (e) {
      debugPrint('[HomeController] Error fetching recently added: $e');
    } finally {
      isLoadingRecent.value = false; // ← always reset
    }
  }
  // end  Get Recently added Item

  List<PostModel> get displayPosts {
    List<PostModel> filtered = recentPosts
        .where(isCompatibleWithDevice)
        .toList();

    if (selectedCategoryId.value != '0') {
      filtered = filtered
          .where((p) => p.categoryId == selectedCategoryId.value)
          .toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      filtered = filtered
          .where(
            (p) =>
                p.partName.toLowerCase().contains(q) ||
                p.brand.toLowerCase().contains(q) ||
                p.model.toLowerCase().contains(q),
          )
          .toList();
    }

    return filtered;
  }

  final recentPosts = <PostModel>[].obs;

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
    _fetchVerifiedShops();
    _fetchRecentlyAdded();
  }

  Future<void> refreshHome() async {
    await Future.wait([
      _fetchCategoriesFromBackend(),
      _fetchBrandsFromBackend(),
      _fetchPostsFromBackend(),
      _fetchVerifiedShops(),
      _fetchRecentlyAdded(),
    ]);
  }

  Future<void> _fetchCategoriesFromBackend() async {
    try {
      await _apiClient.getCachedThenFresh(
        '/part-categories/',
        onData: (response) {
        List<dynamic> list = [];
        if (response is List) {
          list = response;
        } else if (response is Map &&
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
            imageUrlStr = imageUrlStr == null
                ? null
                : ApiConfig.normalizeMediaUrl(imageUrlStr);

            return CategoryModel(
              id: e['id']?.toString() ?? '',
              name: name,
              slug: slug,
              imageUrl: imageUrlStr,
            );
          }).toList();
        }
        },
      );
    } catch (e) {
      debugPrint("[HomeController] Error fetching categories: $e");
      _loadDummyCategories();
    }
  }

  Future<void> _fetchPostsFromBackend() async {
    try {
      // Use listings so we also get shop_name, part_image, and price
      await _apiClient.getCachedThenFresh(
        '/listings/',
        queryParameters: {'limit': '20'},
        onData: (response) {
        List<dynamic> list = [];
        if (response is List) {
          list = response;
        } else if (response is Map &&
            response['data'] is List) {
          list = response['data'] as List;
        }

        recentPosts.value = list
            .map((e) {
              final model = PostModel.fromJson(Map<String, dynamic>.from(e));

              String imageUrl = _normalizeMediaUrl(model.imageUrl);
              final ownerProfileImageUrl = _normalizeMediaUrl(
                model.ownerProfileImageUrl,
              );

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
                partSpecs:
                    model.partSpecs, // ← preserve specs for compatibility check
              );
            })
            .cast<PostModel>()
            .toList();
        },
      );
    } catch (e) {
      debugPrint("[HomeController] Error fetching posts: $e");
    }
  }

  Future<void> _fetchBrandsFromBackend() async {
    try {
      await _apiClient.getCachedThenFresh(
        '/laptop-brands/',
        queryParameters: {'limit': '30'},
        onData: (response) {
        List<dynamic> list = [];
        if (response is List) {
          list = response;
        } else if (response is Map &&
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
        },
      );
    } catch (e) {
      debugPrint("[HomeController] Error fetching brands: $e");
    }
  }

  String _normalizeMediaUrl(String url) {
    return ApiConfig.normalizeMediaUrl(url);
  }

  PostModel _withNormalizedImages(
    PostModel model, {
    String fallbackImage = 'assets/images/ss990.webp',
  }) {
    var imageUrl = _normalizeMediaUrl(model.imageUrl);
    if (imageUrl.isEmpty) imageUrl = fallbackImage;

    return model.copyWith(
      imageUrl: imageUrl,
      ownerProfileImageUrl: _normalizeMediaUrl(model.ownerProfileImageUrl),
    );
  }

  // ─────────────────── Compatibility Check (Model Logic) ───────────────────

  /// Returns true if [post] is compatible with any of the user's saved laptops.
  /// Business logic kept in the controller per MVC — views call this directly.
  bool isCompatibleWithDevice(PostModel post) {
    try {
      if (!Get.isRegistered<ProfileController>()) return false;
      final pc = Get.find<ProfileController>();
      if (pc.myLaptops.isEmpty) return false;

      for (final userLap in pc.myLaptops) {
        final model = userLap['laptop_model'];
        if (model is! Map) continue;

        final spec = model['spec'];
        if (spec is! Map) continue;

        // Resolve category slug — post field first, then look up by categoryId
        String? categorySlug = post.categorySlug?.toLowerCase().trim();
        if ((categorySlug == null || categorySlug.isEmpty) &&
            post.categoryId != null) {
          final match = categories.firstWhereOrNull(
            (c) => c.id == post.categoryId,
          );
          categorySlug = match?.slug.toLowerCase().trim();
        }
        final category = categorySlug;

        switch (category) {
          // ── RAM ───────────────────────────────────────────────────────────
          case 'ram':
            final laptopRamType =
                spec['ram_type']?.toString().toUpperCase() ?? '';
            final laptopMaxRam =
                int.tryParse(spec['max_ram_gg']?.toString() ?? '0') ?? 0;
            final laptopRamSlots =
                int.tryParse(spec['ram_slots']?.toString() ?? '0') ?? 0;

            final partRamType =
                post.partSpecs['ram_type']?.toString().toUpperCase() ?? '';
            final partCapacity =
                int.tryParse(
                  post.partSpecs['capacity_gb']?.toString() ?? '0',
                ) ??
                0;
            final partFormFactor =
                post.partSpecs['form_factor']?.toString().toUpperCase() ?? '';

            if (laptopRamSlots == 0) return false; // soldered

            if (laptopRamType.isNotEmpty) {
              if (partRamType.isEmpty) continue; // can't confirm → skip
              if (partRamType != laptopRamType) continue; // DDR4 ≠ DDR5
            }

            if (partFormFactor.isNotEmpty && !partFormFactor.contains('DIMM')) {
              continue;
            }

            if (laptopMaxRam > 0 &&
                partCapacity > 0 &&
                partCapacity > laptopMaxRam) {
              continue;
            }

            return true;

          // ── SSD ───────────────────────────────────────────────────────────
          case 'ssd':
            final laptopSsdSlots =
                int.tryParse(spec['ssd_slots']?.toString() ?? '0') ?? 0;
            final laptopSsdInterface =
                spec['ssd_interface']?.toString().toUpperCase() ?? '';
            final laptopSsdFormFactor =
                spec['ssd_from_factor']?.toString().toUpperCase() ?? '';
            final laptopHasHddBay = spec['has_hdd_bay'] == true;

            final partInterface =
                post.partSpecs['interface']?.toString().toUpperCase() ?? '';
            final partFormFactor =
                post.partSpecs['form_factor']?.toString().toUpperCase() ?? '';

            if (laptopSsdSlots == 0) continue;

            if (partFormFactor.contains('2.5') && !laptopHasHddBay) continue;

            final laptopIsNvme =
                laptopSsdInterface.contains('NVME') ||
                laptopSsdInterface.contains('PCIE');
            final laptopIsSata = laptopSsdInterface.contains('SATA');

            if (partInterface == 'NVME' && !laptopIsNvme) continue;

            if (partInterface == 'SATA' &&
                laptopIsNvme &&
                !laptopIsSata &&
                !laptopHasHddBay) {
              continue;
            }

            if (partFormFactor.isNotEmpty &&
                laptopSsdFormFactor.isNotEmpty &&
                !laptopSsdFormFactor.contains(partFormFactor) &&
                !partFormFactor.contains(laptopSsdFormFactor)) {
              continue;
            }

            return true;

          // ── HDD ───────────────────────────────────────────────────────────
          case 'hdd':
          case 'hdd1':
            if (spec['has_hdd_bay'] != true) continue;
            return true;

          // ── BATTERY ───────────────────────────────────────────────────────
          case 'battery':
            final laptopConnector =
                spec['battery_connector']?.toString().toLowerCase() ?? '';
            final laptopVoltage =
                double.tryParse(spec['battery_voltage']?.toString() ?? '0') ??
                0;
            final partConnector =
                post.partSpecs['connector_type']?.toString().toLowerCase() ??
                '';
            final partVoltage =
                double.tryParse(post.partSpecs['voltage']?.toString() ?? '0') ??
                0;

            if (laptopConnector.isEmpty || partConnector.isEmpty) {
              final brandName =
                  model['brand']?['name']?.toString().toLowerCase() ?? '';
              if (post.brand.toLowerCase().contains(brandName) ||
                  post.compatibleModel.toLowerCase().contains(
                    model['name']?.toString().toLowerCase() ?? '',
                  )) {
                return true;
              }
              continue;
            }

            if (laptopConnector != partConnector) continue;
            if (laptopVoltage > 0 &&
                partVoltage > 0 &&
                laptopVoltage != partVoltage) {
              continue;
            }
            return true;

          // ── DISPLAY ───────────────────────────────────────────────────────
          case 'display':
            final laptopDisplaySize = spec['display_size']?.toString() ?? '';
            final laptopDisplayConnector =
                spec['display_connector']?.toString().toLowerCase() ?? '';
            final partSize = post.partSpecs['size_inch']?.toString() ?? '';
            final partConnector =
                post.partSpecs['connector_pin']?.toString().toLowerCase() ?? '';

            if (laptopDisplaySize.isNotEmpty && partSize.isNotEmpty) {
              final lSize =
                  double.tryParse(laptopDisplaySize.replaceAll('"', '')) ?? 0;
              final pSize = double.tryParse(partSize) ?? 0;
              if (lSize > 0 && pSize > 0 && lSize != pSize) continue;
            }

            if (laptopDisplayConnector.isNotEmpty &&
                partConnector.isNotEmpty &&
                laptopDisplayConnector != partConnector) {
              continue;
            }

            return true;

          // ── CHARGER ───────────────────────────────────────────────────────
          case 'charger':
          case 'adapter':
            final laptopChargerWattage =
                int.tryParse(spec['charger_wattage']?.toString() ?? '0') ?? 0;
            final laptopChargerConnector =
                spec['charger_connector']?.toString().toLowerCase() ?? '';
            final partWattage =
                int.tryParse(post.partSpecs['wattage']?.toString() ?? '0') ?? 0;
            final partConnector =
                post.partSpecs['connector_type']?.toString().toLowerCase() ??
                '';

            if (laptopChargerWattage > 0 &&
                partWattage > 0 &&
                partWattage < laptopChargerWattage) {
              continue;
            }

            if (laptopChargerConnector.isNotEmpty &&
                partConnector.isNotEmpty &&
                laptopChargerConnector != partConnector) {
              continue;
            }

            return true;

          // ── THERMAL / COOLING FAN — universal ─────────────────────────────
          case 'thermal':
          case 'thermal paste':
          case 'cooling':
          case 'fan':
            return true;

          // ── FALLBACK: brand / model name match ────────────────────────────
          default:
            final brandName =
                model['brand']?['name']?.toString().toLowerCase() ?? '';
            final modelName = model['name']?.toString().toLowerCase() ?? '';
            final postCompat = post.compatibleModel.toLowerCase();
            if (brandName.isNotEmpty && postCompat.contains(brandName)) {
              return true;
            }
            if (modelName.isNotEmpty && postCompat.contains(modelName)) {
              return true;
            }
            continue;
        }
      }
    } catch (e) {
      debugPrint('[HomeController] Compatibility check error: $e');
    }
    return false;
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
