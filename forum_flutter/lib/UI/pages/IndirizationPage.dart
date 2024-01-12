import 'package:flutter/material.dart';

import 'package:forum_flutter/UI/pages/RegistrationPage.dart';
import 'package:forum_flutter/UI/widgets/BackgroundWidget.dart';
import 'package:forum_flutter/UI/widgets/ImageForumWidget.dart';
import 'package:forum_flutter/UI/widgets/SelectorWidget.dart';
import 'LoginPage.dart';

class IndirizationPage extends StatefulWidget {
  @override
  _IndirizationPageState createState() => _IndirizationPageState();
}

class _IndirizationPageState extends State<IndirizationPage> {
  late PageController _pageController; //Per cambiare pagina in pageView

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true, //Il body si mette sotto l'appbar per fare tinta unita
        appBar: AppBar(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
        body: Container(

            decoration: BackgroundWidget(),
            child:ListView(
                children: [
                  Column(
                    children: [
                      ImageForumWidget(),
                      Container(
                          width: 300,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(Radius.elliptical(10, 10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              selectorWidget(_pageController, "Accedi", 0),
                              selectorWidget(_pageController, "Registrati", 1),
                            ],
                          )),
                      SizedBox(
                        width: 1350,
                        height: 230,
                        child: PageView(
                          controller: _pageController,
                          children: [
                            LoginPage(), //Pag. 0
                            RegistrationPage(), //Pag. 1
                          ],
                        ),
                      )],
                  ),
                ])));
  }
}
