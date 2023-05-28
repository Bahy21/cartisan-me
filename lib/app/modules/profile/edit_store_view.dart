import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/profile/become_a_seller.dart';
import 'package:cartisan/app/modules/profile/components/custom_bottom_sheet.dart';
import 'package:cartisan/app/modules/profile/components/stripe_button.dart';
import 'package:cartisan/app/services/database.dart';
import 'package:cartisan/app/services/image_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditStoreView extends StatefulWidget {
  const EditStoreView({super.key});

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

  Widget _buildStripeButton() {
    return uc.currentUser!.isActiveSeller
        ? StripeSection()
        : HighImportanceTaskButton(
            onTap: () {
              Get.to<Widget>(BecomeASeller.new);
            },
            text: "Become a Seller",
          );
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
        ),
        body: SingleChildScrollView(
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
                                    child: CachedNetworkImage(
                                      imageUrl: uc.currentUser!.url,
                                      fit: BoxFit.cover,
                                      errorWidget:
                                          (context, url, dynamic error) =>
                                              ClipOval(
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
              _buildStripeButton(),
              SizedBox(
                height: 10.h,
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
      );
    });
  }
}

class HighImportanceTaskButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const HighImportanceTaskButton(
      {super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              8.0,
            ),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color(0xff5433FF),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16.0),
      ),
    );
  }
}
