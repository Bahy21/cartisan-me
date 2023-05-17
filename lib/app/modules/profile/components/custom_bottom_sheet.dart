// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:cartisan/app/api_classes/user_api.dart';
import 'package:cartisan/app/controllers/controllers.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/modules/profile/components/custom_switch.dart';
import 'package:cartisan/app/modules/profile/components/custom_textformfield.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';

class CustomBottomSheet extends StatefulWidget {
  final Future<String?> Function() updateUserImage;
  const CustomBottomSheet({
    required this.updateUserImage,
    Key? key,
  }) : super(key: key);

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  final uc = Get.find<UserController>();
  final userApi = UserAPI();
  ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  late bool _pickUpAvailable;
  late bool _shippingAvailable;
  late bool _deliveryAvailable;
  late bool _isSeller;
  bool loaded = false;

  @override
  void initState() {
    _initWidgetParams();
    super.initState();
  }

  void _initWidgetParams() {
    _nameController = TextEditingController(text: uc.currentUser!.profileName);
    _descriptionController = TextEditingController(text: uc.currentUser!.bio);
    _pickUpAvailable = uc.currentUser!.pickup;
    _shippingAvailable = uc.currentUser!.activeShipping;
    _deliveryAvailable = uc.currentUser!.isDeliveryAvailable;
    _isSeller = uc.currentUser?.isSeller ?? false;
    if (mounted) {
      setState(() {
        loaded = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> updateUserDetails() async {
    setState(() {
      loaded = false;
    });
    final newImageUrl = await widget.updateUserImage();
    final newUser = uc.currentUser!.copyWith(
      url: newImageUrl ?? uc.currentUser!.url,
      profileName: _nameController.text,
      username: _nameController.text,
      bio: _descriptionController.text,
      isDeliveryAvailable: _deliveryAvailable,
      pickup: _pickUpAvailable,
      activeShipping: _shippingAvailable,
      isSeller: _isSeller,
    );
    final value = await userApi.updateUserDetails(
      userId: uc.currentUser!.id,
      newUser: newUser,
    );

    if (value) {
      uc.updateUserInController = newUser;
      _initWidgetParams();
    } else {
      await showErrorDialog('Error updating user details');
      setState(() {
        loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.kGrey,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    top: 25.h,
                    left: 29.w,
                    right: 29.0.w,
                    bottom: 20.h,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile Name',
                          style: AppTypography.kBold14,
                        ),
                        CustomTextFormField(
                          controller: _nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Field is required';
                            }
                            return null;
                          },
                          hintText: uc.currentUser?.profileName ??
                              'Enter username here',
                        ),
                        SizedBox(height: 18.h),
                        Text(
                          'Description',
                          style: AppTypography.kBold14,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextFormField(
                          controller: _descriptionController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Field is required';
                            }
                            return null;
                          },
                          maxLines: 4,
                          hintText: uc.currentUser?.bio ?? 'Enter bio here',
                        ),
                        SizedBox(
                          height: AppSpacing.eighteenVertical,
                        ),
                        Text(
                          'More Options',
                          style: AppTypography.kBold14,
                        ),
                        SizedBox(height: 25.h),
                        CustomSwitch(
                          isDisabled: false,
                          text: 'I am a seller',
                          value: _isSeller,
                          onChanged: (value) {
                            setState(() {
                              _isSeller = value;
                              _deliveryAvailable = false;
                              _shippingAvailable = false;
                              _pickUpAvailable = false;
                            });
                          },
                        ),
                        CustomSwitch(
                          isDisabled: !_isSeller,
                          text: 'Pick Up Available',
                          value: _pickUpAvailable,
                          onChanged: (value) {
                            setState(() {
                              _pickUpAvailable = value;
                            });
                          },
                        ),
                        CustomSwitch(
                          isDisabled: !_isSeller,
                          text: 'Shipping Available',
                          value: _shippingAvailable,
                          onChanged: (value) {
                            setState(() {
                              _shippingAvailable = value;
                            });
                          },
                        ),
                        CustomSwitch(
                          isDisabled: !_isSeller,
                          text: 'Delivery Available',
                          value: _deliveryAvailable,
                          onChanged: (value) {
                            setState(() {
                              _deliveryAvailable = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 50.0.h,
                        ),
                        PrimaryButton(
                          onTap: updateUserDetails,
                          text: 'Save Changes',
                          width: double.maxFinite,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator.adaptive(
              strokeWidth: 2.5,
            ),
          );
  }
}
