import 'package:flutter/material.dart';

Widget selectorWidget(PageController pageController, String label, int pag) {
  pageController = pageController;
  label = label;
  pag = pag;

  return Expanded(
      child: TextButton(
          onPressed: () {
            pageController.animateToPage(pag,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear);
          },
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 20,
            ),
          )));
}
