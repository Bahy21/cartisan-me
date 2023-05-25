import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/cart/cart_view_pages.dart';
import 'package:cartisan/app/modules/home/components/timeline_view.dart';
import 'package:cartisan/app/modules/widgets/dialogs/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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
            icon: SvgPicture.asset(AppAssets.kMenu),
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
          IconButton(
            onPressed: () {
              Get.to<Widget>(CartViewPages.new);
            },
            icon: SvgPicture.asset(
              AppAssets.kCart,
            ),
          ),
          IconButton(
            onPressed: () {
              showToast('sample toast');
            },
            icon: Icon(Icons.breakfast_dining),
          ),
          SizedBox(width: AppSpacing.fourteenHorizontal),
        ],
      ),
      body: const TimelineView(),
    );
  }
}
