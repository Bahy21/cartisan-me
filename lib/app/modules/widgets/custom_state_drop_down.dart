import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomStateDropDown extends StatefulWidget {
  final void Function(String?) onStateChanged;
  final String? selectedState;
  final bool isSellerPage;

  const CustomStateDropDown({
    required this.onStateChanged,
    this.selectedState,
    this.isSellerPage = false,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomStateDropDown> createState() => _CustomStateDropDownState();
}

class _CustomStateDropDownState extends State<CustomStateDropDown> {
  String? selectedState;

  @override
  void initState() {
    super.initState();
    selectedState = widget.selectedState;
  }

  List<String> states = [
    'Alabama',
    'Alaska',
    'Arizona',
    'Arkansas',
    'California',
    'Colorado',
    'Connecticut',
    'Delaware',
    'Florida',
    'Georgia',
    'Hawaii',
    'Idaho',
    'Illinois',
    'Indiana',
    'Iowa',
    'Kansas',
    'Kentucky',
    'Louisiana',
    'Maine',
    'Maryland',
    'Massachusetts',
    'Michigan',
    'Minnesota',
    'Mississippi',
    'Missouri',
    'Montana',
    'Nebraska',
    'Nevada',
    'New Hampshire',
    'New Jersey',
    'New Mexico',
    'New York',
    'North Carolina',
    'North Dakota',
    'Ohio',
    'Oklahoma',
    'Oregon',
    'Pennsylvania',
    'Rhode Island',
    'South Carolina',
    'South Dakota',
    'Tennessee',
    'Texas',
    'Utah',
    'Vermont',
    'Virginia',
    'Washington',
    'West Virginia',
    'Wisconsin',
    'Wyoming',
  ];

  @override
  Widget build(BuildContext context) {
    //TODO: Need to Update User Data
    if (!states.contains(selectedState)) {
      selectedState = states.first;
    }
    return Container(
      padding: widget.isSellerPage
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: widget.isSellerPage ? null : AppColors.kFilledColor,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: DropdownButton<String?>(
        value: selectedState,
        isExpanded: true,
        hint: Text(
          'State',
          style: AppTypography.kLight14,
        ),
        underline: widget.isSellerPage ? null : const SizedBox(),
        menuMaxHeight: 300.h,
        
        onChanged: (newValue) {
          setState(() {
            selectedState = newValue;
            widget.onStateChanged(selectedState);
          });
        },
        items: states.map<DropdownMenuItem<String?>>((value) {
          return DropdownMenuItem<String?>(
            value: value,
            child: Text(
              value,
              style: AppTypography.kLight14,
            ),
          );
        }).toList(),
      ),
    );
  }
}
