import 'package:cartisan/app/api_classes/user_api.dart';
import 'package:cartisan/app/controllers/address_controller.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/address__model.dart';
import 'package:cartisan/app/modules/cart/components/custom_address_textfield.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NewAddressView extends StatefulWidget {
  const NewAddressView({super.key});

  @override
  State<NewAddressView> createState() => NnewAddressStateView();
}

class NnewAddressStateView extends State<NewAddressView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _receiptNameController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _addressLine3Controller = TextEditingController();
  final _stateController = TextEditingController();
  final _numberController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _cityController = TextEditingController();

  Future<void> createNewAddress() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newAddress = AddressModel(
        userID: Get.find<AuthService>().currentUser!.uid,
        addressID: '',
        addressLine1: _addressLine1Controller.text,
        addressLine2: _addressLine2Controller.text,
        addressLine3: _addressLine3Controller.text,
        postalCode: _zipCodeController.text,
        contactNumber: _numberController.text,
        city: _cityController.text,
        state: _stateController.text,
        fullname: _receiptNameController.text,
      );
      await ac.newAddress(newAddress);
    }
  }

  final ac = Get.find<AddressController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ac.loading) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Add New Address',
            style: AppTypography.kBold18.copyWith(color: AppColors.kWhite),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back<void>();
            },
            icon: const Icon(
              Icons.close,
              color: AppColors.kWhite,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0.w),
            children: [
              SizedBox(height: 30.h),
              CustomAddressTextField(
                heading: 'Receiver Full Name',
                hintText: 'Enter Full Name',
                controller: _receiptNameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 17.h),
              CustomAddressTextField(
                heading: 'Address Line 1',
                hintText: 'Enter Address',
                controller: _addressLine1Controller,
                keyboardType: TextInputType.streetAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your street address';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.seventeenVertical),
              CustomAddressTextField(
                heading: 'Address Line 2 (optional)',
                hintText: 'Enter Address',
                controller: _addressLine2Controller,
                keyboardType: TextInputType.streetAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.seventeenVertical),
              CustomAddressTextField(
                heading: 'Address Line 3 (optional)',
                hintText: 'Enter Address',
                controller: _addressLine3Controller,
                keyboardType: TextInputType.streetAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.seventeenVertical),
              CustomAddressTextField(
                heading: 'Contact Number',
                hintText: '+1 (650) xxxxxxxx',
                controller: _numberController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your contact number';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.seventeenVertical),
              Row(
                children: [
                  Expanded(
                    child: CustomAddressTextField(
                      heading: 'Zip Code',
                      hintText: 'Area zip code',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: _zipCodeController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your zip code';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.seventeenVertical),
              Expanded(
                child: CustomAddressTextField(
                  heading: 'City',
                  hintText: 'City',
                  controller: _cityController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: AppSpacing.seventeenVertical),
              CustomAddressTextField(
                heading: 'State',
                hintText: 'State',
                controller: _stateController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your state';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.seventeenVertical),
              PrimaryButton(
                text: 'Save',
                onTap: createNewAddress,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      );
    });
  }
}
