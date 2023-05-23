import 'dart:developer';

import 'package:algolia/algolia.dart';
import 'package:cartisan/app/data/constants/app_assets.dart';
import 'package:cartisan/app/data/constants/app_colors.dart';
import 'package:cartisan/app/data/constants/app_typography.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlgoliaApplication {
  static const Algolia algolia = Algolia.init(
    applicationId: '4FJGPZFDXQ', //ApplicationID
    apiKey:
        '1fcf1534544cfbdb221bfcc225e3d573', //search-only api key in flutter code
  );

  Future<List<AlgoliaObjectSnapshot>> getSearchResult(
    String input,
    SearchType searchType,
  ) async {
    log('getting results for $input');
    final query = AlgoliaApplication.algolia.instance
        .index('cartisan')
        .query(input)
        .setOffset(0)
        .setHitsPerPage(25);

    try {
      final querySnap = await query.getObjects();
      log(querySnap.hits.toString());
      return querySnap.hits;
    } on AlgoliaError catch (e) {
      log(e.error.toString());
      return [];
    }
  }
}

String getCollectionName(SearchType searchType) {
  switch (searchType) {
    case SearchType.posts:
      return SearchCollections.posts;
    default:
      return '';
  }
}

class AlgoliaSearchField extends StatelessWidget {
  final SearchType searchType;
  final Function(List<AlgoliaObjectSnapshot>) onSearchComplete;
  final Function(bool) isSearching;
  final TextEditingController controller;
  // var tec = TextEditingController();

  AlgoliaSearchField({
    required this.searchType,
    required this.isSearching,
    required this.onSearchComplete,
    required this.controller,
    super.key,
  });

  final algolia = AlgoliaApplication();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: 365.w,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          value.isNotEmpty ? isSearching(true) : isSearching(false);
          EasyDebounce.debounce(
            'my-debouncer', // <-- An ID for this particular debouncer
            const Duration(milliseconds: 1000), // <-- The debounce duration
            () => algolia.getSearchResult(value, searchType).then((value) {
              onSearchComplete(value);
              isSearching(false);
            }), // <-- The target method
          );
        },
        style: AppTypography.kExtraLight15,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: 'Search',
          contentPadding: EdgeInsets.zero,
          hintStyle:
              AppTypography.kExtraLight15.copyWith(color: AppColors.kHintColor),
          prefixIcon: Padding(
            padding: EdgeInsets.all(12.h),
            child: SvgPicture.asset(
              AppAssets.kSearch,
              height: 16.h,
              width: 16.w,
            ),
          ),
        ),
      ),
    );
  }
}

enum SearchType { posts }

class SearchCollections {
  static String posts = 'posts';
}
