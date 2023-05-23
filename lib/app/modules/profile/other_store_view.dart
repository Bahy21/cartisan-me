import 'package:cartisan/app/api_classes/report_api.dart';
import 'package:cartisan/app/api_classes/social_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/controllers/chat_controller.dart';
import 'package:cartisan/app/controllers/store_page_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/modules/chat/basic_chat.dart';
import 'package:cartisan/app/modules/profile/components/other_store_profile_card.dart';
import 'package:cartisan/app/modules/profile/components/report_pop_up.dart';
import 'package:cartisan/app/modules/profile/components/store_facility_column.dart';
import 'package:cartisan/app/modules/profile/grid_all_user_profile_post.dart';
import 'package:cartisan/app/modules/profile/list_all_user_profile_post.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
import 'package:cartisan/app/modules/widgets/dialogs/loading_dialog.dart';
import 'package:cartisan/app/modules/widgets/dialogs/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class OtherStoreView extends StatefulWidget {
  final String userId;
  const OtherStoreView({
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  State<OtherStoreView> createState() => _OtherStoreViewState();
}

class _OtherStoreViewState extends State<OtherStoreView> {
  final socialApi = SocialAPI();
  final reportApi = ReportAPI();
  final chatController = Get.find<ChatController>();
  String get currentUid => Get.find<AuthService>().currentUser!.uid;

  Future<void> reportUser() async {
    await Get.dialog<Widget>(const LoadingDialog());
    final result = await reportApi.reportUser(
      reportedId: widget.userId,
      reportedFor: '',
    );
    if (result) {
      Get.back<void>();
      showToast('User Reported');
    } else {
      await showErrorDialog('Error reporting user');
    }
  }

  Future<void> blockUser() async {
    await Get.dialog<Widget>(const LoadingDialog());
    final result = await socialApi.blockUser(
      blockerId: currentUid,
      blockedId: widget.userId,
    );
    if (result) {
      Get.back<void>();
    } else {
      await showErrorDialog('Error blocking user');
    }
  }

  Future<void> startChat() async {
    await Get.dialog<Widget>(const LoadingDialog());
    final storeOwner = Get.find<StorePageController>().storeOwner!;
    final checkChatroomExists = await chatController.chatExists(storeOwner.id);
    if (checkChatroomExists == null) {
      final newChatRoom = await chatController.createChatroom(
        otherParticipant: storeOwner.id,
        otherParticipantName: storeOwner.username,
        otherParticipantPictureUrl: storeOwner.url,
      );
      if (newChatRoom == null) {
        Get.back<void>();
        await showErrorDialog('Error creating chatroom');
        return;
      }
      Get
        ..back<void>()
        ..to<Widget>(
          () => BasicChat(
            chatRoomModel: newChatRoom,
            otherParticipantName: storeOwner.username,
            otherParticipantAvatarURL: storeOwner.url,
          ),
        );
    } else {
      Get
        ..back<void>()
        ..to<Widget>(
          () => BasicChat(
            chatRoomModel: checkChatroomExists,
            otherParticipantName: storeOwner.profileName,
            otherParticipantAvatarURL: storeOwner.url,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<StorePageController>(
      init: StorePageController(userId: widget.userId),
      builder: (controller) {
        if (controller.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }
        if (controller.isBlocked) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Get.back<void>(),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.kWhite,
                ),
              ),
              centerTitle: true,
              title: Text(
                controller.storeOwner?.username ?? 'New User',
                style: AppTypography.kMedium18,
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppAssets.kCartisanLogo),
                Text(
                  '${controller.storeOwner!.username} is blocked',
                  style: AppTypography.kBold32.copyWith(
                    color: AppColors.kWhite,
                  ),
                ),
                SizedBox(
                  height: AppSpacing.eighteenVertical,
                ),
                PrimaryButton(
                    onTap: () => controller.unblockUser(), text: 'Unblock'),
              ],
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              controller.storeOwner?.username ?? 'New User',
              style: AppTypography.kMedium18,
            ),
            actions: [
              ReportPopup(
                // ignore: avoid_annotating_with_dynamic
                onSelected: (dynamic value) {
                  switch (value) {
                    case 1:
                      reportUser();
                      break;
                    case 2:
                      blockUser();
                      break;
                  }
                },
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
          body: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30.h,
                        ),
                        OtherStoreProfileCard(
                          chatCallback: startChat,
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        Text(
                          controller.storeOwner?.username ?? 'New user',
                          style: AppTypography.kMedium16,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          controller.storeOwner?.bio ?? '',
                          style: AppTypography.kMedium14
                              .copyWith(color: AppColors.kHintColor),
                        ),
                        SizedBox(height: 10.0.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StoreFacilityColumn(
                              iconPath: AppAssets.kDeliveryMan,
                              text: 'Free Pickup',
                              isAvailable:
                                  controller.storeOwner?.pickup ?? false,
                            ),
                            Container(
                              height: 50.h,
                              width: 1.w,
                              color: AppColors.kHintColor,
                            ),
                            StoreFacilityColumn(
                              iconPath: AppAssets.kFreeDelivery,
                              text: 'Free Shipping',
                              isAvailable:
                                  controller.storeOwner?.activeShipping ??
                                      false,
                            ),
                            Container(
                              height: 50.0.h,
                              width: 1.0.w,
                              color: AppColors.kHintColor,
                            ),
                            StoreFacilityColumn(
                              iconPath: AppAssets.kDeliveryTruck,
                              text: 'Local Delivery',
                              isAvailable:
                                  controller.storeOwner?.isDeliveryAvailable ??
                                      false,
                            ),
                          ],
                        ),
                        SizedBox(height: 36.h),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: DefaultTabController(
              length: 2,
              child: Column(children: [
                DecoratedBox(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: TabBar(
                    labelColor: AppColors.kPrimary,
                    unselectedLabelColor: AppColors.kHintColor,
                    indicatorColor: AppColors.kPrimary,
                    tabs: [
                      Tab(
                        icon: SvgPicture.asset(AppAssets.kGrid),
                      ),
                      Tab(
                        icon: SvgPicture.asset(AppAssets.kList),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: TabBarView(
                    children: [
                      GridAllUserPosts(
                        userId: widget.userId,
                      ),
                      ListAllUserPosts(
                        userId: widget.userId,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
