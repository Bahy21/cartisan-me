import 'package:cartisan/app/controllers/get_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchFullScreen extends StatefulWidget {
  const SearchFullScreen({super.key});

  @override
  State<SearchFullScreen> createState() => SearchFullScreenState();
}

class SearchFullScreenState extends State<SearchFullScreen> {
  @override
  Widget build(BuildContext context) {
    return GetX<GetSearchController>(
        init: GetSearchController(),
        builder: (controller) {
          return Placeholder();
        });
  }
}
