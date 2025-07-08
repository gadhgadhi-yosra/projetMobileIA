
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  static final TextStyle headline1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final TextStyle headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static final TextStyle bodyText2 = TextStyle(
    fontSize: 14,
    color: AppColors.grey,
  );

  static final TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static final TextStyle linkTextStyle = TextStyle(
    fontSize: 14,
    color: AppColors.secondary,
    decoration: TextDecoration.underline,
  );
}