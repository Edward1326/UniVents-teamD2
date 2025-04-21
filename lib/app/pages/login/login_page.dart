import 'package:flutter/material.dart';
import 'package:univents/app/components/login_textfield.dart';
import 'package:univents/app/components/login_button.dart';
import 'package:univents/app/components/login_tiles.dart';
import 'package:univents/app/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),

              //University Seal
              Image.asset(
                'lib/app/images/university_seal.png',
                width: 77.3,
                height: 77.3,
              ),

              const SizedBox(height: 2),

              //UniVents
              Text(
                "UniVents",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF163C9F),
                ),
              ),

              const SizedBox(height: 20),

              //welcome
              Text(
                "Welcome Back, Atenean!",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E3E5C),
                ),
              ),

              const SizedBox(height: 17),

              //Please enter
              Text(
                "Please enter your account here",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.3,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF8189B0),
                ),
              ),

              const SizedBox(height: 20),

              //username textfield
              LoginTextfield(
                controller: usernameController,
                hintText: 'Username or Email',
                prefixIcon: Icons.mail_outline,
              ),

              const SizedBox(height: 20),

              //password textfield
              LoginTextfield(
                controller: passwordController,
                hintText: 'Password',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                suffixIcon: Icon(Icons.visibility, color: Color(0xFF163C9F)),
              ),

              const SizedBox(height: 20),

              //Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14.3,
                      color: Color(0xFF163C9F),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              //Login button
              LoginButton(onTap: () => HomePage()),

              const SizedBox(height: 20),

              //or continue with
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: Color(0xFF163C9F),
                      thickness: 1,
                      endIndent: 10,
                      indent: 42,
                    ),
                  ),
                  Text(
                    "or continue with",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.3,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF878787),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Color(0xFF163C9F),
                      thickness: 1,
                      indent: 10,
                      endIndent: 42,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              //google+fb+apple
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoginTiles(imagePath: 'lib/app/images/facebook_icon.png'),
                  SizedBox(width: 40),
                  LoginTiles(imagePath: 'lib/app/images/google_icon.png'),
                  SizedBox(width: 40),
                  LoginTiles(imagePath: 'lib/app/images/apple_icon.png'),
                ],
              ),
              SizedBox(height: 40),
              //dont have an account? Sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have any account?",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.3,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2E3E5C),
                    ),
                  ),
                  Text(
                    "Sign up",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.3,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF163C9F),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
