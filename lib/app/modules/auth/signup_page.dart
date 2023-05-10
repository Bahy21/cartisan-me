import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/auth/components/cartisan_logo.dart';
import 'package:cartisan/app/modules/auth/components/custom_login_field.dart';
import 'package:cartisan/app/modules/widgets/buttons/custom_text_button.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
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
  final _confirmPasswordFocus = FocusNode();
  final TextEditingController _sellerController = TextEditingController();
  final _sellerFocus = FocusNode();

  Future<void> _handleRegistration() async {
    await UserAuthService().signUpWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
      isSeller: false,
      taxPercentage: 0,
      city: 'Miami',
      country: 'America',
      state: 'LA',
    );
    Get.back<void>();
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _nameFocus.dispose();
    _confirmPasswordFocus.dispose();
    _sellerFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                    } else if (value.length <= 8) {
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
                    } else if (value.length <= 8) {
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
                CustomLoginField(
                  controller: _sellerController,
                  focusNode: _sellerFocus,
                  isSeller: true,
                  hintText: TranslationsService.sigUpPageTranslation.areYouSell,
                  iconPath: AppAssets.kCheckSquare,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return TranslationsService
                          .sigUpPageTranslation.fieldRequired;
                    }
                    return null;
                  },
                ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      TranslationsService
                          .sigUpPageTranslation.alreadyHaveAccount,
                      style: AppTypography.kLight14
                          .copyWith(color: AppColors.kPrimary),
                    ),
                    CustomTextButton(
                      onPressed: () {
                        Get.back<void>();
                      },
                      text: TranslationsService.sigInPageTranslation.signIn,
                    ),
                  ],
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
