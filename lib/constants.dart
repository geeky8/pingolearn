// ignore_for_file: valid_regexps

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Text customText(String data, double fontSize, FontWeight fontWeight,
    {Color? color, int? maxLines}) {
  return Text(
    data,
    maxLines: maxLines,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    ),
  );
}

RegExp emailRegex = RegExp('^[w-.]+@([w-]+.)+[w-]{2,4}\$');

typedef TextValidator = String? Function(String?)?;

Widget customTextFormField(
  TextEditingController controller,
  TextInputType keyboardType,
  String label,
  String hint,
  IconData icon, {
  TextValidator? validator,
  bool? obscureText,
}) {
  return SizedBox(
    height: 40,
    child: TextFormField(
      controller: controller,
      obscureText: obscureText ?? false,
      style: const TextStyle(fontSize: 15),
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        icon: Icon(
          icon,
          color: Colors.grey,
        ),
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        errorStyle: const TextStyle(fontSize: 12),
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blue[700]!),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.red[700]!),
        ),
      ),
    ),
  );
}
