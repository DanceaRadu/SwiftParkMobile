import 'package:flutter/material.dart';
import '../../color_palette.dart';
import '../../styling_variables.dart';

class MainTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool autofocus;

  const MainTextField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: ColorPalette.textColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(StylingVariables.borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(StylingVariables.borderRadius),
          borderSide: const BorderSide(
            color: Color.fromRGBO(130, 130, 130, 1.0),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(StylingVariables.borderRadius),
          borderSide: const BorderSide(
            color: ColorPalette.accent,
            width: 2.0,
          ),
        ),
      ),
      style: const TextStyle(color: ColorPalette.textColor),
    );
  }
}