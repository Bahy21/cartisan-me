// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cartisan/app/api_classes/user_api.dart';
import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/modules/profile/components/custom_switch.dart';
import 'package:cartisan/app/modules/profile/components/custom_textformfield.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
  UserModel get currentUser => Get.find<UserController>().currentUser!;
  final userApi = UserAPI();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _stateController;
  late TextEditingController _taxController;

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
    _nameController = TextEditingController(text: currentUser.profileName);
    _descriptionController = TextEditingController(text: currentUser.bio);
    _pickUpAvailable = currentUser.pickup;
    _shippingAvailable = currentUser.activeShipping;
    _deliveryAvailable = currentUser.isDeliveryAvailable;
    _stateController = TextEditingController(text: currentUser.state);
    _taxController = TextEditingController(
        text: (currentUser.taxPercentage ?? 0).toString());
    _isSeller = currentUser.sellerID.isNotEmpty &&
        currentUser.taxPercentage != null &&
        currentUser.state.isNotEmpty;
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
    final newUser = currentUser.copyWith(
      url: newImageUrl ?? currentUser.url,
      profileName: _nameController.text,
      username: _nameController.text,
      bio: _descriptionController.text,
      isDeliveryAvailable: _deliveryAvailable,
      pickup: _pickUpAvailable,
      activeShipping: _shippingAvailable,
      isSeller: _isSeller,
    );
    final value = await userApi.updateUserDetails(
      userId: currentUser.id,
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
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
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
                            textPaddingFromTop: 10.h,
                            maxLines: 4,
                            hintText: (currentUser.bio?.isEmpty ?? false)
                                ? 'Enter bio here'
                                : currentUser.bio!,
                          ),
                          SizedBox(
                            height: AppSpacing.eighteenVertical,
                          ),
                          SizedBox(height: AppSpacing.eighteenVertical),
                          if (uc.currentUser?.isActiveSeller ?? false)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'State',
                                  style: AppTypography.kBold14,
                                ),
                                CustomTextFormField(
                                  controller: _stateController,
                                  validator: (value) {
                                    return null;
                                  },
                                  hintText: currentUser.state.isEmpty
                                      ? 'Enter your state here'
                                      : currentUser.state,
                                ),
                                SizedBox(height: AppSpacing.eighteenVertical),
                                Text(
                                  'Tax Percentage',
                                  style: AppTypography.kBold14,
                                ),
                                CustomTextFormField(
                                  controller: _taxController,
                                  validator: (value) {
                                    return null;
                                  },
                                  hintText: currentUser.taxPercentage == null
                                      ? 'Enter tax here'
                                      : currentUser.taxPercentage.toString(),
                                ),
                                SizedBox(height: 25.h),
                                Text(
                                  'More Options',
                                  style: AppTypography.kBold14,
                                ),
                                SizedBox(
                                  height: AppSpacing.twelveVertical,
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
                              ],
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
            ),
          )
        : const Center(
            child: CircularProgressIndicator.adaptive(
              strokeWidth: 2.5,
            ),
          );
  }
}
