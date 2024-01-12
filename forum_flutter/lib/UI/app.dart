import 'package:flutter/material.dart';

import 'package:forum_flutter/model/support/Constants.dart';
import 'package:forum_flutter/model/support/RouteGenerator.dart';

//Widget root

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: "/Forumics");
  }
}
