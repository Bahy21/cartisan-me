import 'dart:developer';
import 'dart:io';
import 'dart:async' as async;
import 'package:cartisan/app/api_classes/post_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/controllers/controllers.dart';
import 'package:cartisan/app/data/constants/app_colors.dart';
import 'package:cartisan/app/data/constants/app_typography.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/data/global_functions/success_dialog.dart';
import 'package:cartisan/app/models/delivery_options.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/modules/add_post/components/chip_adding_textfield.dart';
import 'package:cartisan/app/modules/add_post/components/mini_text_field.dart';
import 'package:cartisan/app/modules/add_post/components/product_image_picker_dialog.dart';
import 'package:cartisan/app/modules/profile/components/custom_textformfield.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
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
  var _formKey = GlobalKey<FormState>();
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
  void handleImageTaken() async {
    await ProductImagePickerDialog.pickSingleImage((newImage) {
      setState(() {
        widget.images.add(newImage);
      });
    });
  }

  bool get isProductReady =>
      _formKey.currentState!.validate() &&
      widget.images.isNotEmpty &&
      _variants.isNotEmpty;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: Padding(
        padding: EdgeInsets.all(23.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 210.h,
                  width: double.maxFinite,
                  color: AppColors.kFilledColor,
                  child: Center(
                    child: widget.images.isEmpty
                        ? InkWell(
                            onTap: handleImageTaken,
                            child: Text(
                              'At least one image needed',
                              style: AppTypography.kBold18
                                  .copyWith(color: Colors.white),
                            ),
                          )
                        : ProductHeaderImage(
                            deleteImage: () {
                              setState(() {
                                widget.images.removeAt(0);
                              });
                            },
                            image: widget.images.first),
                  ),
                ),
                Row(
                  children: [
                    ...List.generate(
                        widget.images.length - 1,
                        (index) => ExtraPostImagesThumbnail(
                            deleteImage: () {
                              setState(() {
                                widget.images.removeAt(index + 1);
                              });
                            },
                            image: widget.images[index + 1])),
                    if (widget.images.length <= 5)
                      Padding(
                        padding: (widget.images.length <= 1)
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
                              )
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
                            return null;
                          },
                          hintText: '1',
                          controller: _productPriceText,
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
                            return null;
                          },
                          hintText: r'$ 0 - 1000',
                          controller: _productPriceText,
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
                      setState(() {
                        _variants.add(_productVariantsText.text);
                        _productVariantsText.clear();
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
                    text: 'Add Product'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createPost() async {
    setState(() {
      loading = true;
    });
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
      location: Get.find<UserController>().currentUser!.city,
      rating: 0,
      images: uploadedImagesLinks,
      selectedVariant: _variants.first,
      quantity: int.tryParse(_productQuantityText.text) ?? 0,
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
      await Get.dialog<Widget>(
          SuccessDialog(message: 'Post successfully added'));
    } else {
      showErrorDialog('Error uploading post');
    }
    setState(() {
      loading = false;
    });
  }

  Future<List<String>> handleImageUpload() async {
    final db = Database();
    List<String> images = [];
    for (File image in widget.images) {
      final link = await db.uploadImage(image);
      if (link != null) {
        images.add(link);
      }
    }
    return images;
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.w,
      height: 350.h,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.file(
              image,
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: deleteImage,
              child: Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: AppColors.kPrimary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_rounded,
                  color: AppColors.kWhite,
                  size: 20.w,
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
  final void Function() deleteImage;
  const ExtraPostImagesThumbnail({
    required this.deleteImage,
    required this.image,
    super.key,
  });
  int get _avatarSize => 60;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: deleteImage,
      child: Padding(
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
    );
  }
}
