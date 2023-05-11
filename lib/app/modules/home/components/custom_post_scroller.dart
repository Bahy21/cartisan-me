import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomPostScroller extends StatefulWidet{
  final List<Widget> children;
  final ScrollController controller;
  CustomPostScroller(
      {Key? key, required this.children, required this.scrollController})
      : super(key: key);

   @override
  State<CustomPostScroller> createState() => _CustomPostScrollerState();
}

class _CustomPostScrollerState extends State<CustomPostScroller> {

  TimelineController tc = Get.find<TimelineController>();

  @override
  void initState(){
    widget.scrollcontroller.addListener((){
      log('All posts sroll sontroller online');
      if(widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent){
            if(tc.hasMore){
              tc.fetchPosts();
            }
          }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => activityController.refreshActivity(),
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      color: Theme.of(context).primaryColor,
      child: ScrollConfiguration(
        behavior: NoGlowScrollAnimation(),
        child: ListView(
          controller: widget.scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          children: widget.children,
        ),
      ),
    )
  }
}
