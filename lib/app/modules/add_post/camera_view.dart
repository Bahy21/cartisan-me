// import 'dart:developer';
// import 'dart:io';

// import 'package:cartisan/app/controllers/get_all_images_controller.dart';
// import 'package:cartisan/app/data/constants/constants.dart';
// import 'package:cartisan/app/modules/camera/components/custom_checkbox.dart';
// import 'package:cartisan/app/modules/camera/components/image_item_widget.dart';
// import 'package:cartisan/app/modules/camera/components/images_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:photo_manager/photo_manager.dart';

// class CameraView extends StatefulWidget {
//   const CameraView({super.key});

//   @override
//   State<CameraView> createState() => _CameraViewState();
// }

// class _CameraViewState extends State<CameraView> {
//   bool _todaySelect = false;
//   final List<String?> selectedImagesPaths = [];

//   bool _recentSelect = false;
//   final List<bool> _selectedRecentList = List.filled(10, false);
//   File? image;
//   VoidCallback _handlePickImage() {
//     return () async {};
//   }

//   final imagesController = Get.find<GetAllImagesController>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.kGrey,
//         automaticallyImplyLeading: false,
//         title: Text('Your Recent Images', style: AppTypography.kBold16),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ElevatedButton(
//               onPressed: _handlePickImage,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.kPrimary,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(6.r),
//                 ),
//               ),
//               child: Text(
//                 'View Gallery',
//                 style: AppTypography.kLight15,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: ListView(
//         padding: EdgeInsets.symmetric(horizontal: 26.w),
//         children: [
//           CustomCheckBox(
//             heading: '12 hours ago',
//             value: _recentSelect,
//             onChanged: (value) {
//               setState(() {
//                 _recentSelect = value!;
//                 for (var i = 0; i < _selectedRecentList.length; i++) {
//                   _selectedRecentList[i] = value;
//                 }
//               });
//             },
//           ),
//           GridView.builder(
//             itemCount: imagesController.paths.length,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 4,
//               mainAxisSpacing: 3.0.h,
//               crossAxisSpacing: 3.0.w,
//             ),
//             itemBuilder: (context, index) {
//               return SizedBox(
//                 height: 300.w,
//                 width: 300.w,
//                 child: Stack(
//                   children: [
//                     ImageItemWidget(
//                       onTap: () async {
//                         final file = await imagesController.paths[index].file;
//                         if (file == null) {
//                           return;
//                         }
//                         setState(() {
//                           selectedImagesPaths.add(file.path);
//                         });
//                         log(selectedImagesPaths.toString());
//                       },
//                       entity: imagesController.paths[index],
//                       option: const ThumbnailOption(
//                         size: ThumbnailSize.square(300),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           ElevatedButton(
//             onPressed: imagesController.loadImages,
//             child: const Text('Load Images'),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(6.r),
//           ),
//           onPressed: () {}),
//     );
//   }
// }
