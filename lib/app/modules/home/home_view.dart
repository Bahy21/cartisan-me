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
  @override
  void initState() {
    tc.fetchPosts();
    super.initState();
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
      body: FutureBuilder<bool>(
        future: tc.fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingDialog();
          }
          if (!snapshot.hasData || snapshot.data == false) {
            return const Center(
              child: Text(
                'Nothing found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return ListView.separated(
            itemBuilder: (context, index) {
              return PostCard(
                post: tc.timelinePosts.value[index],
                index: index,
                addToCartCallback: () {
                  showToast('Added to cart');
                },
                buyNowCallback: () {},
                reportCallback: () {},
              );
            },
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            separatorBuilder: (context, index) => SizedBox(height: 13.h),
            itemCount:
                tc.timelinePosts.value.length, //TODO: ADD ACTUAL posts.length,
          );
        },
      ),
    );
  }
}
