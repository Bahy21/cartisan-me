import 'dart:developer';

import 'package:cartisan/app/controllers/timeline_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomPostScroller extends StatefulWidget {
  final List<Widget> children;
  final ScrollController scrollController;
  const CustomPostScroller({
    required this.children,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomPostScroller> createState() => _CustomPostScrollerState();
}

class _CustomPostScrollerState extends State<CustomPostScroller> {
  TimelineController tc = Get.find<TimelineController>();

  @override
  void initState() {
    widget.scrollController.addListener(() {
      log('All posts sroll sontroller online');
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        if (tc.hasMore) {
          tc.fetchPosts();
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => tc.refreshActivity(),
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      color: Theme.of(context).primaryColor,
      child: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: ListView(
          controller: widget.scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          children: widget.children,
        ),
      ),
    );
  }
}
