import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SideMenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const SideMenuItem({
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.w,
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: AppTypography.kBold14,
        ),
        trailing: SvgPicture.asset(AppAssets.kChevronRight),
      ),
    );
  }
}
