import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildPopupMenu(List<PopupMenuItem> options) {
  return PopupMenuButton<dynamic>(
    child: Container(
      padding: EdgeInsets.only(right: Get.width * 0.02),
      child: Icon(Icons.more_vert_rounded),
    ),
    padding: EdgeInsets.zero,
    itemBuilder: (BuildContext context) => options,
  );
}
