import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomLoginField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String iconPath;
  final FocusNode focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final bool isPasswordField;
  final bool isSeller;
  const CustomLoginField({
    required this.controller,
    required this.hintText,
    required this.iconPath,
    required this.focusNode,
    super.key,
    this.isSeller = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.isPasswordField = false,
  });

  @override
  State<CustomLoginField> createState() => _CustomLoginFieldState();
}

class _CustomLoginFieldState extends State<CustomLoginField> {
  bool isObscure = true;
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPasswordField && isObscure,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      style: AppTypography.kLight14,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 18.w),
        prefixIcon: !widget.isSeller
            ? Padding(
                padding: EdgeInsets.all(AppSpacing.twelveVertical),
                child: SvgPicture.asset(widget.iconPath),
              )
            : null,
        suffixIcon: widget.isSeller
            ? Padding(
                padding: EdgeInsets.all(AppSpacing.twelveVertical),
                child: SvgPicture.asset(AppAssets.kCheckSquare),
              )
            : widget.isPasswordField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: isObscure
                        ? const Icon(
                            Icons.visibility,
                            color: AppColors.kPrimary,
                          )
                        : const Icon(
                            Icons.visibility_off,
                            color: AppColors.kPrimary,
                          ),
                  )
                : null,
        hintText: widget.hintText,
      ),
    );
  }
}
