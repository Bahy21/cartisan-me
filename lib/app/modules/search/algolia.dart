import 'dart:convert';
import 'dart:developer';

import 'package:algolia/algolia.dart';
import 'package:cartisan/app/data/constants/app_colors.dart';
import 'package:cartisan/app/data/constants/app_typography.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    AlgoliaQuery query = AlgoliaApplication.algolia.instance
        .index(getCollectionName(searchType))
        .query(input)
        .setOffset(0)
        .setHitsPerPage(25);

    try {
      final querySnap = await query.getObjects();
      final results = querySnap.hits;
      final hitsList = results;

      return hitsList;
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.kWhite,
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          value.isNotEmpty ? isSearching(true) : isSearching(false);
          EasyDebounce.debounce(
            'my-debouncer', // <-- An ID for this particular debouncer
            Duration(milliseconds: 1000), // <-- The debounce duration
            () => algolia.getSearchResult(value, searchType).then((value) {
              onSearchComplete(value);
            }), // <-- The target method
          );
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: AppTypography.kMedium16
              .copyWith(color: AppColors.kGrey.withOpacity(0.40)),
          suffixIcon: const Icon(
            Icons.search,
            color: AppColors.kPrimary,
          ),
        ),
      ),
    );
  }
}

enum SearchType { posts }

class SearchCollections {
  static const String posts = 'posts';
}

class AlgoliaSearchResult {
  String id;
  String title;
  String subtitle;
  SearchType type;
  AlgoliaSearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'objectID': id,
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'type': type.index,
    };
  }

  factory AlgoliaSearchResult.fromMap(Map<String, dynamic> map, {String? id}) {
    return AlgoliaSearchResult(
      id: id ?? map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      type: SearchType.values[map['type'] as int],
    );
  }

  factory AlgoliaSearchResult.fromAlgolia(AlgoliaObjectSnapshot snapshot) {
    return AlgoliaSearchResult.fromMap(snapshot.data, id: snapshot.objectID);
  }

  String toJson() => json.encode(toMap());

  factory AlgoliaSearchResult.fromJson(String source) =>
      AlgoliaSearchResult.fromMap(json.decode(source) as Map<String, dynamic>);
}
