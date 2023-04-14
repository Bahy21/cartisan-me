import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
            onTap: () {},
            title: Text('Blocked User', style: AppTypography.kMedium14),
            trailing: SvgPicture.asset(AppAssets.kChevronRight),
          ),
        ],
      ),
    );
  }
}
