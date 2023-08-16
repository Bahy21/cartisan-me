import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/cart/cart_view_pages.dart';
import 'package:cartisan/app/modules/home/components/timeline_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45.w,
        leading: Padding(
          padding: EdgeInsets.only(bottom: 6.0.w),
          child: IconButton(
            onPressed: () {
              widget.scaffoldKey.currentState!.openDrawer();
            },
            icon: SizedBox(child: SvgPicture.asset(AppAssets.kMenu)),
          ),
        ),
        centerTitle: true,
        title: Text(
          'CARTISAN',
          style: TextStyle(
            fontFamily: 'aero_regular',
            fontSize: 22.sp,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        actions: [
          badges.Badge(
            position: badges.BadgePosition.topEnd(top: -10, end: -12),
            showBadge: true,
            ignorePointer: false,
            onTap: () {},
            badgeContent: Text(
              '1',
              style: TextStyle(fontSize: 11.sp),
            ),
            badgeAnimation: const badges.BadgeAnimation.rotation(
              animationDuration: Duration(seconds: 1),
              colorChangeAnimationDuration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              colorChangeAnimationCurve: Curves.easeInCubic,
            ),
            badgeStyle: badges.BadgeStyle(
              badgeColor: AppColors.kPrimary,
              padding: EdgeInsets.all(6.h),
              elevation: 0,
            ),
            child: InkWell(
              onTap: () {
                Get.to<Widget>(CartViewPages.new);
              },
              child: SvgPicture.asset(
                AppAssets.kCart
              ),
            ),
          ),
          SizedBox(width: AppSpacing.fourteenHorizontal),
        ],
      ),
      body: const TimelineView(),
    );
  }
}
