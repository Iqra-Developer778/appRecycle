import 'package:flutter/material.dart';

class AppWidget{

  //function name is headlinetextstyle
  static TextStyle headlinetextstyle(double size){

    return TextStyle(
        color: Colors.black,
        fontSize: size,
        fontWeight: FontWeight.bold);
  }

  static TextStyle normaltextstyle(double size){

    return TextStyle(
        color: Colors.black,
        fontSize: size,
        fontWeight: FontWeight.w500);
  }

  static TextStyle whitetextstyle(double size){

    return TextStyle(
        color: Colors.white,
        fontSize: size,
        fontWeight: FontWeight.bold);
  }

  static TextStyle greentextstyle(double size){

    return TextStyle(
        color: Colors.green,
        fontSize: size,
        fontWeight: FontWeight.bold);
  }
}