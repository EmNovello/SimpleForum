import 'package:flutter/material.dart';

import 'package:email_validator/email_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forum_flutter/UI/widgets/PersonalInputDecoration.dart';
import 'package:forum_flutter/UI/widgets/PersonalSnackBarWidget.dart';
import '../../model/Model.dart';
import '../../model/objects/User.dart';
import '../../model/support/LoginResult.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  bool InCreation = false;
  bool _obscureText = true; //Password

  User? loggedUser;
  LogInResult? logInResult;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      shadowColor: Colors.transparent,
      color: const Color(0xff859398),
      margin: EdgeInsets.only(left: 100.0, right: 100.0, bottom: 5, top: 10),
      child: Container(
          width: 300,
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 5, vertical: 0),
                      child: TextField(
                          controller: usernameController,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          decoration: PersonalInputDecoration("Username")))),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 5, vertical: 0),
                      child: TextField(
                        controller: emailController,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        decoration: PersonalInputDecoration("Email"),
                      ))),
              Padding(
                  padding:  EdgeInsetsDirectional.symmetric(horizontal: 5, vertical: 0),
                  child: TextField(
                      controller: passwordController,
                      obscureText: _obscureText,
                      style: const TextStyle(fontSize: 20, color: Colors.black),
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
                              _obscureText ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                              color: Colors.blueGrey,
                            ),
                          )))),
              Padding(
                  padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
                  child: ElevatedButton(
                    child: Text("Registrati", style: TextStyle(fontSize: 30, color: Colors.blue[800])),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.black)),
                    onPressed: () async {
                      if (emailController.text == "" || passwordController.text == "" || usernameController.text == "") {
                        final snackBar = PersonalSnackBarWidget("Riempire tutti i campi", 0);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (!EmailValidator.validate(emailController.text)) {
                        final snackBar = PersonalSnackBarWidget("Inserire una email valida", 0);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        setState(() {
                          InCreation = true;
                        });
                        var logInResult = await addUser(User(
                            username: usernameController.text,
                            password: passwordController.text,
                            email: emailController.text));
                        setState(() {
                          InCreation = false;
                        });
                        switch (logInResult) {
                          case LogInResult.username_exists:
                            final snackBar = PersonalSnackBarWidget("Username già in uso, prova con un altro", 0);
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            break;
                          case LogInResult.email_exists:
                            final snackBar = PersonalSnackBarWidget("Email già in uso, prova con un'altra", 0);
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            break;
                          default:
                            final snackBar = PersonalSnackBarWidget("Profilo creato! Puoi procedere al Login", 1);
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    },
                  )),
              Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: InCreation ? CircularProgressIndicator() : SizedBox.shrink()),
              ),
            ],
          )),
    );
  }
}