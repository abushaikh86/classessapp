// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pluspoint/dashboard.dart';
import 'package:pluspoint/login.dart';
import 'package:pluspoint/util/constants.dart' as constants;
// import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const String KEY_LOGIN = "login";
  late AnimationController controller;
  late Animation<double> animation;
  late Animation<Color?> _colorAnimation;
  var time = 4;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: time),
    );

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    _colorAnimation = ColorTween(
      begin: Colors.white, // Initial color (white)
      end: Colors.green, // Final color (green)
    ).animate(controller);

    controller.forward();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // The animation has completed; you can navigate to the next screen here
      }
    });

    loginCheck();
  }

  Future<void> loginCheck() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    var isLogged = sharedPrefs.getBool(KEY_LOGIN);
    // var studentId = sharedPrefs.getInt('student_id');

    Timer(Duration(seconds: time), () {
      if (isLogged != null && isLogged) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: constants.mainColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: animation,
                // width: 80,
                // height: 80,
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   shape: BoxShape.circle,
                // ),
                child: Image.asset(
                  'assets/logo_text.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: _colorAnimation,
                  strokeWidth: 5.0,
                ),
              ),
              // FadeTransition(
              //   opacity: animation,
              //   child: Text(
              //     'Plus Point',
              //     style: GoogleFonts.robotoMono(
              //       textStyle: TextStyle(
              //         color: Colors.white,
              //         fontSize: 30,
              //         fontWeight: FontWeight.w600,
              //         fontStyle: FontStyle.italic,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
