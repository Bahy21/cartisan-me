import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/side_menu/settings/blocked_users_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Settings', style: AppTypography.kLight18),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              Get.to<Widget>(BlockedUsersView.new);
            },
            title: Text('Blocked User', style: AppTypography.kMedium14),
            trailing: SvgPicture.asset(AppAssets.kChevronRight),
          ),
        ],
      ),
    );
  }
}
