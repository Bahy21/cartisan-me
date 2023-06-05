import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartisan/app/controllers/edit_product_controller.dart';
import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/data/constants/app_spacing.dart';
import 'package:cartisan/app/data/constants/app_typography.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/modules/add_post/components/chip_adding_textfield.dart';
import 'package:cartisan/app/modules/add_post/components/mini_text_field.dart';
import 'package:cartisan/app/modules/profile/components/custom_textformfield.dart';
import 'package:flutter/material.dart';

import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class EditPostView extends StatefulWidget {
  final PostModel post;
  const EditPostView({
    required this.post,
    Key? key,
  }) : super(key: key);
  @override
  _EditPostViewState createState() => _EditPostViewState();
}

class _EditPostViewState extends State<EditPostView> {
  final _formKey = GlobalKey<FormState>();

  UserModel get currentUser => Get.find<UserController>().currentUser!;
  final _iconSize = 24;
  @override
  Widget build(BuildContext context) {
    return GetX<EditProductController>(
      init: EditProductController(postIdToBeEdited: widget.post.postId),
      builder: (controller) {
        if (controller.post == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }
        final imageCount = controller.post!.images.length;
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.back(result: controller.post);
                },
              ),
              title: Text(
                'Edit Post',
                style: AppTypography.kBold24,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => _formKey.currentState!.validate()
                      ? controller.updatePost()
                      : null,
                  child: Text(
                    'Save',
                    style: AppTypography.kBold16.copyWith(color: Colors.green),
                  ),
                ),
              ],
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.twentyFourHorizontal,
                ),
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: controller.post!.images.first,
                    height: Get.height * 0.5,
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) => Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 8.w, top: 8.h),
                            child: Column(
                              children: [
                                DecoratedBox(
                                  decoration: const BoxDecoration(
                                    color: AppColors.kPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: InkWell(
                                    child: Container(
                                      padding: EdgeInsets.all(7.w),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.kPrimary,
                                      ),
                                      child: Icon(
                                        Icons.close_rounded,
                                        size: _iconSize.w,
                                      ),
                                    ),
                                    onTap: imageCount == 1
                                        ? () => showErrorDialog(
                                              'At least one image is needed\n Try replacing instead.',
                                            )
                                        : () {
                                            controller
                                                .deleteImageDecisionDialog(
                                              controller.post!.images.first,
                                            );
                                          },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (imageCount != 0)
                    Row(
                      children: [
                        ...List.generate(
                          imageCount - 1,
                          (index) => ExtraPostImagesThumbnail(
                            imageLink: controller.post!.images[index + 1],
                            replace: () {
                              controller.replacePhoto(
                                controller.post!.images[index + 1],
                              );
                            },
                            delete: () {
                              controller.deleteImageDecisionDialog(
                                controller.post!.images[index],
                              );
                            },
                          ),
                        ),
                        if (imageCount < 5)
                          InkWell(
                            onTap: () {
                              controller.addImage(widget.post.images.last);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.kPrimary,
                                  width: 2.w,
                                ),
                                borderRadius: BorderRadius.circular(7.5.r),
                              ),
                              margin: EdgeInsets.only(left: 5.w),
                              padding: EdgeInsets.all(15.w),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.add_rounded,
                                color: AppColors.kPrimary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  SizedBox(
                    height: AppSpacing.twentyFourVertical,
                  ),
                  Text(
                    'Product Name',
                    style: AppTypography.kBold14,
                  ),
                  CustomTextFormField(
                    controller: controller.productNameTextEditingController,
                    hintText: controller.post!.productName,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Product name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const Divider(),
                  Text(
                    'Product Description',
                    style: AppTypography.kBold14,
                  ),
                  CustomTextFormField(
                    maxLines: null,
                    controller: controller.descriptionTextEditingController,
                    hintText: controller.post!.description,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Product name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Brand',
                            style: AppTypography.kBold14,
                          ),
                          MiniTextField(
                            controller: controller.brandTextEditingController,
                            hintText: controller.post!.brand,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Product name cannot be empty';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price',
                            style: AppTypography.kBold14,
                          ),
                          MiniTextField(
                            controller: controller.priceController,
                            hintText: controller.post!.price.toString(),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Product name cannot be empty';
                              }
                              if (double.tryParse(text) == null) {
                                return 'Enter a valid number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  Text(
                    'Location',
                    style: AppTypography.kBold14,
                  ),
                  CustomTextFormField(
                    controller: controller.locationTextEditingController,
                    hintText: controller.post!.location,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Product name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const Divider(),
                  ProductVariantField(
                    hintText: 'Add Variants',
                    controller: controller.productVariantsTextController,
                    addIcon: InkWell(
                      onTap: () {
                        if (controller
                            .productVariantsTextController.text.isEmpty) {
                          showErrorDialog('Variant cannot be empty');
                        } else if (controller.post!.variants.contains(
                          controller.productVariantsTextController.text,
                        )) {
                          showErrorDialog('Variant already exists');
                        } else {
                          setState(() {
                            controller.post!.variants.add(
                              controller.productVariantsTextController.text,
                            );
                            controller.productVariantsTextController.clear();
                          });
                        }
                      },
                      child: Icon(
                        Icons.add_circle_outline,
                        color: AppColors.kWhite,
                        size: 23.w,
                      ),
                    ),
                  ),
                  Wrap(
                    children: controller.post!.variants
                        .map(
                          (variant) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Chip(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              label: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 5.h,
                                ),
                                child: Text(variant),
                              ),
                              onDeleted: () {
                                if (controller.post!.variants.length == 1) {
                                  showErrorDialog(
                                    'At least one variant is required',
                                  );
                                } else {
                                  setState(() {
                                    controller.post!.variants.remove(variant);
                                  });
                                }
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ExtraPostImagesThumbnail extends StatelessWidget {
  final String imageLink;
  final void Function() replace;
  final void Function() delete;
  const ExtraPostImagesThumbnail({
    required this.replace,
    required this.imageLink,
    required this.delete,
    super.key,
  });
  int get _avatarSize => 72;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75.w,
      width: 75.w,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(9.w),
            child: InkWell(
              onTap: replace,
              child: SizedBox(
                height: _avatarSize.w,
                width: _avatarSize.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.r),
                  child: CachedNetworkImage(
                    imageUrl: imageLink,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: delete,
              child: Container(
                height: 15.w,
                width: 15.w,
                decoration: BoxDecoration(
                  color: AppColors.kPrimary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 12.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
