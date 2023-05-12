import 'package:cartisan/app/controllers/timeline_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/modules/cart/cart_view_pages.dart';
import 'package:cartisan/app/modules/home/components/custom_post_scroller.dart';
import 'package:cartisan/app/modules/home/components/post_card.dart';
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

  final ScrollController _scrollController = ScrollController();

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
      body: Column(
        children: [
          SizedBox(height: AppSpacing.twentyFourVertical),
          Expanded(
            child: Obx(
              () {
                if (tc.isLoading) {
                  return Center(
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor),
                    ),
                  );
                }
                if (tc.timelinePosts.isEmpty) {
                  return const Center(child: SizedBox.shrink());
                } else {
                  return CustomPostScroller(
                    children: [
                      for (final post in tc.timelinePosts)
                        PostCard(
                          post: post,
                          index: tc.timelinePosts.indexOf(post),
                        ),
                    ],
                    scrollController: _scrollController,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
