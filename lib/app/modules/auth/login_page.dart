import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/auth/components/cartisan_logo.dart';
import 'package:cartisan/app/modules/auth/components/custom_login_field.dart';
import 'package:cartisan/app/modules/auth/components/reset_password_dialog.dart';
import 'package:cartisan/app/modules/auth/signup_page.dart';
import 'package:cartisan/app/modules/landingPage/landing_page.dart';
import 'package:cartisan/app/modules/widgets/buttons/custom_text_button.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
import 'package:cartisan/app/modules/widgets/dialogs/loading_dialog.dart';
import 'package:cartisan/app/services/translation_service.dart';
import 'package:cartisan/app/services/user_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final _emailFocus = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();

  Future<void> _handleLogin() async {
    await UserAuthService().signInWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
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
                SizedBox(height: 43.h),
                Text(
                  TranslationsService.sigInPageTranslation.welcomeCartisan,
                  textAlign: TextAlign.center,
                  style: AppTypography.kExtraLight16
                      .copyWith(color: AppColors.kLightGrey),
                ),
                SizedBox(height: 35.h),
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
                SizedBox(height: 10.h),
                CustomLoginField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  isPasswordField: true,
                  hintText: TranslationsService.sigInPageTranslation.password,
                  iconPath: AppAssets.kLock,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
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
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomTextButton(
                    onPressed: () {
                      Get.dialog<Widget>(
                        const ResetPasswordDialog(),
                        barrierDismissible: false,
                      );
                    },
                    text:
                        TranslationsService.sigInPageTranslation.forgetPassword,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 160.h),
                PrimaryButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _handleLogin();
                    }
                  },
                  text: TranslationsService.sigInPageTranslation.signIn,
                  width: 211.w,
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Get.to<Widget>(
                      () => const SignUpPage(),
                    );
                  },
                  child: Text(
                    '${TranslationsService.sigInPageTranslation.noAccount} ${TranslationsService.sigInPageTranslation.signUp}',
                    style: AppTypography.kLight14
                        .copyWith(color: AppColors.kPrimary),
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
