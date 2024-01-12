import 'package:flutter/material.dart';

import '../../model/Model.dart';
import '../../model/objects/Evaluation.dart';
import '../../model/objects/Post.dart';
import '../../model/objects/User.dart';
import '../../model/support/Creation_Deletation_Result.dart';
import '../widgets/PagingWidget.dart';
import '../widgets/PersonalSnackBarWidget.dart';
import '../widgets/TableUserWidget.dart';
import 'PostEvaluationPage.dart';

class SecondPage extends StatefulWidget {
  final User? user;

  SecondPage({Key? key, required this.user}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  TextEditingController usernamePostController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController typologyController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  late User? user = widget.user;
  late List<Post> posts = [];
  late List<User> users = [];

  late int typesearch = 0;

  int pageNumber = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                        height: 45,
                        width: 250,
                        color: Colors.transparent,
                        child: TextField(
                          controller: usernamePostController,
                          onSubmitted: (value) {
                            getPostsByUsername(usernamePostController.text)
                                .then((result) {
                              setState(() {
                                posts = result;
                                users = [];
                                typesearch = 1;
                              });
                            });
                          },
                          decoration: InputDecoration(
                            labelText: "Trova post per creatore",
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: null,
                            ),
                          ),
                        )))),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                        height: 45,
                        width: 250,
                        color: Colors.transparent,
                        child: TextField(
                          controller: titleController,
                          onSubmitted: (value) {
                            getPostsByTitle(titleController.text)
                                .then((result) {
                              setState(() {
                                posts = result;
                                users = [];
                                typesearch = 2;
                              });
                            });
                          },
                          decoration: InputDecoration(
                            labelText:
                                "Trova post per titolo - (Vuoto per tutti)",
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: null,
                            ),
                          ),
                        )))),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                        height: 45,
                        width: 250,
                        color: Colors.transparent,
                        child: TextField(
                            controller: typologyController,
                            onSubmitted: (value) async {
                              getPostsByTypology(typologyController.text)
                                  .then((result) {
                                setState(() {
                                  posts = result;
                                  users = [];
                                  typesearch = 3;
                                });
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Trova post per tipologia",
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: null,
                              ),
                            ))))),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                      height: 45,
                      width: 250,
                      color: Colors.transparent,
                      child: TextField(
                        controller: usernameController,
                        onSubmitted: (value) async {
                          getUsersByUsername(usernameController.text)
                              .then((result) {
                            setState(() {
                              users = result;
                              posts = [];
                              typesearch = 4;
                            });
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Trova utenti - (Vuoto per tutti)",
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: null,
                          ),
                        ),
                      ))),
            )
          ]),
          posts.length == 0
              ? Text("")
              : isAdmin
                  ? Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      shadowColor: Colors.transparent,
                      color: Color(0xff859398),
                      child: Table(
                        border:
                            TableBorder.all(width: 1.5, color: Colors.black),
                        columnWidths: {4: FlexColumnWidth(0.3)},
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(children: [
                            Center(
                                child: Text("Titolo",
                                    style: TextStyle(fontSize: 20))),
                            Center(
                                child: Text("Creatore",
                                    style: TextStyle(fontSize: 20))),
                            Text(""),
                            Text("")
                          ]),
                          for (var i = 0; i < posts.length; i++)
                            TableRow(children: [
                              Center(child: Text(posts[i].title)),
                              Center(
                                  child:
                                      Text(posts[i].user!.username.toString())),
                              MaterialButton(
                                child: Text("Elimina"),
                                color: const Color(0xff859398),
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          scrollable: true,
                                          title: Text(
                                              "Sei sicuro di voler cancellare questo post?"),
                                          actions: [
                                            MaterialButton(
                                                child: Text("Cancella"),
                                                onPressed: () async {
                                                  await DeletePost(posts[i].id,
                                                      posts[i].user!.id);
                                                  getPosts().then((result) {
                                                    setState(() {
                                                      posts = result;
                                                    });
                                                  });
                                                  final snackBar =
                                                      PersonalSnackBarWidget(
                                                          "Post eliminato", 1);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                  Navigator.pop(context);
                                                }),
                                          ],
                                        );
                                      });
                                },
                              ),
                              MaterialButton(
                                  child: Text("Vai ai commenti"),
                                  color: const Color(0xff859398),
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ShowEvaluations(posts[i].id,
                                                    posts[i], user!)));
                                  }),
                            ])
                        ],
                      ),
                    )
                  : Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      shadowColor: Colors.transparent,
                      color: Color(0xff859398),
                      child: Table(
                        border:
                            TableBorder.all(width: 1.5, color: Colors.black),
                        columnWidths: {9: FlexColumnWidth(0.3)},
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(children: [
                            Text(""),
                            Text(""),
                            Center(
                                child: Text("Titolo",
                                    style: TextStyle(fontSize: 20))),
                            Center(
                                child: Text("Tipologia",
                                    style: TextStyle(fontSize: 20))),
                            Center(
                                child: Text("Commenti",
                                    style: TextStyle(fontSize: 20))),
                            Center(
                                child: Text("Creatore",
                                    style: TextStyle(fontSize: 20))),
                            Center(
                                child: Text("Data",
                                    style: TextStyle(fontSize: 20))),
                            Text(""),
                            Text(""),
                          ]),
                          for (var i = 0; i < posts.length; i++)
                            TableRow(children: [
                              Icon(Icons.edit_document, color: Colors.black),
                              if (posts[i].comments! > 5)
                                Icon(Icons.local_fire_department,
                                    color: Colors.red[900])
                              else
                                Icon(Icons.local_fire_department,
                                    color: Colors.black),
                              Center(child: Text(posts[i].title)),
                              Center(child: Text(posts[i].typology ?? "")),
                              Center(child: Text(posts[i].comments.toString())),
                              Center(
                                  child:
                                      Text(posts[i].user!.username.toString())),
                              Center(child: Text(posts[i].toStringDate())),
                              MaterialButton(
                                  child: Text("Commenta"),
                                  color: const Color(0xff859398),
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ShowEvaluations(posts[i].id,
                                                    posts[i], user!)));
                                  }),
                              MaterialButton(
                                child: Text("Elimina"),
                                color: const Color(0xff859398),
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          scrollable: true,
                                          title: Text(
                                              "Sei sicuro di voler cancellare questo post?"),
                                          actions: [
                                            MaterialButton(
                                                child: Text("Cancella"),
                                                onPressed: () async {
                                                  var deletationResult =
                                                      await DeletePost(
                                                          posts[i].id,
                                                          user!.id);
                                                  if (deletationResult ==
                                                      Creation_Deletation_Result
                                                          .error_unknown) {
                                                    final snackBar =
                                                        PersonalSnackBarWidget(
                                                            "Solo il creatore del post può cancellarlo!",
                                                            0);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  } else {
                                                    getPosts().then((result) {
                                                      setState(() {
                                                        posts = result;
                                                      });
                                                    });
                                                    final snackBar =
                                                        PersonalSnackBarWidget(
                                                            "Post eliminato con successo",
                                                            1);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                    Navigator.pop(context);
                                                  }
                                                }),
                                          ],
                                        );
                                      });
                                },
                              ),
                            ])
                        ],
                      ),
                    ),
          users.length == 0 ? Text("") : TableUserWidget(users: users),
          PagingWidget(
              pageNumber: pageNumber,
              previousPage: () async {
                switch (typesearch) {
                  case 0:
                    setState(() {
                      this.posts = posts;
                      pageNumber--;
                    });
                    break;
                  case 1:
                    var posts = await getPostsByUsername(
                        usernamePostController.text, pageNumber - 1);
                    setState(() {
                      this.posts = posts;
                      this.users = [];
                      pageNumber--;
                    });
                    break;
                  case 2:
                    var posts = await getPostsByTitle(
                        titleController.text, pageNumber - 1);
                    setState(() {
                      this.posts = posts;
                      this.users = [];
                      pageNumber--;
                    });
                    break;
                  case 3:
                    var posts = await getPostsByTypology(
                        typologyController.text, pageNumber - 1);
                    setState(() {
                      this.posts = posts;
                      this.users = [];
                      pageNumber--;
                    });
                    break;
                  case 4:
                    var users = await getUsersByUsername(
                        usernameController.text, pageNumber - 1);
                    setState(() {
                      this.users = users;
                      this.posts = [];
                      pageNumber--;
                    });
                    break;
                }
              },
              nextPage: () async {
                switch (typesearch) {
                  case 0:
                    setState(() {
                      this.posts = posts;
                      pageNumber--;
                    });
                    break;
                  case 1:
                    var posts = await getPostsByUsername(
                        usernamePostController.text, pageNumber + 1);
                    setState(() {
                      this.posts = posts;
                      this.users = [];
                      pageNumber++;
                    });
                    break;
                  case 2:
                    var posts = await getPostsByTitle(
                        titleController.text, pageNumber + 1);
                    setState(() {
                      this.posts = posts;
                      this.users = [];
                      pageNumber++;
                    });
                    break;
                  case 3:
                    var posts = await getPostsByTypology(
                        typologyController.text, pageNumber + 1);
                    setState(() {
                      this.posts = posts;
                      this.users = [];
                      pageNumber++;
                    });
                    break;
                  case 4:
                    var users = await getUsersByUsername(
                        usernameController.text, pageNumber + 1);
                    setState(() {
                      this.users = users;
                      this.posts = [];
                      pageNumber++;
                    });
                    break;
                }
              })
        ],
      )
    ]);
  }

  FutureBuilder<List<Evaluation>> ShowEvaluations(
      int? postId, Post post, User user) {
    return FutureBuilder(
        future: getPostEvaluations(postId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
                child: PostEvaluationPage(
                    evaluations: snapshot.data as List<Evaluation>,
                    post: post,
                    user: user));
          } else
            return CircularProgressIndicator();
        });
  }
}
