import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartisan/app/controllers/blocked_users_view_controller.dart';
import 'package:cartisan/app/data/constants/app_colors.dart';
import 'package:cartisan/app/data/constants/app_typography.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BlockedUsersView extends StatefulWidget {
  const BlockedUsersView({super.key});

  @override
  State<BlockedUsersView> createState() => _BlockedUsersViewState();
}

class _BlockedUsersViewState extends State<BlockedUsersView> {
  @override
  Widget build(BuildContext context) {
    return GetX<BlockedUsersViewController>(
      init: BlockedUsersViewController(),
      builder: (controller) {
        // Loading.
        if (controller.loading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }
        // None blocked.
        if (controller.pagingController.value.itemList == null ||
            controller.pagingController.value.itemList!.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Blocked users',
                style: AppTypography.kBold18.copyWith(color: AppColors.kWhite),
              ),
              backgroundColor: AppColors.kPrimary,
            ),
            body: Center(
              child: Text(
                'No blocked users',
                style:
                    AppTypography.kBold18.copyWith(color: AppColors.kPrimary),
              ),
            ),
          );
        }
        // Blocked users.
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Blocked users',
              style: AppTypography.kBold18.copyWith(color: AppColors.kWhite),
            ),
            backgroundColor: AppColors.kPrimary,
          ),
          body: PagedListView<int, UserModel>(
            pagingController: controller.pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(item.url),
                  ),
                  title: Text(item.profileName),
                  subtitle: Text(item.email),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await controller.unblockUser(item.id);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
