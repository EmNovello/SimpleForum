import 'package:flutter/material.dart';

import '../../model/Model.dart';
import '../../model/objects/User.dart';
import 'PersonalSnackBarWidget.dart';

class TableUserWidget extends StatefulWidget {
  final List<User> users;

  const TableUserWidget({Key? key, required this.users}) : super(key: key);

  @override
  _TableUserWidgetState createState() => _TableUserWidgetState();
}

class _TableUserWidgetState extends State<TableUserWidget> {
  late List<User> users = widget.users;

  @override
  Widget build(BuildContext context) {
    if (!isAdmin) {
      return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadowColor: Colors.transparent,
          color: Color(0xff859398),
          child: Container(
            width: 300,
            child: Table(
                border: TableBorder.all(width: 1.5, color: Colors.black),
                columnWidths: {2: FlexColumnWidth(0.3)},
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    Text(""),
                    Center(child: Text("Username")),
                  ]),
                  for (var i = 0; i < widget.users.length; i++)
                    TableRow(children: [
                      Icon(Icons.perm_identity_outlined, color: Colors.black),
                      Center(child: Text(widget.users[i].username ?? "")),
                    ]),
                ]),
          ));
    } else {
      return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadowColor: Colors.transparent,
          color: Color(0xff859398),
          child: Container(
            width: 300,
            child: Table(
              border: TableBorder.all(width: 1.5, color: Colors.black),
              columnWidths: {2: FlexColumnWidth(0.3)},
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    Center(child: Text("Username")),
                    Text(""),
                  ],
                ),
                for (var i = 0; i < widget.users.length; i++)
                  TableRow(
                    children: [
                      Center(child: Text(widget.users[i].username ?? "")),
                      MaterialButton(
                          child: Text("Espelli"),
                          onPressed: () async {
                            await deleteUser(users[i].id);
                            final snackBar = PersonalSnackBarWidget("Fatto", 1);
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }),
                    ],
                  ),
              ],
            ),
          ));
    }
  }
}
