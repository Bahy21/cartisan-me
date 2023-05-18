import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImagesCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const ImagesCard({
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.topRight,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: NetworkImage(
              'https://cdn.dribbble.com/users/6047818/screenshots/16425364/media/a855b66a9d41c79ef04ba5dd258516ef.png?compress=1&resize=1200x900',
            ),
            fit: BoxFit.cover,
          ),
          border: Border.all(
            color: isSelected ? AppColors.kPrimary : Colors.transparent,
            width: 2,
          ),
        ),
        child: isSelected
            ? SvgPicture.asset(AppAssets.kCheckCircle)
            : const SizedBox(),
      ),
    );
  }
}
