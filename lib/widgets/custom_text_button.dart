import 'package:flutter/material.dart';
import 'package:supermarket_app_03072025/utils/app_styles.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final TextStyle? textStyle;
  final Color? foregroundColor;

  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textStyle,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor ?? Theme.of(context).colorScheme.primary,
      ),
      child: Text(
        text,
        style: textStyle ?? AppStyles.linkTextStyle,
      ),
    );
  }
}