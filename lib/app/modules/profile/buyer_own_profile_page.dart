import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/data/constants/app_assets.dart';
import 'package:cartisan/app/data/constants/app_colors.dart';
import 'package:cartisan/app/data/constants/app_typography.dart';
import 'package:cartisan/app/modules/cart/cart_view_pages.dart';
import 'package:cartisan/app/modules/chat/all_chats.dart';
import 'package:cartisan/app/modules/profile/components/no_pictures.dart';
import 'package:cartisan/app/modules/profile/components/profile_card.dart';
import 'package:cartisan/app/modules/profile/edit_store_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BuyerOwnProfilePage extends StatelessWidget {
  BuyerOwnProfilePage({super.key});
  final UserController uc = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          uc.currentUser?.username ?? 'New User',
          style: AppTypography.kMedium18,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to<Widget>(CartViewPages.new);
            },
            icon: SvgPicture.asset(
              AppAssets.kCart,
              colorFilter: const ColorFilter.mode(
                AppColors.kPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Get.to<Widget>(() => const AllChats());
            },
            icon: SvgPicture.asset(AppAssets.kChat),
          ),
          SizedBox(
            width: 10.w,
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    ProfileCard(
                      editCallback: () {
                        Get.to<Widget>(
                          EditStoreView.new,
                        );
                      },
                      chatCallback: () {},
                      followCallback: () {},
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(uc.currentUser?.profileName ?? 'New User',
                        style: AppTypography.kMedium16),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      uc.currentUser?.bio ?? '',
                      style: AppTypography.kMedium14
                          .copyWith(color: AppColors.kHintColor),
                    ),
                    SizedBox(height: 46.0.h),
                  ],
                ),
              ),
            ),
          ];
        },
        body: DefaultTabController(
          length: 2,
          child: Column(children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              child: TabBar(
                labelColor: AppColors.kPrimary,
                unselectedLabelColor: AppColors.kHintColor,
                indicatorColor: AppColors.kPrimary,
                tabs: [
                  Tab(
                    icon: SvgPicture.asset(AppAssets.kGrid),
                  ),
                  Tab(
                    icon: SvgPicture.asset(AppAssets.kList),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            const Expanded(
              child: TabBarView(
                children: [
                  NoPictures(),
                  NoPictures(),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
