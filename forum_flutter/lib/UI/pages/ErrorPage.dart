import 'package:flutter/material.dart';

import '../widgets/BackgroundWidget.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
            height: screenHeight,
            padding: const EdgeInsets.all(30),
            decoration: BackgroundWidget(),
            child: ListView(children: [
              Column(
              children: [
                //startWidget(),
                Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 100, horizontal: 100),
                      child: Text("Sembra che questa pagina non sia disponibile!", style: TextStyle(fontSize: 40)),
                )),
                MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/Forumics");
                  },
                  child: Text("Rientra in Forumics"),
                  color: Colors.blue[900],
                )
              ],
            )])));
  }
}
