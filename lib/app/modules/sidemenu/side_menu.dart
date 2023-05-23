import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/sidemenu/components/custom_drawer_header.dart';
import 'package:cartisan/app/modules/sidemenu/components/side_menu_item.dart';
import 'package:cartisan/app/modules/sidemenu/orders/all_orders.dart';
import 'package:cartisan/app/modules/sidemenu/settings/setting_view.dart';
import 'package:cartisan/app/modules/sidemenu/transactions/transaction_view.dart';
import 'package:cartisan/app/services/user_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SideMenu extends StatelessWidget {
  final uc = Get.find<UserController>();
  SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 310.h,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                const CustomDrawerHeader(),
                Positioned(
                  bottom: 0,
                  child: Column(
                    children: [
                      if (uc.currentUser?.url.isURL ?? false)
                        CircleAvatar(
                          radius: 60.r,
                          backgroundImage: CachedNetworkImageProvider(
                            uc.currentUser!.url,
                          ),
                        )
                      else
                        SizedBox(
                          height: 120.w,
                          width: 120.w,
                          child: Material(
                            borderRadius: BorderRadius.circular(200.r),
                            child: ClipOval(
                              child: Transform.translate(
                                offset: Offset(-13.w, 0),
                                child: Icon(
                                  Icons.person,
                                  size: 150.w,
                                  color: AppColors.kPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 14.h),
                      Text(uc.currentUser?.username ?? 'New User',
                          style: AppTypography.kBold16),
                      Text(
                        uc.currentUser?.email ?? 'No email found',
                        style: AppTypography.kBold14
                            .copyWith(color: AppColors.kHintColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          SideMenuItem(
            title: 'My Orders',
            onTap: () {
              Get
                ..back<void>()
                ..to<void>(() => const AllOrders());
            },
          ),
          // SideMenuItem(
          //   title: 'My Transactions',
          //   onTap: () {
          //     Get
          //       ..back<void>()
          //       ..to<void>(() => const TransactionView());
          //   },
          // ),
          SideMenuItem(
            title: 'Settings',
            onTap: () {
              Get
                ..back<void>()
                ..to<void>(() => const SettingView());
            },
          ),
          SideMenuItem(
            title: 'Log Out',
            onTap: () {
              UserAuthService().signOut();
            },
          ),
        ],
      ),
    );
  }
}
