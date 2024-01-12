import 'package:flutter/material.dart';

SnackBar PersonalSnackBarWidget(String mex, int color) {
  if (color == 0) {
    return SnackBar(
        content: Text(mex, style: TextStyle(fontSize: 20, color: Colors.black)),
        backgroundColor: Colors.red);
  } else {
    return SnackBar(
        content: Text(mex, style: TextStyle(fontSize: 20, color: Colors.black)),
        backgroundColor: Colors.green);
  }
}
