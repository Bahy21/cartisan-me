import 'dart:io';

import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/camera/components/custom_checkbox.dart';
import 'package:cartisan/app/modules/camera/components/images_card.dart';
import 'package:cartisan/app/services/image_picker_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  bool _todaySelect = false;
  final List<bool> _selectedTodayList = List.filled(10, false);

  bool _recentSelect = false;
  final List<bool> _selectedRecentList = List.filled(10, false);
  File? image;
  VoidCallback _handlePickImage() {
    return () async {
      image = await ImagePickerService().pickImageFromGallery();
      // Do something with the selected image.
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kGrey,
        automaticallyImplyLeading: false,
        title: Text('Your Recent Images', style: AppTypography.kBold16),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _handlePickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              child: Text(
                'View Gallery',
                style: AppTypography.kLight15,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 26.w),
        children: [
          CustomCheckBox(
            heading: 'Today',
            value: _todaySelect,
            onChanged: (value) {
              setState(() {
                _todaySelect = value!;
                for (var i = 0; i < _selectedTodayList.length; i++) {
                  _selectedTodayList[i] = value;
                }
              });
            },
          ),
          GridView.builder(
            itemCount: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 3.h,
              crossAxisSpacing: 3.w,
            ),
            itemBuilder: (context, index) {
              return ImagesCard(
                isSelected: _selectedTodayList[index],
                onTap: () {
                  setState(() {
                    _selectedTodayList[index] = !_selectedTodayList[index];
                  });
                },
              );
            },
          ),
          CustomCheckBox(
            heading: '12 hours ago',
            value: _recentSelect,
            onChanged: (value) {
              setState(() {
                _recentSelect = value!;
                for (var i = 0; i < _selectedRecentList.length; i++) {
                  _selectedRecentList[i] = value;
                }
              });
            },
          ),
          GridView.builder(
            itemCount: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 3.0.h,
              crossAxisSpacing: 3.0.w,
            ),
            itemBuilder: (context, index) {
              return ImagesCard(
                isSelected: _selectedRecentList[index],
                onTap: () {
                  setState(() {
                    _selectedRecentList[index] = !_selectedRecentList[index];
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
