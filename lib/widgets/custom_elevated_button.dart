import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final double minWidth;
  final double height;
  final BorderRadius borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final TextStyle? textStyle;
  final Widget? icon;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.minWidth = double.infinity,
    this.height = 50.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(minWidth, height),
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        backgroundColor: backgroundColor ?? colorScheme.primary,
        foregroundColor: foregroundColor ?? colorScheme.onPrimary,
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: textStyle ??
                      textTheme.labelLarge?.copyWith(color: foregroundColor ?? colorScheme.onPrimary),
                ),
              ],
            ),
    );
  }
}