import 'package:flutter/material.dart';

import 'package:forum_flutter/UI/widgets/StartWidget.dart';
import '../widgets/BackgroundWidget.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(30),
            decoration: BackgroundWidget(),
            child: Center(
                child: ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          startWidget(),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
                              child: ElevatedButton(
                                child: Text("Entra in Forumics"),
                                onPressed: () {
                                  Navigator.pushNamed(context, "/Forumics/Login");
                                },
                              )),
                        ],
                      ),
                    ]))));
  }
}
