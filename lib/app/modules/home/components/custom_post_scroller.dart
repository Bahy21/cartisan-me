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
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => tc.refreshActivity(),
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        controller: widget.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: widget.children,
        ),
      ),
    );
  }
}
