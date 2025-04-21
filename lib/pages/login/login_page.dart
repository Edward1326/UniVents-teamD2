import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:univents/components/login_textfield.dart';
import 'package:univents/components/login_button.dart';
import 'package:univents/components/login_tiles.dart';
import 'package:univents/pages/home_page.dart';
import 'package:univents/services/auth_services.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Email/Password Login
  void signInWithEmail(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Login Error'),
              content: Text(e.toString()),
            ),
      );
    }
  }

  // Google Sign-In
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Google Login Error'),
              content: Text(e.toString()),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Image.asset(
                  'lib/images/university_seal.png',
                  width: 77.3,
                  height: 77.3,
                ),
                const SizedBox(height: 2),
                const Text(
                  "UniVents",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF163C9F),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Welcome Back, Atenean!",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E3E5C),
                  ),
                ),
                const SizedBox(height: 17),
                const Text(
                  "Please enter your account here",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.3,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8189B0),
                  ),
                ),
                const SizedBox(height: 20),
                LoginTextfield(
                  controller: usernameController,
                  hintText: 'Username or Email',
                  prefixIcon: Icons.mail_outline,
                ),
                const SizedBox(height: 20),
                LoginTextfield(
                  controller: passwordController,
                  hintText: 'Password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  suffixIcon: const Icon(
                    Icons.visibility,
                    color: Color(0xFF163C9F),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 30.0),
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
                LoginButton(onTap: () => signInWithEmail(context)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Color(0xFF163C9F),
                        thickness: 1,
                        endIndent: 10,
                        indent: 42,
                      ),
                    ),
                    const Text(
                      "or continue with",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.3,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF878787),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Color(0xFF163C9F),
                        thickness: 1,
                        indent: 10,
                        endIndent: 42,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoginTiles(
                      onTap: () {},
                      imagePath: 'lib/images/facebook_icon.png',
                    ),
                    const SizedBox(width: 40),
                    LoginTiles(
                      onTap: () async {
                        try {
                          await AuthServices().signInWithGoogle();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Google Login Error'),
                                  content: Text(e.toString()),
                                ),
                          );
                        }
                      },
                      imagePath: 'lib/images/google_icon.png',
                    ),
                    const SizedBox(width: 40),
                    LoginTiles(
                      onTap: () {},
                      imagePath: 'lib/images/apple_icon.png',
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
                      " Sign up",
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
      ),
    );
  }
}
