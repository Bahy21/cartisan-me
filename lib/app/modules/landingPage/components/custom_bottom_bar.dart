import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/landingPage/components/custom_bottom_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

typedef ItemBuilder = Widget Function(
  BuildContext context,
  int index,
  CustomBottomBarItem items,
);

class CustomBottomBar extends StatefulWidget {
  final List<CustomBottomBarItem> items;
  final int currentIndex;
  final void Function(int val)? onTap;
  final Color selectedBackgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Color backgroundColor;
  final double fontSize;
  final double iconSize;
  final double itemBorderRadius;
  final double borderRadius;
  final ItemBuilder itemBuilder;
  final double width;

  CustomBottomBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    Key? key,
    ItemBuilder? itemBuilder,
    this.backgroundColor = Colors.black,
    this.selectedBackgroundColor = Colors.white,
    this.selectedItemColor = Colors.black,
    this.iconSize = 24.0,
    this.fontSize = 11.0,
    this.borderRadius = 8,
    this.itemBorderRadius = 8,
    this.unselectedItemColor = Colors.white,
    this.width = double.infinity,
  })  : assert(items.length > 1),
        assert(items.length <= 5),
        assert(currentIndex <= items.length),
        assert(width > 50),
        itemBuilder = itemBuilder ??
            _defaultItemBuilder(
              width: width,
              currentIndex: currentIndex,
              itemBorderRadius: itemBorderRadius,
              items: items,
              onTap: onTap,
            ),
        super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  List<CustomBottomBarItem> get items => widget.items;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color(0x00ffffff),
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 66.h,
            margin: EdgeInsets.only(
              left: AppSpacing.fourteenHorizontal,
              right: AppSpacing.fourteenHorizontal,
              bottom: AppSpacing.fourteenVertical,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: AppColors.kGrey,
            ),
            width: widget.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: items
                    .asMap()
                    .map((i, f) {
                      return MapEntry(i, widget.itemBuilder(context, i, f));
                    })
                    .values
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

ItemBuilder _defaultItemBuilder({
  required List<CustomBottomBarItem> items,
  Function(int val)? onTap,
  int? currentIndex,
  double width = double.infinity,
  double? itemBorderRadius,
}) {
  return (context, index, item) => Expanded(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(itemBorderRadius!),
              ),
              child: InkWell(
                onTap: () {
                  onTap!(index);
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: width.isFinite
                      ? (width / items.length - 8)
                      : MediaQuery.of(context).size.width / items.length - 24,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                  child: item.customWidget == null
                      ? SvgPicture.asset(
                          item.iconPath!,
                          colorFilter: ColorFilter.mode(
                            currentIndex == index
                                ? AppColors.kPrimary
                                : AppColors.kWhite,
                            BlendMode.srcIn,
                          ),
                        )
                      : item.customWidget!,
                ),
              ),
            ),
          ],
        ),
      );
}
