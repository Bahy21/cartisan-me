// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/cart/cart_view_pages.dart';
import 'package:cartisan/app/modules/chat/all_chats.dart';
import 'package:cartisan/app/modules/profile/components/other_store_facility_card.dart';
import 'package:cartisan/app/modules/profile/components/profile_card.dart';
import 'package:cartisan/app/modules/profile/components/report_pop_up.dart';
import 'package:cartisan/app/modules/profile/components/store_facility_column.dart';
import 'package:cartisan/app/modules/profile/edit_store_view.dart';
import 'package:cartisan/app/modules/profile/gridview_profile_post.dart';
import 'package:cartisan/app/modules/profile/listview_profile_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class StoreView extends StatelessWidget {
  final bool isProfileOwner;
  const StoreView({
    required this.isProfileOwner,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Thrift Store',
          style: AppTypography.kMedium18,
        ),
        actions: [
          if (isProfileOwner)
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
            )
          else
            const SizedBox(),
          if (isProfileOwner)
            IconButton(
              onPressed: () {
                Get.to<Widget>(() => const AllChats());
              },
              icon: SvgPicture.asset(AppAssets.kChat),
            )
          else
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
                    ProfileCard(
                      editCallback: () {
                        Get.to<Widget>(
                          () => const EditStoreView(),
                        );
                      },
                      chatCallback: () {},
                      followCallback: () {},
                      isProfileOwner: isProfileOwner,
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Text('Thrift Store', style: AppTypography.kMedium16),
                    Text(
                      'This is the new thrift store.',
                      style: AppTypography.kMedium14
                          .copyWith(color: AppColors.kHintColor),
                    ),
                    SizedBox(height: 30.0.h),
                    if (isProfileOwner)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StoreFacilityColumn(
                            iconPath: AppAssets.kDeliveryMan,
                            text: 'Free Pickup',
                            isAvailable: false,
                          ),
                          Container(
                            height: 50.h,
                            width: 1.w,
                            color: AppColors.kHintColor,
                          ),
                          StoreFacilityColumn(
                            iconPath: AppAssets.kFreeDelivery,
                            text: 'Free Shipping',
                          ),
                          Container(
                            height: 50.0.h,
                            width: 1.0.w,
                            color: AppColors.kHintColor,
                          ),
                          StoreFacilityColumn(
                            iconPath: AppAssets.kDeliveryTruck,
                            text: 'Local Delivery',
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          const OtherStoreFacilityCard(
                            text: 'Free Pickup Available',
                            isAvailable: true,
                          ),
                          SizedBox(height: AppSpacing.tenVertical),
                          const OtherStoreFacilityCard(
                            text: 'Shipping Available',
                            isAvailable: false,
                          ),
                          SizedBox(height: AppSpacing.tenVertical),
                          const OtherStoreFacilityCard(
                            text: 'Local Delivery',
                            isAvailable: false,
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
            const Expanded(
              child: TabBarView(
                children: [
                  // GridView.builder.
                  GridViewProfilePost(),

                  // ListView.
                  ListViewProfilePost(),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
