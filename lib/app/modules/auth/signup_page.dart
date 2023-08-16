import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/modules/auth/components/cartisan_logo.dart';
import 'package:cartisan/app/modules/auth/components/custom_login_field.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
import 'package:cartisan/app/modules/widgets/custom_state_drop_down.dart';
import 'package:cartisan/app/modules/widgets/dialogs/loading_dialog.dart';
import 'package:cartisan/app/services/translation_service.dart';
import 'package:cartisan/app/services/user_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final _nameFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final _emailFocus = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  final _confirmPasswordFocus = FocusNode();
  bool _isSeller = false;
  String? selectedState;

  Future<void> _handleRegistration() async {
    try {
      showLoadingDialog(context, dismissible: false);
      final status = await UserAuthService().signUpWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        isSeller: _isSeller,
        taxPercentage: double.tryParse(_taxController.text) ?? 0.0,
        city: '',
        country: 'America',
        state: selectedState ?? '',
      );
      if (status) {
        hideLoadingDialog();
        Get.back<void>();
      } else {
        await showErrorDialog('Error creating account');
      }
    } on Exception catch (e) {
      hideLoadingDialog();
      await showErrorDialog('Error creating account: $e');
    }
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _nameFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 19.w),
            child: Column(
              children: [
                SizedBox(height: 110.h),
                const CartisanLogo(),
                SizedBox(height: 34.h),
                CustomLoginField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  hintText:
                      TranslationsService.sigUpPageTranslation.nameOrStore,
                  iconPath: AppAssets.kUser,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return TranslationsService
                          .sigUpPageTranslation.nameRequired;
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.tenVertical),
                CustomLoginField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  hintText: TranslationsService.sigInPageTranslation.email,
                  iconPath: AppAssets.kMail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return TranslationsService
                          .sigInPageTranslation.emailRequired;
                    } else if (!value.isEmail) {
                      return TranslationsService
                          .sigInPageTranslation.validEmail;
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.tenVertical),
                CustomLoginField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  isPasswordField: true,
                  hintText: TranslationsService.sigInPageTranslation.password,
                  iconPath: AppAssets.kLock,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return TranslationsService
                          .sigInPageTranslation.passwordRequired;
                    } else if (value.length <= 6) {
                      return TranslationsService
                          .sigInPageTranslation.validPassword;
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.tenVertical),
                CustomLoginField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,
                  isPasswordField: true,
                  hintText:
                      TranslationsService.sigUpPageTranslation.confirmPassword,
                  iconPath: AppAssets.kLock,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return TranslationsService
                          .sigInPageTranslation.passwordRequired;
                    } else if (value.length <= 6) {
                      return TranslationsService
                          .sigInPageTranslation.validPassword;
                    } else if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      return TranslationsService
                          .sigUpPageTranslation.passwordNotMatch;
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.tenVertical),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.kFilledColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
                    title: Text(
                      TranslationsService.sigUpPageTranslation.areYouSell,
                      style: AppTypography.kLight14
                          .copyWith(color: AppColors.kLightGrey),
                    ),
                    activeColor: AppColors.kPrimary,
                    value: _isSeller,
                    onChanged: (newState) {
                      setState(() {
                        _isSeller = newState!;
                      });
                    },
                  ),
                ),
                if (_isSeller) ...[
                  SizedBox(height: AppSpacing.tenVertical),
                  CustomStateDropDown(
                    onStateChanged: (value) {
                      setState(() {
                        selectedState = value;
                        debugPrint(selectedState);
                      });
                    },
                  ),
                  SizedBox(height: AppSpacing.tenVertical),
                  CustomLoginField(
                    controller: _taxController,
                    hintText: 'Tax',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return TranslationsService
                            .sigUpPageTranslation.fieldRequired;
                      } else if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSpacing.tenVertical),
                ],
                SizedBox(height: 32.h),
                PrimaryButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _handleRegistration();
                    }
                  },
                  text: TranslationsService.sigInPageTranslation.signUp,
                  width: 211.w,
                ),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () {
                    Get.back<void>();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${TranslationsService.sigUpPageTranslation.alreadyHaveAccount} ${TranslationsService.sigInPageTranslation.signIn}',
                        style: AppTypography.kLight14
                            .copyWith(color: AppColors.kPrimary),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 52.h),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '${TranslationsService.sigUpPageTranslation.bySigningUp} \n',
                        style: AppTypography.kLight14
                            .copyWith(color: AppColors.kLightGrey),
                      ),
                      TextSpan(
                        text: TranslationsService
                            .sigUpPageTranslation.termsAndConditions,
                        style: AppTypography.kLight14.copyWith(
                          color: AppColors.kPrimary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' ${TranslationsService.sigUpPageTranslation.ofCartisan}',
                        style: AppTypography.kLight14.copyWith(
                          color: AppColors.kLightGrey,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
