import 'dart:developer';
import 'dart:io';

import 'package:cartisan/app/controllers/landing_page_controller.dart';
import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/add_post/add_post.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
import 'package:cartisan/app/services/image_picker_dialog.dart';
import 'package:cartisan/app/services/image_picker_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductImagePickerDialog {
  static Future<File?> pickSingleImage(Function(File) callBack) async {
    File? pickedFile;
    await Get.dialog<File?>(ImagePickerDialog(
      cameraCallback: () async {
        Get.back<void>();
        await 0.5.seconds.delay();
        pickedFile = await ImagePickerServices().getImageFromCamera();
        if (pickedFile != null) {
          callBack(pickedFile!);
        }
      },
      galleryCallback: () async {
        Get.back<void>();
        await 0.5.seconds.delay();
        pickedFile = await ImagePickerServices().getImageFromGallery();
        if (pickedFile != null) {
          callBack(pickedFile!);
        }
      },
    ));
    return pickedFile;
  }
}

class CreateProductImagePick extends StatelessWidget {
  CreateProductImagePick({
    super.key,
  });
  File? pickedFile;
  List<File> pickedFiles = [];
  final optionStyle = AppTypography.kMedium16.copyWith(
    color: AppColors.kWhite,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.only(left: 16.w, right: 29.w),
          width: 350.w,
          height: 300.h,
          decoration: BoxDecoration(
            color: AppColors.kFilledColor,
            borderRadius: BorderRadius.circular(17.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select Image',
                style: AppTypography.kBold24.copyWith(
                  color: AppColors.kWhite,
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              Material(
                color: Colors.transparent,
                child: SizedBox(
                  height: 45.h,
                  child: InkWell(
                    onTap: () async {
                      pickedFile =
                          await ImagePickerServices().getImageFromCamera();
                      if (pickedFile != null) {
                        await Get.to<Widget>(
                            () => AddPost(images: [pickedFile!]));
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          'Select from Camera',
                          style: optionStyle,
                        ),
                        const Spacer(),
                        Icon(
                          Icons.camera_alt_rounded,
                          color: AppColors.kWhite,
                          size: 20.w,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Material(
                color: Colors.transparent,
                child: SizedBox(
                  height: 45.h,
                  child: InkWell(
                    splashColor: AppColors.kGrey2,
                    onTap: () async {
                      pickedFile =
                          await ImagePickerServices().getImageFromGallery();
                      if (pickedFile != null) {
                        await Get.to<Widget>(
                            () => AddPost(images: [pickedFile!]));
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          'Select from Gallery',
                          style: optionStyle,
                        ),
                        const Spacer(),
                        Icon(Icons.photo_rounded,
                            color: AppColors.kWhite, size: 20.w),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Material(
                color: Colors.transparent,
                child: SizedBox(
                  height: 45.h,
                  child: InkWell(
                    splashColor: AppColors.kGrey2,
                    onTap: () async {
                      pickedFiles =
                          await ImagePickerServices().pickMultipleImages() ??
                              [];
                      if (pickedFiles.isNotEmpty) {
                        await Get.to<Widget>(
                            () => AddPost(images: pickedFiles));
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          'Select Multiple from gallery',
                          style: optionStyle,
                        ),
                        const Spacer(),
                        Icon(Icons.photo_library_rounded,
                            color: AppColors.kWhite, size: 20.w),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateProductRoot extends StatelessWidget {
  CreateProductRoot({super.key});
  final uc = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return (uc.currentUser?.isActiveSeller ?? false)
        ? CreateProductImagePick()
        : ProfileSetup();
  }
}

class ProfileSetup extends StatelessWidget {
  ProfileSetup({super.key});
  final uc = Get.find<UserController>();
  final subHeadingStyle = AppTypography.kMedium16.copyWith(
    color: AppColors.kWhite,
  );
  final falseStyle =
      AppTypography.kExtraLight15.copyWith(color: AppColors.kWhite);
  @override
  Widget build(BuildContext context) {
    final isSeller = uc.currentUser?.isSeller ?? false;
    final stripeSetup = (uc.currentUser?.sellerID.length ?? 0) > 4;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back<void>();
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 30.w,
          ),
        ),
        title: Text(
          'Setup Profile',
          style: AppTypography.kLight18.copyWith(
            color: AppColors.kWhite,
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(left: 16.w, right: 29.w),
          width: 350.w,
          height: 375.h,
          decoration: BoxDecoration(
            color: AppColors.kFilledColor,
            borderRadius: BorderRadius.circular(17.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Seller Setup Incomplete',
                style: AppTypography.kBold20.copyWith(color: AppColors.kWhite),
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                'Please complete your seller setup before you can create a product',
                textAlign: TextAlign.center,
                style: subHeadingStyle,
              ),
              SizedBox(
                height: 40.h,
              ),
              Row(
                children: [
                  Text(
                    'Set yourself as Seller',
                    style: isSeller ? subHeadingStyle : falseStyle,
                  ),
                  const Spacer(),
                  if (isSeller)
                    const Icon(
                      Icons.check,
                      color: AppColors.kWhite,
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              Row(
                children: [
                  Text(
                    'Set up Stripe',
                    style: stripeSetup ? subHeadingStyle : falseStyle,
                  ),
                  const Spacer(),
                  if (stripeSetup)
                    const Icon(
                      Icons.check,
                      color: AppColors.kWhite,
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
              SizedBox(
                height: 60.h,
              ),
              PrimaryButton(
                onTap: () {
                  Get.find<LandingPageController>().currentIndex = 4;
                },
                text: 'Finish Setup',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
