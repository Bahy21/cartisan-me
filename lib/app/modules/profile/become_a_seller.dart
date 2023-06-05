import 'package:cartisan/app/api_classes/user_api.dart';
import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/modules/profile/components/custom_switch.dart';
import 'package:cartisan/app/modules/profile/components/custom_textformfield.dart';
import 'package:cartisan/app/modules/profile/components/stripe_button.dart';
import 'package:cartisan/app/modules/profile/edit_store_view.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
import 'package:cartisan/app/modules/widgets/dialogs/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BecomeASeller extends StatefulWidget {
  const BecomeASeller({super.key});

  @override
  State<BecomeASeller> createState() => _BecomeASellerState();
}

class _BecomeASellerState extends State<BecomeASeller> {
  final userApi = UserAPI();
  final _stateController = TextEditingController();
  final _taxController = TextEditingController();
  bool _pickUpAvailable = false;
  bool _shippingAvailable = false;
  bool _deliveryAvailable = false;
  UserModel get currentUser => Get.find<UserController>().currentUser!;

  bool get isReady =>
      (_stateController.text.isNotEmpty || currentUser.state.isNotEmpty) &&
      (_taxController.text.isNotEmpty || currentUser.taxPercentage != null) &&
      (_pickUpAvailable ||
          _shippingAvailable ||
          _deliveryAvailable ||
          currentUser.activeShipping ||
          currentUser.pickup ||
          currentUser.isDeliveryAvailable);

  Future<void> updateUserDetails() async {
    Get.dialog<Widget>(
      LoadingDialog(),
      barrierDismissible: false,
    );
    final newUser = currentUser.copyWith(
      isDeliveryAvailable: _deliveryAvailable,
      pickup: _pickUpAvailable,
      activeShipping: _shippingAvailable,
      isSeller: isReady,
    );
    final value = await userApi.updateUserDetails(
      userId: currentUser.id,
      newUser: newUser,
    );
    Get.back<void>();
    if (value) {
      Get.find<UserController>().updateUserInController = newUser;
      Get.back<void>();
    } else {
      await showErrorDialog('Error updating user details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var shouldPop = false;
        await Get.defaultDialog<Widget>(
          backgroundColor: AppColors.kBackground,
          content: const Text(
            'Are you sure you want to quit?',
            textAlign: TextAlign.center,
          ),
          onConfirm: () {
            shouldPop = true;
            Get.back<void>();
          },
          onCancel: () {
            shouldPop = false;
          },
          confirmTextColor: Colors.black,
          cancelTextColor: AppColors.kPrimary,
          buttonColor: AppColors.kPrimary,
        );
        return shouldPop;
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 45.h,
                  ),
                  Center(
                    child: Text(
                      'Begin your journey with Cartisan',
                      textAlign: TextAlign.center,
                      style: AppTypography.kExtraBold32,
                    ),
                  ),
                  SizedBox(
                    height: 45.h,
                  ),
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
                    hintText: (currentUser.taxPercentage ?? 0.0).toString(),
                  ),
                  SizedBox(height: 25.h),
                  Text(
                    'More Options',
                    style: AppTypography.kBold14,
                  ),
                  CustomSwitch(
                    isDisabled: false,
                    text: 'Pick Up Available',
                    value: currentUser.pickup,
                    onChanged: (value) {
                      setState(() {
                        _pickUpAvailable = value;
                      });
                    },
                  ),
                  CustomSwitch(
                    isDisabled: false,
                    text: 'Shipping Available',
                    value: currentUser.activeShipping,
                    onChanged: (value) {
                      setState(() {
                        _shippingAvailable = value;
                      });
                    },
                  ),
                  CustomSwitch(
                    isDisabled: false,
                    text: 'Delivery Available',
                    value: currentUser.isDeliveryAvailable,
                    onChanged: (value) {
                      setState(() {
                        _deliveryAvailable = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 50.0.h,
                  ),
                  Center(
                    child: isReady
                        ? StripeSection()
                        : HighImportanceTaskButton(
                            onTap: () =>
                                showErrorDialog('Please complete all fields'),
                            text: 'Connect Stripe',
                          ),
                  ),
                  if (currentUser.sellerID.isNotEmpty)
                    Center(
                      child: PrimaryButton(
                        onTap: updateUserDetails,
                        text: 'Update and Finalize',
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
