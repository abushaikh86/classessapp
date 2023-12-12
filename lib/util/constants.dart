// ignore_for_file: non_constant_identifier_names, constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const SUCCESS_MESSAGE = " You will be contacted by us very soon.";

// Api related
const project_url = "http://parasightdemo.com/classesapp/";
const apiBaseURL = "http://parasightdemo.com/classesapp/api";
const databaseName = "pluspoin_classesapp.db";

double Latitude = 0.0;
double Longitude = 0.0;

Color mainColor = Color(0xFF7565C6);
Color secColor = Color.fromRGBO(167, 205, 236, 1);

// Asset Constants
const navBarLogoImage = "images/logo-alt.png";

void Notification(var message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: mainColor,
      textColor: Colors.white,
      fontSize: 16.0);
}
