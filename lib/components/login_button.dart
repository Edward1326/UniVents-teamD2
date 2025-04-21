import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Function()? onTap;

  const LoginButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 334,
        height: 45.43,

        decoration: BoxDecoration(
          color: Color(0xFF163C9F),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            "Log in",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
