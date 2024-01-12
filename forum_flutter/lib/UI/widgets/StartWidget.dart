import 'package:flutter/material.dart';

import 'package:forum_flutter/UI/widgets/ImageForumWidget.dart';
import 'AppNameWidget.dart';

Widget startWidget() {
  return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppNameWidget(),
          Text(
            "Cerca e crea feedback su ciò che ti serve e piace",
            style: TextStyle(fontSize: 20),
          ),
          ImageForumWidget(),
          Text(
            "Alla portata di un click",
            style: TextStyle(fontSize: 20),
          ),
        ],
  );
}

