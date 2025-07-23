import 'package:flutter/material.dart';


class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Animation<Offset>? slideAnimation;
  final void Function(String)? onChanged;
  final int? maxLength;
  final TextAlign textAlign;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.slideAnimation,
    this.onChanged,
    this.maxLength,
    this.textAlign = TextAlign.start, IconButton? suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Widget textField = TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textAlign: textAlign,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Entrez votre $label',
        prefixIcon: Icon(icon, color: colorScheme.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: colorScheme.surfaceVariant.withOpacity(0.1),
        counterText: maxLength != null ? '' : null, // Hide counter if maxLength is set
      ),
      validator: validator,
      onChanged: onChanged,
      maxLength: maxLength,
    );

    return slideAnimation != null
        ? SlideTransition(position: slideAnimation!, child: textField)
        : textField;
  }
}