import 'dart:developer';

import 'package:cartisan/app/controllers/cart_service.dart';
import 'package:cartisan/app/controllers/controllers.dart';
import 'package:cartisan/app/controllers/timeline_controller.dart';
import 'package:cartisan/app/controllers/timeline_scroll_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/modules/cart/cart_view_pages.dart';
import 'package:cartisan/app/modules/home/components/custom_post_scroller.dart';
import 'package:cartisan/app/modules/home/components/post_card.dart';
import 'package:cartisan/app/modules/widgets/dialogs/toast.dart';
import 'package:cartisan/app/services/api_calls.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dio/dio.dart';
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
  final tsc = Get.find<TimelineScrollController>();

  void addToCart(PostModel post) async {
    final result = await Get.find<CartService>().addToCart(post);
    if (result) {
      showToast('Item added to cart');
    } else {
      Get.snackbar('Error', 'Something went wrong');
    }
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
      body: Obx(
        () {
          if (tc.firstLoading) {
            return Center(
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).primaryColor,
                ),
              ),
            );
          }

          return CustomPostScroller(
            children: [
              ...List.generate(
                tc.timelinePosts.length,
                (index) => PostCard(
                  index: index,
                  post: tc.timelinePosts[index],
                  addToCartCallback: () {
                    addToCart(tc.timelinePosts[index]);
                  },
                ),
              ),
              if (tc.arePostsostLoading)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Center(
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
            ],
            scrollController: tsc.timelineController,
          );
        },
      ),
    );
  }
}
