import 'package:flutter/material.dart';

Widget TopsideWidget(String mex) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              mex,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: RichText(
              text: TextSpan(
                text: "I post con molte risposte sono contrassegnati come ",
                style: TextStyle(fontSize: 20),
                children: <TextSpan>[
                  TextSpan(
                    text: "roventi!",
                    style: TextStyle(
                      color: Colors.red[900],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}
