import 'package:flutter/material.dart';

class PagingWidget extends StatelessWidget {
  final int pageNumber;
  final void Function() previousPage;
  final void Function() nextPage;

  const PagingWidget({Key? key, required this.pageNumber, required this.previousPage, required this.nextPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      if (pageNumber > 0)
        RawMaterialButton(
            onPressed: () => previousPage(),
            child: Icon(Icons.keyboard_arrow_left)),
      Text((pageNumber + 1).toString()),
      RawMaterialButton(
          onPressed: () => nextPage(), child: Icon(Icons.keyboard_arrow_right)),
    ]);
  }
}
