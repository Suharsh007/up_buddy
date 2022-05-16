import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:up_buddy/Utilities/themes.dart';
import 'package:up_buddy/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      /* theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ),
      ),*/
      theme: MyTheme.lightTheme(context),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
