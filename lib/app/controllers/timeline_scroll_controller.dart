import 'dart:developer';

import 'package:cartisan/app/controllers/timeline_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimelineScrollController extends GetxController {
  final tc = Get.find<TimelineController>();

  final _timelineScrollController = ScrollController().obs;
  ScrollController get timelineController => _timelineScrollController.value;

  @override
  void onReady() {
    timelineController.addListener(loadListener);
    super.onReady();
  }

  void loadListener() {
    log('All posts sroll sontroller online');
    final pos = timelineController.position;
    if (pos.pixels == pos.maxScrollExtent) {
      log('condition true, gfetting new posts');
      if (tc.hasMore) {
        tc.fetchPosts();
      }
    }
  }
}
