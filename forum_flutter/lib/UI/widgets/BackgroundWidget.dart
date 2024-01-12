import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

BoxDecoration BackgroundWidget() {
  return const BoxDecoration(
      gradient: LinearGradient(
        colors: <Color>[
          Color(0xff283048),
          Color(0xff859398),
        ],
        begin: FractionalOffset(1.0, 1.0),
        end: FractionalOffset(1.0, 0.0),
  ));
}
