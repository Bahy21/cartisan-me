import 'dart:developer';

import 'package:cartisan/app/controllers/timeline_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/modules/cart/cart_view_pages.dart';
import 'package:cartisan/app/modules/home/components/post_card.dart';
import 'package:cartisan/app/modules/sidemenu/side_menu.dart';
import 'package:cartisan/app/modules/widgets/dialogs/loading_dialog.dart';
import 'package:cartisan/app/modules/widgets/dialogs/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeView({
    required this.scaffoldKey,
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final tc = Get.find<TimelineController>();

  final int limit = 10;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isMoreLoadRunning = false;
  late ScrollController _controller;
  List<PostModel> _posts = <PostModel>[];

  @override
  void initState() {
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
    super.initState();
  }

  Future<void> _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      final newPosts = await tc.fetchPosts(limit);
      _posts = newPosts;
      setState(() {
        _isFirstLoadRunning = false;
      });
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isMoreLoadRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isMoreLoadRunning = true;
      });
      try {
        log('calling more posts');
        final newPosts = await tc.fetchPosts(limit);
        if (newPosts.isNotEmpty) {
          setState(() {
            _posts.addAll(newPosts);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } on Exception catch (e) {
        log(e.toString());
      }
    }
    setState(() {
      _isMoreLoadRunning = false;
    });
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_loadMore)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 64.w,
        leading: IconButton(
          onPressed: () {
            widget.scaffoldKey.currentState!.openDrawer();
          },
          icon: SvgPicture.asset(AppAssets.kMenu),
        ),
        centerTitle: true,
        title: Text(
          'CARTISAN',
          style: GoogleFonts.didactGothic(
            textStyle: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to<Widget>(CartViewPages.new);
            },
            icon: SvgPicture.asset(AppAssets.kCart),
          ),
          SizedBox(width: AppSpacing.fourteenHorizontal),
        ],
      ),
      body: _isFirstLoadRunning
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _posts.length,
                    controller: _controller,
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    itemBuilder: (_, index) {
                      return PostCard(
                        post: _posts[index],
                        index: index,
                        addToCartCallback: () {
                          showToast('Added to cart');
                        },
                        buyNowCallback: () {},
                        reportCallback: () {},
                      );
                    },
                  ),
                ),
                if (_isMoreLoadRunning == true)
                  Padding(
                    padding: EdgeInsets.only(top: 10.h, bottom: 35.h),
                    child: const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                if (_hasNextPage == false)
                  Container(
                    padding: EdgeInsets.only(top: 30.h, bottom: 40.h),
                    color: Colors.amber,
                    child: const Center(
                      child: Text('You have fetched all of the content'),
                    ),
                  ),
              ],
            ),
    );
  }
}
