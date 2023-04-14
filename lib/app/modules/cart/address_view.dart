import 'package:cartisan/app/controllers/cart_page_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/data/helper/address_view_enum.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _receiptNameController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _secondStreetAddressController = TextEditingController();
  final _numberController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _cityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return addressViewEnum == AddressViewEnum.address
        ? Scaffold(
            body: ListView.separated(
              itemCount: 2,
              separatorBuilder: (context, index) => SizedBox(height: 15.h),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              itemBuilder: (context, index) => AddressCard(
                changeAddressCallback: () {
                  setState(() {
                    addressViewEnum = AddressViewEnum.changeAddress;
                  });
                },
              ),
            ),
            bottomSheet: Semantics(
              button: true,
              child: InkWell(
                onTap: () {
                  Get.find<CartPageController>().animateInitialPageToNext();
                },
                child: Container(
                  height: 68.h,
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  color: AppColors.kPrimary,
                  child: Text(
                    'Proceed',
                    style: AppTypography.kLight16,
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
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
                    heading: 'Street Address 1',
                    hintText: 'Enter Address',
                    controller: _streetAddressController,
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
                    hintText: 'Enter Address',
                    controller: _secondStreetAddressController,
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      return null;
                    },
                  ),
                  SizedBox(height: AppSpacing.seventeenVertical),
                  CustomAddressTextField(
                    heading: 'Contact Number',
                    hintText: '0118 - xxxxxxxxxxx',
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: _numberController,
                    keyboardType: TextInputType.number,
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
                      SizedBox(width: 33.w),
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
                    ],
                  ),
                  SizedBox(height: 50.h),
                  PrimaryButton(
                    text: 'Save',
                    onTap: () {},
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
  }
}
