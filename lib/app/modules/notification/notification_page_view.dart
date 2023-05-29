import 'dart:developer';

import 'package:cartisan/app/api_classes/notifications_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/data/constants/app_typography.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/notification_model.dart';
import 'package:cartisan/app/modules/notification/components/notification_card.dart';
import 'package:cartisan/app/modules/widgets/buttons/custom_text_button.dart';
import 'package:cartisan/app/modules/widgets/dialogs/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NotificationPageView extends StatefulWidget {
  const NotificationPageView({super.key});

  @override
  State<NotificationPageView> createState() => _NotificationPageViewState();
}

class _NotificationPageViewState extends State<NotificationPageView> {
  static const _pageSize = 15;
  final PagingController<int, NotificationModel> _pagingController =
      PagingController(firstPageKey: 0);
  final notifsApi = NotificationsAPI();
  int retries = 0;
  @override
  void initState() {
    _pagingController.addPageRequestListener(_fetchPage);
    super.initState();
  }

  Future<void> _clearNotifications() async {
    await Get.dialog<Widget>(const LoadingDialog(), barrierDismissible: false);
    final result = await notifsApi.clearNotifications(
      Get.find<AuthService>().currentUser!.uid,
    );
    if (result) {
      Get.back<void>();
      _pagingController.refresh();
    } else {
      Get.back<void>();
      await showErrorDialog('Error clearing notifications');
    }
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final uid = Get.find<AuthService>().currentUser!.uid;
      final alltems = _pagingController.value.itemList;
      final newItems = await notifsApi.getNotifications(
        userId: uid,
        lastSentNotificationId:
            alltems == null ? null : alltems[pageKey - 1].notificationId,
        limit: _pageSize,
      );
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } on Exception catch (error) {
      if (retries < 3) {
        await _fetchPage(pageKey);
      }
      retries++;
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'All Notifications',
          style: AppTypography.kLight18,
        ),
        actions: [
          CustomTextButton(
            onPressed: _clearNotifications,
            text: 'Clear All',
            fontSize: 12.sp,
          ),
        ],
      ),
      body: PagedListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<NotificationModel>(
          itemBuilder: (context, item, index) {
            log(item.toString());
            return NotificationCard(
              notification: item,
            );
          },
        ),
        separatorBuilder: (context, index) => SizedBox(
          height: AppSpacing.tenVertical,
        ),
      ),
    );
  }
}
