import 'package:cartisan/app/data/constants/app_assets.dart';
import 'package:cartisan/app/modules/camera/camera_view.dart';
import 'package:cartisan/app/modules/home/home_view.dart';
import 'package:cartisan/app/modules/landingPage/components/custom_bottom_bar.dart';
import 'package:cartisan/app/modules/landingPage/components/custom_bottom_bar_item.dart';
import 'package:cartisan/app/modules/notification/notification_page_view.dart';
import 'package:cartisan/app/modules/profile/store_view.dart';
import 'package:cartisan/app/modules/search/search_view.dart';
import 'package:cartisan/app/modules/sidemenu/side_menu.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeView(
        scaffoldKey: scaffoldKey,
      ),
      SearchView(),
      const CameraView(),
      const NotificationPageView(),
      StoreView(
        isProfileOwner: true,
      ),
    ];
    return Scaffold(
      key: scaffoldKey,
      drawer: const SideMenu(),
      body: pages[_currentIndex],
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
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
    );
  }
}
