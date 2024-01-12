import 'package:flutter/material.dart';
import 'package:forum_flutter/UI/pages/HomePage.dart';
import 'package:forum_flutter/UI/pages/IndirizationPage.dart';

import '../../UI/pages/ErrorPage.dart';
import '../../UI/pages/StartPage.dart';
import '../objects/User.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments; //E' un Object
    switch (settings.name) {
      case "/Forumics":
        return MaterialPageRoute(builder: (context) => StartPage());
      case "/Forumics/Login":
        return MaterialPageRoute(builder: (context) => IndirizationPage());
      case "/Forumics/Homepage":
        if (args is User) {
          return MaterialPageRoute(builder: (context) => HomePage(user: args));
        }
        return MaterialPageRoute(builder: (context) => ErrorPage());
      default:
        return MaterialPageRoute(builder: (context) => ErrorPage());
    }
  }
}