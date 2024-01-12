import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:forum_flutter/UI/widgets/PersonalSnackBarWidget.dart';
import 'package:forum_flutter/UI/widgets/TopsideWidget.dart';
import '../../model/Model.dart';
import '../../model/objects/Evaluation.dart';
import '../../model/objects/Post.dart';
import '../../model/objects/User.dart';
import '../../model/support/Creation_Deletation_Result.dart';
import '../pages/PostEvaluationPage.dart';

class PostsWidget extends StatefulWidget {
  final List<Post> posts;
  final User user;

  const PostsWidget({Key? key, required this.posts, required this.user}) : super(key: key);

  @override
  _PostsWidgetState createState() => _PostsWidgetState();
}

class _PostsWidgetState extends State<PostsWidget> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController tipologyController = TextEditingController();

  late List<Post> posts = widget.posts;
  late User user = widget.user;

  int pageNumber = 0;

  Creation_Deletation_Result? creationResult;
  Creation_Deletation_Result? deletationResult;

  void refresh() {
    getPosts().then((result) {
      setState(() {
        posts = result;
      });
    });
  }

  @override
  void didUpdateWidget(PostsWidget oldWidget) {//Cambiamento dinamico al cambiare di pagina
    if (widget.posts != oldWidget.posts) {
      setState(() {
        posts = widget.posts;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: TopsideWidget("Lista completa di post in ordine di commenti")),
              Padding(
                  padding: EdgeInsets.only(left: 170, right: 170),
                  child: MaterialButton(
                    color: const Color(0xff859398),
                    child: Text("Crea post"),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                scrollable: true,
                                title: Text("Crea post"),
                                content: SizedBox(
                                  height: 230,
                                  width: 250,
                                  child: ListView(children: [
                                    Column(
                                      children: <Widget>[
                                        TextFormField(
                                            controller: titleController,
                                            decoration: new InputDecoration(
                                                icon: Icon(Icons.title),
                                                labelText: "Titolo")),
                                        TextFormField(
                                            controller: descriptionController,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(400)],
                                            maxLines: null,
                                            decoration: InputDecoration(
                                                labelText: 'Valutazione (400 caratteri)',
                                                icon: Icon(Icons.description))),
                                        TextFormField(
                                            controller: tipologyController,
                                            decoration: InputDecoration(labelText: "Tipologia (Film, Libro, etc.)",
                                                icon: Icon(Icons.question_mark))),
                                        Padding(padding:EdgeInsets.only(top:30), child: MaterialButton(
                                            child: Text("Salva"),
                                            onPressed: () async {
                                              if (titleController.text == "" || descriptionController.text == "" || tipologyController.text == "") {
                                                final snackBar = PersonalSnackBarWidget("Riempire tutti i campi!", 0);
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              } else {
                                                Post p = Post(
                                                  title: titleController.text,
                                                  description: descriptionController.text,
                                                  typology: tipologyController.text,
                                                  creationTime: DateTime.now(),
                                                  user: widget.user,
                                                );
                                                var creationResult = await CreatePost(p);
                                                if (creationResult == Creation_Deletation_Result.already_created) {
                                                  Navigator.pop(context);
                                                  final snackBar = PersonalSnackBarWidget("Esiste già un post con questo titolo!", 0);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                } else {
                                                  refresh();
                                                  Navigator.pop(context);
                                                  final snackBar = PersonalSnackBarWidget("Post creato con successo", 1);
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                }
                                              }
                                            }),
                                        )],
                                    ),
                                  ]),
                                ));
                          });
                    },
                  )),
              MaterialButton(
                  color: const Color(0xff859398),
                  child: Text("Ricarica pagina"),
                  onPressed: () async {
                    Navigator.pushReplacementNamed(
                        context, "/Forumics/Homepage",
                        arguments: user);
                    final snackBar =
                        PersonalSnackBarWidget("Lista aggiornata", 1);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }),
            ],
          )),
      Divider(color: Colors.black),
      isAdmin
          ? Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              shadowColor: Colors.transparent,
              color: Color(0xff859398),
              child: Table(
                border: TableBorder.all(width: 1.5, color: Colors.black),
                columnWidths: {5: FlexColumnWidth(0.3)},
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    Center(child: Text("Titolo", style: TextStyle(fontSize: 20))),
                    Center(child: Text("Creatore", style: TextStyle(fontSize: 20))),
                    Center(child: Text("Commenti", style: TextStyle(fontSize: 20))),
                    Text(""),
                    Text(""),
                  ]),
                  for (var i = 0; i < posts.length; i++)
                    TableRow(children: [
                      Center(child: Text(posts[i].title)),
                      Center(child: Text(posts[i].user!.username.toString())),
                      Center(child: Text(posts[i].comments.toString())),
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
                                              refresh();
                                              final snackBar =
                                                  PersonalSnackBarWidget(
                                                      "Post eliminato", 1);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                              Navigator.pop(context);
                                            }),
                                      ]);
                                });
                          }),
                      MaterialButton(
                          child: Text("Vai ai commenti"),
                          color: const Color(0xff859398),
                          onPressed: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ShowEvaluations(
                                    posts[i].id, posts[i], user)));
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
                border: TableBorder.all(width: 1.5, color: Colors.black),
                columnWidths: {9: FlexColumnWidth(0.3)},
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    Text(""),
                    Text(""),
                    Center(child: Text("Titolo", style: TextStyle(fontSize: 20))),
                    Center(child: Text("Tipologia", style: TextStyle(fontSize: 20))),
                    Center(child: Text("Commenti", style: TextStyle(fontSize: 20))),
                    Center(child: Text("Creatore", style: TextStyle(fontSize: 20))),
                    Center(child: Text("Data", style: TextStyle(fontSize: 20))),
                    Text(""),
                    Text(""),
                  ]),
                  for (var i = 0; i < posts.length; i++)
                    TableRow(children: [
                      Icon(Icons.edit_document, color: Colors.black),
                      posts[i].comments! > 5
                          ? Icon(Icons.local_fire_department,
                              color: Colors.red[900])
                          : Icon(Icons.local_fire_department,
                              color: Colors.black),
                      Center(child: Text(posts[i].title)),
                      Center(child: Text(posts[i].typology ?? "")),
                      Center(child: Text(posts[i].comments.toString())),
                      Center(child: Text(posts[i].user!.username.toString())),
                      Center(child: Text(posts[i].toStringDate())),
                      MaterialButton(
                          child: Text("Commenta"),
                          color: const Color(0xff859398),
                          onPressed: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ShowEvaluations(
                                    posts[i].id, posts[i], user)));
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
                                                      posts[i].id, user.id);
                                              if (deletationResult ==
                                                  Creation_Deletation_Result
                                                      .error_unknown) {
                                                final snackBar =
                                                    PersonalSnackBarWidget(
                                                        "Solo il creatore del post può cancellarlo!",
                                                        0);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              } else {
                                                refresh();
                                                final snackBar =
                                                    PersonalSnackBarWidget(
                                                        "Post eliminato con successo",
                                                        1);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                                Navigator.pop(context);
                                              }
                                            }),
                                      ]);
                                });
                          }),
                    ])
                ],
              ))
    ]);
  }
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
