import 'package:cartisan/app/api_classes/search_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/search_model.dart';
import 'package:get/get.dart';

class SearchPageController extends GetxController {
  final searchApi = SearchAPI();

  String get _currentUid => Get.find<AuthService>().currentUser!.uid;

  List<SearchModel> get searchPosts => _searchPosts.value;
  bool get isLoading => _isLoading.value;
  Rx<List<SearchModel>> _searchPosts = Rx<List<SearchModel>>([]);
  RxBool _isLoading = true.obs;
  @override
  void onInit() {
    populateSearchPosts();
    super.onInit();
  }

  Future<void> populateSearchPosts() async {
    _searchPosts.value = await searchApi.getSearches(_currentUid);
    _isLoading.value = false;
  }
}
