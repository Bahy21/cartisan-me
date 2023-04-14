import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillingAddressDropDown extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String>? onChanged;
  const BillingAddressDropDown({
    required this.items,
    this.onChanged,
    super.key,
  });

  @override
  State<BillingAddressDropDown> createState() => _BillingAddressDropDownState();
}

class _BillingAddressDropDownState extends State<BillingAddressDropDown> {
  String? _selectedValue;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Country Region',
            style:
                AppTypography.kExtraLight12.copyWith(color: AppColors.kGrey2),
          ),
          DropdownButton<String>(
            value: _selectedValue,
            isDense: true,
            isExpanded: true,
            dropdownColor: AppColors.kWhite,
            items: widget.items
                .map((item) => DropdownMenuItem<String>(
                      child: Text(
                        item,
                        style: AppTypography.kLight15.copyWith(
                          color: AppColors.kGrey,
                        ),
                      ),
                      value: item,
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });

              if (widget.onChanged != null) {
                widget.onChanged!(value!);
              }
            },
            underline: const SizedBox(),
            hint: Text(
              'Select',
              style: AppTypography.kExtraLight12
                  .copyWith(color: AppColors.kHintColor),
            ),
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.kGrey),
          ),
        ],
      ),
    );
  }
}
