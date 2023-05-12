import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/services/api_calls.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class SearchPageController extends GetxController {
  final Dio dio = Dio();
  final ApiCalls apiCalls = ApiCalls();
  final as = Get.find<AuthService>();

  String get _currentUid => as.currentUser!.uid;

  List<PostModel> get searchPosts => _searchPosts.value;
  bool get isLoading => _isLoading.value;
  Rx<List<PostModel>> _searchPosts = Rx<List<PostModel>>([]);
  RxBool _isLoading = true.obs;
  @override
  void onInit() {
    populateSearchPosts();
    super.onInit();
  }

  Future<void> populateSearchPosts() async {
    final result = await dio
        .get<Map>(apiCalls.getApiCalls.getTimeline(_currentUid, count: 20));
    final postsGotten = result.data!['result'] as List;
    for (var postGotten in postsGotten) {
      searchPosts.add(PostModel.fromMap(postGotten as Map<String, dynamic>));
    }
    _isLoading.value = false;
  }
}
