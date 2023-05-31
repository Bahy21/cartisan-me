import 'package:cartisan/app/controllers/chat_controller.dart';
import 'package:cartisan/app/controllers/post_controller.dart';
import 'package:cartisan/app/controllers/search_page_controller.dart';
import 'package:cartisan/app/controllers/timeline_controller.dart';
import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<UserController>(UserController.new, fenix: true)
      ..lazyPut<TimelineController>(TimelineController.new, fenix: true)
      ..lazyPut<ChatController>(ChatController.new, fenix: true)
      ..lazyPut<TimelineController>(TimelineController.new, fenix: true)
      ..lazyPut<SearchPageController>(SearchPageController.new, fenix: true)
      ..lazyPut<PostController>(PostController.new, fenix: true);
  }
}
