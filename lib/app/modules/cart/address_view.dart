import 'dart:developer';

import 'package:cartisan/app/controllers/address_controller.dart';
import 'package:cartisan/app/controllers/cart_page_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/data/helper/address_view_enum.dart';
import 'package:cartisan/app/models/address__model.dart';
import 'package:cartisan/app/modules/cart/components/address_card.dart';
import 'package:cartisan/app/modules/cart/components/custom_address_textfield.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddressView extends StatefulWidget {
  const AddressView({super.key});

  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  AddressViewEnum addressViewEnum = AddressViewEnum.address;

  @override
  Widget build(BuildContext context) {
    return GetX<AddressController>(
      init: AddressController(),
      builder: (controller) {
        if (controller.loading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }
        if (controller.addresses.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text('No Addresses found'),
            ),
          );
        }
        return Scaffold(
          body: ListView.separated(
            itemCount: controller.addresses.length,
            separatorBuilder: (context, index) => SizedBox(height: 15.h),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  controller.updatedSelectedAddress =
                      controller.addresses[index];
                  Get.find<CartPageController>().animateInitialPageToNext();
                },
                child: AddressCard(
                  addressModel: controller.addresses[index],
                  changeAddressCallback: () {
                    Get.to<Widget>(() => EditAddressView(
                          controllerAddressIndex: index,
                          address: controller.addresses[index],
                        ));
                  },
                ),
              );
            },
          ),
          // bottomSheet: Semantics(
          //   button: true,
          //   child: InkWell(
          //     onTap: () {
          //       Get.find<CartPageController>().animateInitialPageToNext();
          //     },
          //     child: Container(
          //       height: 68.h,
          //       width: double.maxFinite,
          //       alignment: Alignment.center,
          //       color: AppColors.kPrimary,
          //       child: Text(
          //         'Proceed',
          //         style: AppTypography.kLight16,
          //       ),
          //     ),
          //   ),
          // ),
        );
      },
    );
  }
}

class EditAddressView extends StatefulWidget {
  final int controllerAddressIndex;
  final AddressModel address;
  const EditAddressView({
    required this.controllerAddressIndex,
    required this.address,
    super.key,
  });

  @override
  State<EditAddressView> createState() => _EditAddressViewState();
}

class _EditAddressViewState extends State<EditAddressView> {
  final am = Get.find<AddressController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _receiptNameController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _addressLine3Controller = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (am.loading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        return Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0.w),
            children: [
              SizedBox(height: 30.h),
              CustomAddressTextField(
                heading: 'Receiver Full Name',
                hintText: widget.address.fullname,
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
                heading: 'Street Address 1',
                hintText: widget.address.addressLine1,
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
                heading: 'Street Address 2 (optional)',
                hintText: widget.address.addressLine2,
                controller: _addressLine2Controller,
                keyboardType: TextInputType.streetAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.seventeenVertical),
              CustomAddressTextField(
                heading: 'Street Address 3 (optional)',
                hintText: widget.address.addressLine3,
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
                hintText: widget.address.contactNumber,
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
                      hintText: widget.address.postalCode,
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
                  SizedBox(width: 33.w),
                  Expanded(
                    child: CustomAddressTextField(
                      heading: 'City',
                      hintText: widget.address.city,
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
                ],
              ),
              SizedBox(height: AppSpacing.seventeenVertical),
              CustomAddressTextField(
                heading: 'State',
                hintText: widget.address.state,
                controller: _stateController,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your state';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.h),
              PrimaryButton(
                text: 'Save',
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    final newAddress = AddressModel(
                      userID: widget.address.userID,
                      addressID: widget.address.addressID,
                      addressLine1: _addressLine1Controller.text,
                      addressLine2: _addressLine2Controller.text,
                      addressLine3: _addressLine3Controller.text,
                      postalCode: _zipCodeController.text,
                      contactNumber: _numberController.text,
                      city: _cityController.text,
                      state: _stateController.text,
                      fullname: _receiptNameController.text,
                    );
                    am.updateAddress(
                      newAddress: newAddress,
                      index: widget.controllerAddressIndex,
                    );
                  }
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      }),
    );
  }
}
