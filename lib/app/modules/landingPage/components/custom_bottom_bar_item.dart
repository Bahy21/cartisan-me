import 'package:flutter/material.dart';

class CustomBottomBarItem {
  final String? iconPath;
  final Widget? customWidget;

  CustomBottomBarItem({
    this.iconPath,
    this.customWidget,
  }) : assert(iconPath != null || customWidget != null);
}
