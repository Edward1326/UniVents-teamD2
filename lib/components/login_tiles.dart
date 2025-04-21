import 'package:flutter/material.dart';

class LoginTiles extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;
  const LoginTiles({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 83,
        height: 53,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF163C9F)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Image.asset(imagePath, width: 26, height: 32),
      ),
    );
  }
}
