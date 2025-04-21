import 'package:flutter/material.dart';

class LoginTextfield extends StatelessWidget {
  final controller;
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;

  const LoginTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 334,
      height: 57.2,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIcon, color: Color(0xFF163C9F)),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Color(0xFF8189B0).withOpacity(0.1),
          contentPadding: EdgeInsets.symmetric(
            vertical: 18.0,
            horizontal: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.26),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }
}
