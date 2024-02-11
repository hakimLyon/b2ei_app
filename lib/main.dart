import 'package:b2ei_app/constant.dart';
import 'package:b2ei_app/pages/HomePage.dart';
import 'package:flutter/material.dart';
//import 'pages/HomePage.dart';
import 'pages/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Authentification',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      routes: {
        "home": (context) => HomePage()
      },
      home: SplashScreen(),
    );
  }
}

