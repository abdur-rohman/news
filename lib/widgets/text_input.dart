import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    Key? key,
    required this.controller,
    required this.hintText,
    this.hidePassword,
    this.suffixIcon,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final Widget? suffixIcon;
  final bool? hidePassword;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: hidePassword ?? false,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        suffixIcon: suffixIcon,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }
}
