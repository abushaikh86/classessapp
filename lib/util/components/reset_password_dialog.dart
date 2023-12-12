// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pluspoint/global_helper.dart';
import 'package:pluspoint/util/constants.dart' as constants;

class ResetPasswordDialog extends StatefulWidget {
  @override
  _ResetPasswordDialogState createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  TextEditingController mobileController = TextEditingController();
  GlobalHelper globalHelper = GlobalHelper();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Forgot Password',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Enter Mobile Number associated with your account. Click submit and contact admin for new password',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (mobileController.text.toString() != '') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );

                  // Add your code to send the mobile number and call the API here
                  // You can use mobileController.text to get the mobile number.
                  var resetPassword = await globalHelper
                      .resetPassword(mobileController.text.toString());
                  // print(resetPassword);
                  if (resetPassword == 1) {
                    constants.Notification(
                        'Password has been reset, please contact admin for new password');
                  } else {
                    constants.Notification(
                        'Please Enter Registered Mobile Number');
                  }

                  // Remove the loader
                  Navigator.pop(context);
                  Navigator.of(context)
                      .pop(); // Close the dialog after sending.
                }
              },
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
