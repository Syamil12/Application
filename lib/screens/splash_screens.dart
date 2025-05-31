import 'package:application/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class SplashScreens extends StatelessWidget {
  const SplashScreens({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);    

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 276),
                  Image.asset('assets/images/logo2.png', height: 130),
                  const SizedBox(height: 200),
                  SizedBox(
                    height: 45.0,
                    width: 207.0,
                    child: ElevatedButton(onPressed: () {
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => LoginScreen()),);
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4894FE),
                    foregroundColor: Colors.white,
                  ), 
                  child: Text("Log In")),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 45.0,
                    width: 207.0,
                    child: ElevatedButton(onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4894FE),
                    foregroundColor: Colors.white,
                  ), 
                  child: Text("Sign Up")),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
