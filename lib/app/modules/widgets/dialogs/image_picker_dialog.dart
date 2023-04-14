/*import 'dart:io';

import 'package:cartisan/app/services/image_picker_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ImagePickerDialog extends StatelessWidget {
  final VoidCallback cameraCallback;

  final VoidCallback galleryCallback;
  ImagePickerDialog({
    required this.cameraCallback,
    required this.galleryCallback,
    Key? key,
  }) : super(key: key);
  final poppinsFontStyle = GoogleFonts.poppins();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Image',
            style: poppinsFontStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: cameraCallback,
            child: Row(
              children: [
                const Icon(Icons.camera_alt),
                const SizedBox(width: 5),
                Text(
                  'Select from Camera',
                  style: poppinsFontStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: galleryCallback,
            child: Row(
              children: [
                const Icon(Icons.photo),
                const SizedBox(width: 5),
                Text(
                  'Select from Gallery',
                  style: poppinsFontStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePickerDialogBox {
  static Future<File?> pickSingleImage(Function(File) callBack) async {
    File? pickedFile;
    await Get.dialog<File?>(ImagePickerDialog(
      cameraCallback: () async {
        Get.back<void>();
        await 0.5.seconds.delay();
        pickedFile = await ImagePickerService.getImageFromCamera();
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
*/