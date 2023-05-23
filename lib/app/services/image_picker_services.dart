import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerServices {
  File? image;
  final _picker = ImagePicker();

  Future<File?> getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      return image;
    } else {
      await Fluttertoast.showToast(msg: 'No Image Selected');
      return null;
    }
  }

  Future<File?> getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      return image;
    } else {
      await Fluttertoast.showToast(msg: 'No Image Selected');
      return null;
    }
  }

  Future<List<File>?> pickMultipleImages() async {
    final res = await _picker.pickMultiImage();
    var images = <File>[];

    for (final image in res) {
      images.addAll([File(image.path)]);
    }
    if (images.length > 5) {
      images = images.sublist(0, 5);
    }
    return images;
  }
}
