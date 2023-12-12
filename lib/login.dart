// ignore_for_file: prefer_const_constructors, unused_local_variable, use_build_context_synchronously, non_constant_identifier_names, avoid_init_to_null

import 'package:flutter/material.dart';
import 'package:pluspoint/dashboard.dart';
import 'package:pluspoint/global_helper.dart';
import 'package:pluspoint/splash_screen.dart';
import 'package:pluspoint/util/constants.dart' as constants;
import 'package:pluspoint/util/components/reset_password_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var mobile = TextEditingController();
  var password = TextEditingController();
  bool isPasswordValid = false;
  GlobalHelper globalHelper = GlobalHelper();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/login.jpg'),
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: 250,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Student Login',
              style: TextStyle(
                fontSize: 28, // Adjust the font size as needed
                fontWeight: FontWeight.bold, // Make the text bold
                color: constants.mainColor, // Use your primary color
              ),
            ),
            Text(
              'Please fill out the following fields to login',
              style: TextStyle(
                fontSize: 14, // Adjust the font size as needed
                color: Colors.grey, // Use a muted color for the description
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: mobile,
                    decoration: InputDecoration(
                      label: Text('Mobile Number'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(color: constants.mainColor)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: password,
                    decoration: InputDecoration(
                        label: Text('Password'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(color: constants.mainColor),
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey))),
                    obscureText: _obscureText,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var hashedPassword = "";

                      String uMobile = mobile.text.toString();
                      String uPass = password.text;
                      if (uMobile != '' && uPass != '') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );

                        // var user_info = await dbHelper?.login(uMobile, uPass);
                        var user_info =
                            await globalHelper.login(uMobile, uPass);
                        // print(user_info);
                        if (user_info['error'] != null) {
                          passwordCheck(isPasswordValid, user_info['error']);
                        } else {
                          isPasswordValid = true;
                          passwordCheck(isPasswordValid, user_info['success'],
                              user_info['student_id']);
                        }
                      } else {
                        constants.Notification(
                            'Please Fill All Required Fields');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      primary: constants
                          .mainColor, // Set the button's background color
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11)),
                      elevation: 4, // Add some elevation
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Forgot Password?'),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ResetPasswordDialog();
                            },
                          );
                        },
                        child: Text(
                          'Reset Password?',
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> passwordCheck(isPasswordValid, msg, [student_id = null]) async {
    Navigator.pop(context);
    if (isPasswordValid) {
      var sharedPref = await SharedPreferences.getInstance();
      sharedPref.setBool(SplashScreenState.KEY_LOGIN, true);
      sharedPref.setInt('student_id', student_id);
      constants.Notification(msg);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          (route) => false);
    } else {
      // print('Missmatch');
      constants.Notification(msg);
    }
  }
}
