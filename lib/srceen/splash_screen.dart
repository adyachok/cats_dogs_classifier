import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'welcome_screen.dart';

class MySplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SplashScreen(
        seconds: 2,
        navigateAfterSeconds: WelcomeScreen(),
        title: Text(
          'Animal Classifier',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Color(0x00ffff)),
        ),
        image: Image.asset('assets/images/zebra.jpg'),
        backgroundColor: Colors.blueAccent,
        photoSize: MediaQuery.of(context).size.width / 2,
        loaderColor: Color(0x004242),
      ),
    );
  }
}
