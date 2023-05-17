import 'dart:developer';
import 'dart:io';

import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/modules/profile/components/custom_bottom_sheet.dart';
import 'package:cartisan/app/services/database.dart';
import 'package:cartisan/app/services/image_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditStoreView extends StatefulWidget {
  EditStoreView({super.key});

  @override
  State<EditStoreView> createState() => _EditStoreViewState();
}

class _EditStoreViewState extends State<EditStoreView> {
  File? newProfileImage;
  final UserController uc = Get.find<UserController>();

  final _avatarSize = 90;

  Future<String?> uploadNewProfileImage() async {
    if (newProfileImage == null) {
      return uc.currentUser!.url;
    }
    final url = await Database().uploadImage(newProfileImage!);
    setState(() {
      newProfileImage = null;
    });
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back<void>();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text('Edit Profile', style: AppTypography.kLight18),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  log('stripe button pressed');
                  // TODO: ADD STRIPE.
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                child: Text(
                  'Connect to Stripe',
                  style: AppTypography.kLight15,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: Get.height * 0.93,
            child: Column(
              children: [
                SizedBox(height: 30.h),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(8.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.kPrimary),
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      onTap: () async {
                        await ImagePickerDialogBox.pickSingleImage((p0) {
                          setState(() {
                            newProfileImage = p0;
                          });
                        });
                      },
                      child: newProfileImage != null
                          ? SizedBox(
                              height: _avatarSize.w,
                              width: _avatarSize.w,
                              child: ClipOval(
                                child: Image.file(
                                  newProfileImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : SizedBox(
                              height: _avatarSize.w,
                              width: _avatarSize.w,
                              child: uc.currentUser?.url.isURL ?? false
                                  ? ClipOval(
                                      child: Image.network(
                                        uc.currentUser!.url,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : ClipOval(
                                      child: Material(
                                        child: Transform.translate(
                                          offset: Offset(-8.w, 0),
                                          child: Icon(
                                            Icons.person,
                                            size: 110.w,
                                            color: AppColors.kPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 17.h),
                Text(uc.currentUser?.username ?? 'New User',
                    style: AppTypography.kMedium16),
                Text(
                  uc.currentUser?.email ?? 'email',
                  style: AppTypography.kMedium14
                      .copyWith(color: AppColors.kHintColor),
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomBottomSheet(
                  updateUserImage: uploadNewProfileImage,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
