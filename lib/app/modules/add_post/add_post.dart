import 'dart:async' as async;
import 'dart:developer';
import 'dart:io';

import 'package:cartisan/app/api_classes/post_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/data/constants/app_colors.dart';
import 'package:cartisan/app/data/constants/app_typography.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/data/global_functions/success_dialog.dart';
import 'package:cartisan/app/models/delivery_options.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/modules/add_post/components/chip_adding_textfield.dart';
import 'package:cartisan/app/modules/add_post/components/mini_text_field.dart';
import 'package:cartisan/app/modules/add_post/components/product_image_picker_dialog.dart';
import 'package:cartisan/app/modules/profile/components/custom_textformfield.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
import 'package:cartisan/app/modules/widgets/dialogs/loading_dialog.dart';
import 'package:cartisan/app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AddPost extends StatefulWidget {
  List<File> images;
  AddPost({required this.images, super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final postApi = PostAPI();
  final _formKey = GlobalKey<FormState>();
  final _productTitleText = TextEditingController();
  final _productDescriptionText = TextEditingController();
  final _productBrandText = TextEditingController();
  final _productPriceText = TextEditingController();
  final _productQuantityText = TextEditingController();
  final _productVariantsText = TextEditingController();
  final List<String> _variants = [];

  final subHeadingStyle =
      AppTypography.kBold14.copyWith(color: AppColors.kWhite);
  final subHeadingPadding = EdgeInsets.only(top: 30.h, bottom: 10.h);
  bool loading = false;
  async.Future<void> handleImageTaken() async {
    await ProductImagePickerDialog.pickSingleImage((newImage) {
      setState(() {
        widget.images.add(newImage);
      });
    });
  }

  int extraPadding = 0;

  bool get isProductReady =>
      _formKey.currentState!.validate() &&
      widget.images.isNotEmpty &&
      _variants.isNotEmpty;

  ScrollController sc = ScrollController();
  @override
  Widget build(BuildContext context) {
    final length2 = widget.images.length;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back<void>();
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            size: 24.w,
            color: AppColors.kWhite,
          ),
        ),
        title: Text(
          'Add Product',
          style: AppTypography.kMedium18.copyWith(
            color: AppColors.kWhite,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(23.w),
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 240.h,
                  width: double.maxFinite,
                  color: AppColors.kFilledColor,
                  child: Center(
                    child: widget.images.isEmpty
                        ? InkWell(
                            onTap: handleImageTaken,
                            child: SizedBox(
                              height: 200.h,
                              width: double.maxFinite,
                              child: Center(
                                child: Text(
                                  'At least one image needed',
                                  style: AppTypography.kBold18
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        : ProductHeaderImage(
                            deleteImage: () {
                              setState(() {
                                widget.images.removeAt(0);
                              });
                            },
                            image: widget.images.first,
                          ),
                  ),
                ),
                SizedBox(
                  height: AppSpacing.eightVertical,
                ),
                if (length2 != 0)
                  Row(
                    children: [
                      ...List.generate(
                        length2 - 1,
                        (index) => ExtraPostImagesThumbnail(
                          onTap: () {
                            setState(() {
                              widget.images.removeAt(index + 1);
                            });
                          },
                          image: widget.images[index + 1],
                        ),
                      ),
                      if (length2 <= 5)
                        Padding(
                          padding: (length2 <= 1)
                              ? EdgeInsets.symmetric(vertical: 10.h)
                              : EdgeInsets.zero,
                          child: InkWell(
                            onTap: handleImageTaken,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: AppColors.kPrimary,
                                  size: 20.w,
                                ),
                                Text(
                                  'Add More',
                                  style: AppTypography.kBold14.copyWith(
                                    color: AppColors.kPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                Padding(
                  padding: subHeadingPadding,
                  child: Text(
                    'Product Title',
                    style:
                        AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                  ),
                ),
                CustomTextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Product title cannot be empty';
                    }
                    return null;
                  },
                  hintText: 'Enter your product title',
                  controller: _productTitleText,
                ),
                Padding(
                  padding: subHeadingPadding,
                  child: Text(
                    'Product Description',
                    style: subHeadingStyle,
                  ),
                ),
                CustomTextFormField(
                  maxLines: 3,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Product description cannot be empty';
                    }
                    return null;
                  },
                  hintText: "Enter your product's description",
                  controller: _productDescriptionText,
                ),
                Padding(
                  padding: subHeadingPadding,
                  child: Text(
                    'Brand',
                    style: subHeadingStyle,
                  ),
                ),
                CustomTextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Brand cannot be empty';
                    }
                    return null;
                  },
                  hintText: 'Enter your product brand',
                  controller: _productBrandText,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: subHeadingPadding,
                          child: Text(
                            'Quantity :',
                            style: subHeadingStyle,
                          ),
                        ),
                        MiniTextField(
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Product quantity cannot be empty';
                            }
                            if (int.tryParse(text) == null ||
                                int.tryParse(text) == 0) {
                              return 'Product quantity must be a whole number';
                            }
                            return null;
                          },
                          hintText: '1',
                          controller: _productQuantityText,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: subHeadingPadding,
                          child: Text(
                            'Product Price',
                            style: subHeadingStyle,
                          ),
                        ),
                        MiniTextField(
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Product price cannot be empty';
                            }
                            if (double.tryParse(text) == null) {
                              return 'Product quantity must be a whole number';
                            }
                            return null;
                          },
                          hintText: r'$ 0 - 1000',
                          controller: _productPriceText,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: subHeadingPadding,
                  child: Text(
                    'Choice',
                    style: subHeadingStyle,
                  ),
                ),
                ProductVariantField(
                  hintText: 'Add Variants',
                  controller: _productVariantsText,
                  addIcon: InkWell(
                    onTap: () {
                      if (_productVariantsText.text.isEmpty) {
                        showErrorDialog('Variant cannot be empty');
                      } else if (_variants.contains(
                        _productVariantsText.text,
                      )) {
                        showErrorDialog('Variant already exists');
                      } else {
                        setState(() {
                          _variants.add(_productVariantsText.text);
                          _productVariantsText.clear();
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
                  children: _variants
                      .map(
                        (variant) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Chip(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            label: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 5.h),
                                child: Text(variant)),
                            onDeleted: () {
                              setState(() {
                                _variants.remove(variant);
                              });
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(
                  height: 30.h,
                ),
                PrimaryButton(
                  width: double.maxFinite,
                  onTap: () {
                    log(isProductReady.toString());
                    if (isProductReady) {
                      createPost();
                    } else {
                      showErrorDialog('Kindly fill all fields');
                    }
                  },
                  text: 'Add Product',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createPost() async {
    final userController = Get.find<UserController>();
    await Get.dialog<Widget>(const LoadingDialog(), barrierDismissible: false);
    final uploadedImagesLinks = await handleImageUpload();
    final userId = Get.find<AuthService>().currentUser!.uid;
    final post = PostModel(
      postId: '',
      ownerId: userId,
      description: _productDescriptionText.text,
      productName: _productTitleText.text,
      brand: _productBrandText.text,
      variants: _variants,
      price: (int.tryParse(_productPriceText.text) ?? 0).toDouble(),
      location:userController.currentUser!.city,
      rating: 0,
      images: uploadedImagesLinks,
      selectedVariant: _variants.first,
      quantity: int.tryParse(_productQuantityText.text) ?? 1,
      isProductInStock: true,
      archived: false,
      sellCount: 0,
      commentCount: 0,
      reviewCount: 0,
      likesCount: 0,
      deliveryOptions: DeliveryOptions.pickup,
    );
    final result = await postApi.createPost(userId: userId, newPost: post);
    if (result) {
      Get
        ..back<void>()
        ..back<void>()
        ..back<void>();
      await Get.dialog<Widget>(const SuccessDialog(message: 'Post successfully added'),);
      await userController.getUserPostCount();
    } else {
      await showErrorDialog('Error uploading post');
    }
    Get.back<void>();
  }

  Future<List<String>> handleImageUpload() async {
    final db = Database();
    final images = <String>[];
    for (final image in widget.images) {
      final link = await db.uploadImage(image);
      if (link != null) {
        images.add(link);
      }
    }
    return images;
  }
}

class UploadDialog extends StatelessWidget {
  const UploadDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 150.w),
      backgroundColor: AppColors.kFilledColor,
      title: Text(
        'Uploading product please wait',
        style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
      ),
      content: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}

class ProductHeaderImage extends StatelessWidget {
  final void Function() deleteImage;
  final File image;
  const ProductHeaderImage({
    required this.deleteImage,
    required this.image,
    super.key,
  });
  int get _containerHeight => 300;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: _containerHeight.h,
      child: Stack(
        children: [
          SizedBox(
            width: double.maxFinite,
            height: _containerHeight.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.file(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: InkWell(
                onTap: deleteImage,
                child: Container(
                  padding: EdgeInsets.all(7.w),
                  decoration: const BoxDecoration(
                    color: AppColors.kPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.kWhite,
                    size: 20.w,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExtraPostImagesThumbnail extends StatelessWidget {
  final File image;
  final void Function() onTap;
  const ExtraPostImagesThumbnail({
    required this.onTap,
    required this.image,
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
            child: SizedBox(
              height: _avatarSize.w,
              width: _avatarSize.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.r),
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: onTap,
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

class ThumbnailViewAndDeleteDialog extends StatelessWidget {
  static const _imageSize = 300;
  final File image;
  final void Function() deleteImage;
  const ThumbnailViewAndDeleteDialog({
    required this.image,
    required this.deleteImage,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.kFilledColor,
      content: SizedBox(
        height: _imageSize.h,
        width: double.maxFinite,
        child: Stack(
          children: [
            SizedBox(
              height: _imageSize.h,
              width: double.maxFinite,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.file(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Get.back<void>();
                },
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: const BoxDecoration(
                    color: AppColors.kPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_fullscreen_rounded,
                    color: AppColors.kWhite,
                    size: 20.w,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      actions: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 10.0.h),
            child: PrimaryButton(
              onTap: deleteImage,
              text: 'Delete Image',
            ),
          ),
        ),
      ],
    );
  }
}
