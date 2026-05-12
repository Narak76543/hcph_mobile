import 'package:get/get.dart';
import 'package:school_assgn/features/search/controllers/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchFeatureController>(() => SearchFeatureController());
  }
}
