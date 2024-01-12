import 'package:flutter/material.dart';

import '../../model/support/Constants.dart';

Widget AppNameWidget() {
  return Padding(
    padding: EdgeInsets.only(top: 1),
    child: Text(appName,
        style: TextStyle(
          letterSpacing: 5,
          color: Colors.black,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.underline,
          fontSize: 50,
        )),
  );
}
