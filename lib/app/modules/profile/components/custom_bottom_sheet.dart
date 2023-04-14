import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/profile/components/custom_switch.dart';
import 'package:cartisan/app/modules/profile/components/custom_textformfield.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({super.key});

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  late ScrollController _scrollController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _pickUpAvailable = false;
  bool _shippingAvailable = true;
  bool _deliveryAvailable = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.2,
      maxChildSize: 0.7,
      expand: false,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16.r),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 2,
                    padding: EdgeInsets.only(
                      top: 50.h,
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
                            hintText: 'Thrift Store',
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
                            hintText:
                                'This is the new thrift store. Large variety of products',
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
                            text: 'Pick Up Available',
                            value: _pickUpAvailable,
                            onChanged: (value) {
                              setState(() {
                                _pickUpAvailable = value;
                              });
                            },
                          ),
                          CustomSwitch(
                            text: 'Shipping Available',
                            value: _shippingAvailable,
                            onChanged: (value) {
                              setState(() {
                                _shippingAvailable = value;
                              });
                            },
                          ),
                          CustomSwitch(
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
                            onTap: () {},
                            text: 'Save Changes',
                            width: double.maxFinite,
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
