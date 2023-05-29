import 'dart:developer';

import 'package:cartisan/app/controllers/controllers.dart';
import 'package:cartisan/app/controllers/edit_product_controller.dart';
import 'package:cartisan/app/data/constants/app_spacing.dart';
import 'package:cartisan/app/data/constants/app_typography.dart';
import 'package:cartisan/app/data/constants/constants.dart';
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

  @override
  Widget build(BuildContext context) {
    return GetX<EditProductController>(
      init: EditProductController(postIdToBeEdited: widget.post.postId),
      builder: (controller) {
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
                  onPressed: () => controller.updatePost(),
                  child: Text(
                    'Save',
                    style: AppTypography.kBold16.copyWith(color: Colors.green),
                  ),
                ),
              ],
            ),
            body: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.twentyFourHorizontal,
              ),
              children: <Widget>[
                SizedBox(
                  height: Get.height * 0.6,
                  child: CarouselSlider(
                    children: List.generate(
                      controller.post.images.length,
                      (index) => Column(
                        children: [
                          Image.network(
                            controller.post.images[index],
                            height: Get.height * 0.5,
                            fit: BoxFit.contain,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () {}, child: Text("Remove")),
                              TextButton(
                                  onPressed: () {
                                    controller.replacePhoto(
                                        controller.post.images[index]);
                                  },
                                  child: Text("Replace")),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
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
                  hintText: controller.post.productName,
                ),
                const Divider(),
                Text(
                  'Product Description',
                  style: AppTypography.kBold14,
                ),
                CustomTextFormField(
                  maxLines: null,
                  controller: controller.descriptionTextEditingController,
                  hintText: controller.post.description,
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
                          hintText: controller.post.brand,
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
                          hintText: controller.post.price.toString(),
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
                  hintText: controller.post.location,
                ),
                const Divider(),
                ProductVariantField(
                  hintText: 'Add Variants',
                  controller: controller.productVariantsTextController,
                  addIcon: InkWell(
                    onTap: () {
                      setState(() {
                        controller.post.variants
                            .add(controller.productVariantsTextController.text);
                        controller.productVariantsTextController.clear();
                      });
                    },
                    child: Icon(
                      Icons.add_circle_outline,
                      color: AppColors.kWhite,
                      size: 23.w,
                    ),
                  ),
                ),
                Wrap(
                  children: controller.post.variants
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
                              setState(() {
                                controller.post.variants.remove(variant);
                              });
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
        );
      },
    );
  }
}

TextEditingController optionsTextEditingController = TextEditingController();

class OptionTextFields extends StatefulWidget {
  final int index;
  const OptionTextFields(this.index, {super.key});
  @override
  _OptionTextFieldsState createState() => _OptionTextFieldsState();
}

class _OptionTextFieldsState extends State<OptionTextFields> {
  @override
  void initState() {
    super.initState();
    optionsTextEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: optionsTextEditingController,
      hintText: 'Option...',
    );
  }
}