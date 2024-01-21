import 'package:OttGirl/webview.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Ott Girl';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.blue),
    home: AnimatedSplashScreen(

      splash: Image.asset('assets/logo.png'), // Replace with your splash image
      splashIconSize: double.infinity,
      nextScreen: WebViewScreen(),
      splashTransition: SplashTransition.scaleTransition,

      duration: 500, // Adjust the duration as needed (milliseconds)
    ),
  );
}


