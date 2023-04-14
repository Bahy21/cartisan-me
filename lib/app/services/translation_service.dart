import 'package:get/get.dart';

class TranslationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          // Login.
          'welcome_to_cartisan':
              'Welcome to Cartisan! Find and buy\nproducts from artisans, makers and\nbusiness near and far.',
          'email': 'Email',
          'password': 'Password',
          'forget_password': 'Forget Password?',
          'email_required': 'Email is required',
          'valid_email': 'Enter a valid email address',
          'password_required': 'Password is required',
          'valid_password': 'Your password Length must be greater than 6!',
          'sign_in': 'Sign In',
          "don't_have_ account": " Don't have an account?",
          'sign_up': 'Sign Up',
          // Sign Up.
          'name_or_store': 'Name or Store Name',
          'name_required': 'Name is required',
          'confirm_password': 'Confirm Password',
          'password_not_match': 'Password does not match',
          'are_you_sell': 'Are you a seller?',
          'already_have_account': 'Already have an account?',
          'by_signing_up': 'By signing up, you agree to our',
          'terms_and_conditions': 'Terms and Conditions',
          'of_cartisan': 'of Cartisan',
          'field_required': 'This field is required',
          // Forget Password.
          'reset_password': 'Reset Password',
          'an_email':
              'An email will be sent to the above\naddress with instructions to reset\nyour password.',
          'send_email': 'Send Email',

          // Profile.
          'edit_profile': 'Edit Profile',
          'free_pickup': 'Free Pickup',
          'free_shipping': 'Free Shipping',
          'local_delivery': 'Local Delivery',
          'posts': 'Posts',
          'followers': 'Followers',
          'following': 'Followings',
          'follow': 'Follow',
          'chat': 'Chat',
        },
      };
}

class SignInPageTranslation {
  String welcomeCartisan = 'welcome_to_cartisan'.tr;
  String email = 'email'.tr;
  String password = 'password'.tr;
  String forgetPassword = 'forget_password'.tr;
  String emailRequired = 'email_required'.tr;
  String validEmail = 'valid_email'.tr;
  String passwordRequired = 'password_required'.tr;
  String validPassword = 'valid_password'.tr;
  String signIn = 'sign_in'.tr;
  String noAccount = "don't_have_ account".tr;
  String signUp = 'sign_up'.tr;
}

class SignUpPageTranslation {
  String nameOrStore = 'name_or_store'.tr;
  String nameRequired = 'name_required'.tr;
  String confirmPassword = 'confirm_password'.tr;
  String passwordNotMatch = 'password_not_match'.tr;
  String areYouSell = 'are_you_sell'.tr;
  String alreadyHaveAccount = 'already_have_account'.tr;
  String bySigningUp = 'by_signing_up'.tr;
  String termsAndConditions = 'terms_and_conditions'.tr;
  String ofCartisan = 'of_cartisan'.tr;
  String fieldRequired = 'field_required'.tr;
}

class ForgetPasswordPageTranslation {
  String resetPassword = 'reset_password'.tr;
  String sendEmail = 'send_email'.tr;
  String anEmail = 'an_email'.tr;
}

class StorePageTranslation {
  String editProfile = 'edit_profile'.tr;
  String freePickup = 'free_pickup'.tr;
  String freeShipping = 'free_shipping'.tr;
  String localDelivery = 'local_delivery'.tr;
  String posts = 'posts'.tr;
  String followers = 'followers'.tr;
  String following = 'following'.tr;
  String follow = 'follow'.tr;
  String chat = 'chat'.tr;
}

class TranslationsService {
  static SignInPageTranslation sigInPageTranslation = SignInPageTranslation();
  static SignUpPageTranslation sigUpPageTranslation = SignUpPageTranslation();
  static ForgetPasswordPageTranslation forgetPasswordPageTranslation =
      ForgetPasswordPageTranslation();
  static StorePageTranslation storePageTranslation = StorePageTranslation();
}
