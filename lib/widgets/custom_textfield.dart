import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class UserField extends StatelessWidget {
  final TextEditingController controller;
  TextInputType? textInputType;
  String? hintText;
  IconData? iconName;
  bool? obscureText;
  double? width;

  String? Function(String? value)? validator;
  VoidCallback? onPressed;

  UserField(
      {super.key,
      required this.controller,
      this.hintText,
      this.textInputType,
      this.validator,
      this.obscureText,
      this.iconName,
      this.onPressed,
      this.width = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Text(text!),
        TextFormField(
          obscureText: obscureText ?? false,
          keyboardType: textInputType,
          controller: controller,
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.fredoka(),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: width!),
                  borderRadius: BorderRadius.circular(10)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: width!),
                  borderRadius: BorderRadius.circular(10)),
              suffixIcon: IconButton(
                  onPressed: onPressed,
                  icon: Icon(iconName, color: Colors.blueGrey.shade700))),
          validator: validator!,
          // onChanged: onChanged!,
        ),
      ],
    );
  }
}