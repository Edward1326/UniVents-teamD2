import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:univents/pages/login/login_page.dart';
import 'firebase_options.dart';

//com.example.univents
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage());
  }
}
