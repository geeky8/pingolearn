import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pingolearn/screens/home_screen.dart';
import 'package:pingolearn/screens/login_screen.dart';
import 'package:pingolearn/screens/signup_screen.dart';
import 'package:pingolearn/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.nunitoTextTheme(),
      ),
      // theme: GoogleFonts.numansTextTheme(),

      home: SplashScreen(),
    );
  }
}
