import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/auth/components/custom_login_field.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
import 'package:cartisan/app/services/translation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ResetPasswordDialog extends StatefulWidget {
  const ResetPasswordDialog({super.key});

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final _emailFocus = FocusNode();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_emailFocus);
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(34.r),
      ),
      contentPadding: EdgeInsets.all(28.h),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                TranslationsService.forgetPasswordPageTranslation.resetPassword,
                style: AppTypography.kLight16,
              ),
              SizedBox(height: 20.h),
              CustomLoginField(
                controller: _emailController,
                focusNode: _emailFocus,
                hintText: TranslationsService.sigInPageTranslation.email,
                iconPath: AppAssets.kMail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value!.isEmpty) {
                    return TranslationsService
                        .sigInPageTranslation.emailRequired;
                  } else if (!value.isEmail) {
                    return TranslationsService.sigInPageTranslation.validEmail;
                  }
                  return null;
                },
              ),
              SizedBox(height: 11.h),
              Text(
                TranslationsService.forgetPasswordPageTranslation.anEmail,
                style: AppTypography.kExtraLight15,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 21.h),
              Center(
                child: PrimaryButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      Get.back<void>();
                    }
                  },
                  radius: 20.r,
                  text: TranslationsService
                      .forgetPasswordPageTranslation.sendEmail,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
