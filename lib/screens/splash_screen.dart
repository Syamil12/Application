import 'package:application/screens/splash_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    
    Future.delayed(Duration(seconds: 3)).then((value) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => SplashScreens(),
          ),
          (route) => false);
    },);
    return Scaffold(
      backgroundColor: Color(0xFF4894FE),
      body: Stack(
        children: [
          Center(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 276),
                  Image.asset('assets/images/logo.png', height: 130),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
