import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropDown extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String>? onChanged;
  const CustomDropDown({
    required this.items,
    this.onChanged,
    super.key,
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? _selectedValue;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose :', style: AppTypography.kBold14),
        SizedBox(height: AppSpacing.thirteenVertical),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: AppColors.kWhite),
          ),
          child: DropdownButton<String>(
            value: _selectedValue,
            isDense: true,
            isExpanded: true,
            items: widget.items
                .map((item) => DropdownMenuItem<String>(
                      child: Text(item, style: AppTypography.kExtraLight12),
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
              style: AppTypography.kExtraLight12,
            ),
          ),
        ),
      ],
    );
  }
}
