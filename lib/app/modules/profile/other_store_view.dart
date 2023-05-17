import 'package:cartisan/app/controllers/store_page_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/profile/components/other_store_profile_card.dart';
import 'package:cartisan/app/modules/profile/components/report_pop_up.dart';
import 'package:cartisan/app/modules/profile/components/store_facility_column.dart';
import 'package:cartisan/app/modules/profile/grid_all_user_profile_post.dart';
import 'package:cartisan/app/modules/profile/list_all_user_profile_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class OtherStoreView extends StatelessWidget {
  final String userId;
  const OtherStoreView({
    required this.userId,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetX<StorePageController>(
      init: StorePageController(userId: userId),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              controller.storeOwner?.username ?? 'New User',
              style: AppTypography.kMedium18,
            ),
            actions: [
              ReportPopup(
                // ignore: avoid_annotating_with_dynamic
                onItemSelected: (dynamic value) {
                  switch (value) {
                    case 1:
                      // Do something for value 1.
                      break;
                    case 2:
                      // Do something for value 2.
                      break;
                  }
                },
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
                        OtherStoreProfileCard(
                          chatCallback: () {},
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        Text(
                          controller.storeOwner?.username ?? 'New user',
                          style: AppTypography.kMedium16,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          controller.storeOwner?.bio ?? '',
                          style: AppTypography.kMedium14
                              .copyWith(color: AppColors.kHintColor),
                        ),
                        SizedBox(height: 10.0.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StoreFacilityColumn(
                              iconPath: AppAssets.kDeliveryMan,
                              text: 'Free Pickup',
                              isAvailable:
                                  controller.storeOwner?.pickup ?? false,
                            ),
                            Container(
                              height: 50.h,
                              width: 1.w,
                              color: AppColors.kHintColor,
                            ),
                            StoreFacilityColumn(
                              iconPath: AppAssets.kFreeDelivery,
                              text: 'Free Shipping',
                              isAvailable:
                                  controller.storeOwner?.activeShipping ??
                                      false,
                            ),
                            Container(
                              height: 50.0.h,
                              width: 1.0.w,
                              color: AppColors.kHintColor,
                            ),
                            StoreFacilityColumn(
                              iconPath: AppAssets.kDeliveryTruck,
                              text: 'Local Delivery',
                              isAvailable:
                                  controller.storeOwner?.isDeliveryAvailable ??
                                      false,
                            ),
                          ],
                        ),
                        SizedBox(height: 36.h),
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
                Expanded(
                  child: TabBarView(
                    children: [
                      GridAllUserPosts(
                        userId: userId,
                      ),
                      ListAllUserPosts(
                        userId: userId,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
