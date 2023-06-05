import 'dart:developer';

import 'package:cartisan/app/controllers/landing_page_controller.dart';
import 'package:cartisan/app/data/constants/app_assets.dart';
import 'package:cartisan/app/modules/add_post/components/product_image_picker_dialog.dart';
import 'package:cartisan/app/modules/home/home_view.dart';
import 'package:cartisan/app/modules/landingPage/components/custom_bottom_bar.dart';
import 'package:cartisan/app/modules/landingPage/components/custom_bottom_bar_item.dart';
import 'package:cartisan/app/modules/notification/notification_page_view.dart';
import 'package:cartisan/app/modules/profile/components/user_seller_wrapper.dart';
import 'package:cartisan/app/modules/search/search_view.dart';
import 'package:cartisan/app/modules/side_menu/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeView(
        scaffoldKey: scaffoldKey,
      ),
      const SearchView(),
      CreateProductRoot(),
      const NotificationPageView(),
      const UserSellerWrapper(),
    ];
    return GetX<LandingPageController>(
      init: LandingPageController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.currentIndex = 0;

            return false;
          },
          child: Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            key: scaffoldKey,
            drawer: SideMenu(),
            body: pages[controller.currentIndex],
            bottomNavigationBar: CustomBottomBar(
              currentIndex: controller.currentIndex,
              onTap: (index) {
                controller.currentIndex = index;
              },
              items: [
                CustomBottomBarItem(
                  iconPath: AppAssets.kHome,
                ),
                CustomBottomBarItem(
                  iconPath: AppAssets.kSearch,
                ),
                CustomBottomBarItem(
                  iconPath: AppAssets.kCamera,
                ),
                CustomBottomBarItem(
                  iconPath: AppAssets.kHeart,
                ),
                CustomBottomBarItem(
                  iconPath: AppAssets.kUser,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
