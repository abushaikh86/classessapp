// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unused_local_variable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pluspoint/global_helper.dart';
import 'package:pluspoint/util/constants.dart' as constants;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangePasswordPage(),
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  GlobalHelper globalHelper = GlobalHelper();
  bool _isObscure = true;
  bool _isObscure1 = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void _togglePasswordVisibility1() {
    setState(() {
      _isObscure1 = !_isObscure1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: constants.mainColor,
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: newPasswordController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                  labelText: 'New Password',
                  suffixIcon: IconButton(
                      onPressed: _togglePasswordVisibility,
                      icon: Icon(_isObscure
                          ? Icons.visibility
                          : Icons.visibility_off))),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: _isObscure1,
              decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  suffixIcon: IconButton(
                      onPressed: _togglePasswordVisibility1,
                      icon: Icon(_isObscure1
                          ? Icons.visibility
                          : Icons.visibility_off))),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Handle "Change Password" button click
                String newPassword = newPasswordController.text;
                String confirmPassword = confirmPasswordController.text;
                // Validate and process the password change
                if ((newPassword == '' || confirmPassword == '')) {
                  constants.Notification('Please Fill All Mandatory Fields');
                } else if (newPassword != confirmPassword) {
                  constants.Notification('Password Missmatch!');
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                  Map<String, dynamic> changePass = await globalHelper
                      .changePassword(newPassword, confirmPassword);
                  if (changePass['success'] != null) {
                    constants.Notification(changePass['success']);
                  } else {
                    constants.Notification(changePass['error']);
                  }
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                primary: constants.mainColor,
              ),
              child: Text(
                'Change Password',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
