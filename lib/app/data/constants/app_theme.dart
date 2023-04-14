import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.kPrimary,
    primarySwatch: Colors.pink,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.kBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.kBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.kPrimary,
      selectionColor: AppColors.kPrimary,
      selectionHandleColor: AppColors.kPrimary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.kFilledColor,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.r),
        borderSide: BorderSide.none,
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 14.sp,
        color: Colors.white.withOpacity(0.70),
        fontWeight: FontWeight.w400,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.kGrey,
      selectedItemColor: AppColors.kPrimary,
      unselectedItemColor: AppColors.kWhite,
    ),
  );
}

SystemUiOverlayStyle defaultOverlay = const SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarColor: Colors.black,
  systemNavigationBarDividerColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.light,
);
