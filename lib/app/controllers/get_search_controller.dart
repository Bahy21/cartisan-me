import 'package:algolia/algolia.dart';
import 'package:cartisan/app/modules/search/algolia.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetSearchController extends GetxController {
  AlgoliaApplication algolia = AlgoliaApplication();
  // these variables will hold search results
  Rx<List<AlgoliaObjectSnapshot>?> _postSearchResults =
      Rx<List<AlgoliaObjectSnapshot>?>([]);

//Text editing controllers
  Rx<TextEditingController> _serviceSearchController =
      Rx<TextEditingController>(TextEditingController());
  TextEditingController get serviceSearchController =>
      _serviceSearchController.value;

  void setServiceCursorAtEnd() {
    _serviceSearchController.value.selection = TextSelection.fromPosition(
        TextPosition(offset: _serviceSearchController.value.text.length));
  }

  RxBool _isSearching = false.obs;
  bool get isSearching => _isSearching.value;
  int get totalPostsFound => _postSearchResults.value?.length ?? 0;
  @override
  void onInit() {
    // adding listener to the text editing controller

    serviceSearchController.addListener(() async {
      _isSearching.value = true;
      await 1.seconds.delay();

      await algolia
          .getSearchResult(serviceSearchController.text, SearchType.posts)
          .then((value) {
        // _serviceController.value = value;
      });
      _isSearching.value = false;
    });

    super.onInit();
  }
}
