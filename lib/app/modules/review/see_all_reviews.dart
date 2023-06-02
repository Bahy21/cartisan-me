import 'package:cartisan/app/api_classes/post_api.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/review_model.dart';
import 'package:cartisan/app/modules/review/review_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SeeAllReviews extends StatefulWidget {
  final String postId;
  const SeeAllReviews({required this.postId, super.key});

  @override
  State<SeeAllReviews> createState() => _SeeAllReviewsState();
}

class _SeeAllReviewsState extends State<SeeAllReviews> {
  final _pageSize = 10;
  final postApi = PostAPI();
  final _pageController = PagingController<int, ReviewModel>(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pageController.addPageRequestListener(_fetchPage);
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final allItems = _pageController.value.itemList;

      final result = await postApi.getPostReviews(
        widget.postId,
        lastSentReviewId:
            (allItems?.isEmpty ?? true) ? null : allItems!.last.reviewID,
      );
      final isLastPage = result.length < _pageSize;
      if (isLastPage) {
        _pageController.appendLastPage(result);
      } else {
        final nextPageKey = pageKey + result.length;
        _pageController.appendPage(result, nextPageKey);
      }
    } on Exception catch (e) {
      _pageController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reviews'),
          centerTitle: true,
        ),
        body: PagedListView<int, ReviewModel>(
          pagingController: _pageController,
          builderDelegate: PagedChildBuilderDelegate<ReviewModel>(
            itemBuilder: (context, item, index) {
              return ReviewCard(review: item);
            },
          ),
        ),
      ),
    );
  }
}
