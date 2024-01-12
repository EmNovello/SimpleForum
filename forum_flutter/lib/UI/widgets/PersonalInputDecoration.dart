import 'package:flutter/material.dart';

InputDecoration PersonalInputDecoration(String hint) {
  if (hint == "Email") {
    return InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 20),
        icon: Icon(Icons.email_sharp, color: Colors.black));
  } else {
    return InputDecoration(
        hintText: "Username",
        hintStyle: TextStyle(fontSize: 20),
        icon: Icon(Icons.question_mark, color: Colors.black));
  }
}
