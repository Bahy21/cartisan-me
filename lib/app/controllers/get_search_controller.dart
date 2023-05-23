import 'package:algolia/algolia.dart';
import 'package:cartisan/app/modules/search/algolia.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetSearchController extends GetxController {
  AlgoliaApplication algolia = AlgoliaApplication();
  // these variables will hold search results
  final Rx<List<AlgoliaObjectSnapshot>?> _postSearchResults =
      Rx<List<AlgoliaObjectSnapshot>?>([]);
  List<AlgoliaObjectSnapshot>? get postSearchResults =>
      _postSearchResults.value;
  set setPostSearchResults(List<AlgoliaObjectSnapshot> value) =>
      _postSearchResults.value = value;
  //Text editing controllers
  final Rx<TextEditingController> _postSearchController =
      Rx<TextEditingController>(TextEditingController());
  TextEditingController get postSearchController => _postSearchController.value;

  void setServiceCursorAtEnd() {
    _postSearchController.value.selection = TextSelection.fromPosition(
      TextPosition(
        offset: postSearchController.value.text.length,
      ),
    );
  }

  final RxBool _isSearching = false.obs;
  bool get isSearching => _isSearching.value;
  set setIsSearching(bool value) => _isSearching.value = value;
}
