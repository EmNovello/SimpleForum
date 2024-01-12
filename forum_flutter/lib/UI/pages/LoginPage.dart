import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forum_flutter/UI/widgets/PersonalInputDecoration.dart';
import 'package:forum_flutter/model/Model.dart';
import 'package:forum_flutter/model/support/LoginResult.dart';
import '../widgets/PersonalSnackBarWidget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LogInResult? logInResult;

  bool _obscureText = true; //Password

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        shadowColor: Colors.transparent,
        color: Color(0xff859398),
        margin: EdgeInsets.only(left: 100.0, right: 100.0, bottom: 40, top: 10),
        child: Container(
            width: 300,
            child: Column(children: [
              Expanded(
                  child: Padding(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 5, vertical: 0),
                      child: TextField(
                          controller: emailController,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          decoration: PersonalInputDecoration("Email")))),
              Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 5, vertical: 0),
                  child: TextField(
                      controller: passwordController,
                      obscureText: _obscureText,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: const TextStyle(fontSize: 20),
                          icon: const Icon(FontAwesomeIcons.userLock, color: Colors.black),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                  _obscureText
                                      ? FontAwesomeIcons.eyeSlash
                                      : FontAwesomeIcons.eye,
                                  color: Colors.blueGrey))))),
              Padding(padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.black)),
                      child: Text("Accedi", style: TextStyle(fontSize: 30, color: Colors.blue[800])),
                      onPressed: () async {
                        if (emailController.text == "" || passwordController.text == "") {
                          final snackBar = PersonalSnackBarWidget("Riempire tutti i campi", 0);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          var loginResult = await logIn(emailController.text, passwordController.text);
                          if (loginResult == LogInResult.logged ||
                              loginResult == LogInResult.logged_admin) {
                            var loggedUser = await findUser(emailController.text);
                            Navigator.pushNamed(context, "/Forumics/Homepage", arguments: loggedUser);
                          } else {
                            final snackBar = PersonalSnackBarWidget("Credenziali errate o utente inesistente", 0);
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        }
                      })),
            ])));
  }
}
