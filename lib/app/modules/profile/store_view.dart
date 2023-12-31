// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/cart/cart_view_pages.dart';
import 'package:cartisan/app/modules/chat/chat_room_view.dart';
import 'package:cartisan/app/modules/profile/components/profile_card.dart';
import 'package:cartisan/app/modules/profile/components/store_facility_column.dart';
import 'package:cartisan/app/modules/profile/edit_store_view.dart';
import 'package:cartisan/app/modules/profile/grid_all_user_profile_post.dart';
import 'package:cartisan/app/modules/profile/list_all_user_profile_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class StoreView extends StatelessWidget {
  StoreView({
    Key? key,
  }) : super(key: key);
  final uc = Get.find<UserController>();
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
              Get.to<Widget>(ChatRoomView.new);
            },
            icon: SvgPicture.asset(AppAssets.kChat),
          ),
          SizedBox(
            width: 10.w,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          // TODO: ADD REFRESH CALL
          return Future<void>.value();
        },
        child: SizedBox(
          height: Get.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.seventeenHorizontal,
                ),
                child: ProfileCard(
                  editCallback: () {
                    Get.to<Widget>(
                      EditStoreView.new,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.seventeenHorizontal,
                ),
                child: Text(uc.currentUser?.username ?? 'New user',
                    style: AppTypography.kMedium16),
              ),
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.seventeenHorizontal,
                ),
                child: Text(
                  uc.currentUser?.bio ?? '',
                  style: AppTypography.kMedium14
                      .copyWith(color: AppColors.kHintColor),
                ),
              ),
              SizedBox(height: 30.0.h),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.seventeenHorizontal,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StoreFacilityColumn(
                      iconPath: AppAssets.kDeliveryMan,
                      text: 'Free Pickup',
                      isAvailable: uc.currentUser?.pickup ?? false,
                    ),
                    Container(
                      height: 50.h,
                      width: 1.w,
                      color: AppColors.kHintColor,
                    ),
                    StoreFacilityColumn(
                      iconPath: AppAssets.kFreeDelivery,
                      text: 'Free Shipping',
                      isAvailable: uc.currentUser?.activeShipping ?? false,
                    ),
                    Container(
                      height: 50.0.h,
                      width: 1.0.w,
                      color: AppColors.kHintColor,
                    ),
                    StoreFacilityColumn(
                      iconPath: AppAssets.kDeliveryTruck,
                      text: 'Local Delivery',
                      isAvailable: uc.currentUser?.isDeliveryAvailable ?? false,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 36.h),
              DefaultTabController(
                length: 2,
                child: SizedBox(
                  height: Get.height * 0.45,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                    const Expanded(
                      child: TabBarView(
                        children: [
                          // GridView.builder.
                          GridAllUserPosts(),

                          // ListView.
                          ListAllUserPosts(),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
