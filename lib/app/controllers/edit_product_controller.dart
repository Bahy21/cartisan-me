import 'dart:developer';
import 'dart:io';

import 'package:cartisan/app/api_classes/post_api.dart';
import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/modules/widgets/dialogs/loading_dialog.dart';
import 'package:cartisan/app/modules/widgets/dialogs/toast.dart';
import 'package:cartisan/app/services/database.dart';
import 'package:cartisan/app/services/image_picker_services.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProductController extends GetxController {
  final postApi = PostAPI();
  final db = Database();
  final productNameTextEditingController = TextEditingController();
  final brandTextEditingController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionTextEditingController = TextEditingController();
  final locationTextEditingController = TextEditingController();
  final optionsTextEditingController = TextEditingController();
  final productVariantsTextController = TextEditingController();
  String postIdToBeEdited;
  PostModel get post => _post.value!;
  set post(PostModel newPost) => _post.value = newPost;
  File? file;

  List<String> optionsList = [];
  List<File>? images = [];
  List<File> compressedImages = [];
  List<Widget> optionsTextFields = [];
  UserModel get currentUser => Get.find<UserController>().currentUser!;
  EditProductController({required this.postIdToBeEdited});

  Rx<PostModel?> _post = Rx<PostModel?>(null);

  @override
  void onInit() {
    _post.bindStream(
      db.postsCollection.doc(postIdToBeEdited).snapshots().map((event) {
        return PostModel.fromMap(event.data() as Map<String, dynamic>);
      }),
    );
    super.onInit();
  }

  Future controlUploadAndSave() async {
    try {
      if (optionsTextEditingController.text.isNotEmpty) {
        optionsList.add(
          optionsTextEditingController.text,
        );
        optionsTextEditingController.clear();
        update();
      }

      locationTextEditingController.clear();
      descriptionTextEditingController.clear();
      optionsTextEditingController.clear();
      brandTextEditingController.clear();
      productNameTextEditingController.clear();
      priceController.clear();

      file = null;
      images = [];
      update();
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<void> updatePost() async {
    Get.dialog<Widget>(LoadingDialog(), barrierDismissible: false);
    final newPost = post.copyWith(
      productName: productNameTextEditingController.text,
      description: descriptionTextEditingController.text.isEmpty
          ? post.description
          : descriptionTextEditingController.text,
      brand: brandTextEditingController.text.isEmpty
          ? post.brand
          : brandTextEditingController.text,
      price: int.tryParse(priceController.text) == null ||
              int.tryParse(priceController.text) == 0
          ? post.price
          : int.parse(priceController.text).toDouble(),
      location: locationTextEditingController.text.isEmpty
          ? post.location
          : locationTextEditingController.text,
      variants: post.variants,
    );
    final result = await postApi.updatePost(newPost);
    Get.back<void>();
    if (result) {
      _post.value = newPost;
      showToast('Succesfully updated post');
    } else {
      await showErrorDialog('Error updating');
    }
  }

  Future<bool> replacePhoto(String original) async {
    var photo = await takeImage();
    if (photo == null) return false;
    post.images[post.images.indexOf(original)] = (await db.uploadImage(photo))!;
    await updatePost();
    return true;
  }

  Future<String> uploadPhoto(File mImageFile) async {
    try {
      String? downloadUrl = await db.uploadImage(mImageFile);
      update();
      return downloadUrl!;
    } on Exception catch (e) {
      log(e.toString());
      return '';
    }
  }

  Future<bool> addImage(String current) async {
    var photo = await takeImage();
    if (photo == null) return false;
    post.images.insert(
      post.images.indexOf(current),
      (await db.uploadImage(photo))!,
    );
    await updatePost();
    return true;
  }

  Future<void> deleteImageDecisionDialog(String original) async {
    await Get.defaultDialog<Widget>(
      title: 'Delete image',
      onConfirm: () async {
        await removeImage(post.images.indexOf(original));
        Get.back<void>();
      },
      onCancel: () => Get.back<void>(),
      middleText: 'Are you sure you want to delete this image?',
      textConfirm: 'Yes',
      textCancel: 'No',
      buttonColor: AppColors.kPrimary,
      confirmTextColor: AppColors.kWhite,
      cancelTextColor: AppColors.kPrimary,
    );
  }

  Future<void> removeImage(int index) async {
    post.images.removeAt(index);
    await updatePost();
    update();
  }

  Future<File?> takeImage() async {
    try {
      return await Get.dialog<File>(SimpleDialog(
        title: Text(
          'New Post',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        children: <Widget>[
          SimpleDialogOption(
            child: Text(
              'Capture Image with Camera',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              Get.back(
                  result: await ImagePickerServices().getImageFromCamera());
            },
          ),
          SimpleDialogOption(
            child: Text(
              'Select Image from Gallery',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              Get.back(
                  result: await ImagePickerServices().getImageFromGallery());
            },
          ),
          SimpleDialogOption(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => Get.back<void>(),
          ),
        ],
      ));
    } on Exception catch (e) {
      log(e.toString());
    }
  }
}
