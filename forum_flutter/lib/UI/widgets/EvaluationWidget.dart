import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:forum_flutter/UI/widgets/PersonalSnackBarWidget.dart';
import '../../model/Model.dart';
import '../../model/objects/Evaluation.dart';
import '../../model/objects/Post.dart';
import '../../model/objects/User.dart';
import '../../model/support/Creation_Deletation_Result.dart';

class EvaluationWidget extends StatefulWidget {
  final List<Evaluation> evaluations;
  final Post post;
  final User user;
  final int pageNumber;

  const EvaluationWidget(
      {Key? key,
      required this.evaluations,
      required this.post,
      required this.user,
      required this.pageNumber})
      : super(key: key);

  @override
  _EvaluationWidgetState createState() => _EvaluationWidgetState();
}

class _EvaluationWidgetState extends State<EvaluationWidget> {
  TextEditingController quoteController = TextEditingController();
  TextEditingController evaluationController = TextEditingController();

  late User user = widget.user;
  late List<Evaluation> evaluations = widget.evaluations;
  late Post post = widget.post;

  late int pageNumber = widget.pageNumber;

  bool wrong_quote = false;
  bool already_one = false;

  Creation_Deletation_Result? creationResult;
  Creation_Deletation_Result? deletationResult;

  /*@override
  void didUpdateWidget(EvaluationWidget oldWidget) {// Cambiamento dinamico al cambiare di pagina o di evaluations
      setState(() {
        evaluations = widget.evaluations;
      });
    super.didUpdateWidget(oldWidget);
  }*/

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: EdgeInsets.only(left: 7, top: 5),
          child: Text(post.user!.username.toString() + " ha scritto:",
              style: TextStyle(fontSize: 20))),
      Padding(
          padding: EdgeInsets.only(left: 7, top: 5),
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2)),
              shadowColor: Colors.transparent,
              color: Colors.grey,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(post.description.toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black, fontSize: 20)),
              ))),
      Divider(color: Colors.black),
      Padding(
        padding: EdgeInsets.only(left: 7, top: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text("Valutazioni date", style: TextStyle(fontSize: 20)),
          MaterialButton(
            color: const Color(0xff859398),
            child: Text("Commenta"),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        scrollable: true,
                        title: Text("Crea valutazione"),
                        content: SizedBox(
                            height: 150,
                            width: 150,
                            child: ListView(children: [
                              Column(children: <Widget>[
                                TextFormField(
                                    controller: quoteController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.onetwothree),
                                        labelText: "Valutazione (Da 1 a 5)")),
                                TextFormField(
                                    controller: evaluationController,
                                    maxLines: null,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(100),
                                    ],
                                    decoration: InputDecoration(
                                        labelText: 'Massimo 100 caratteri',
                                        icon: Icon(Icons.chat_bubble))),
                                Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: MaterialButton(
                                        child: Text("Salva"),
                                        onPressed: () async {
                                          if (quoteController.text == "") {
                                            final snackBar = PersonalSnackBarWidget("Valutazione numerica obbligatoria!", 0);
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                          } else {
                                            int q = int.parse(quoteController.text);
                                            DateTime now = new DateTime.now();
                                            DateTime date = new DateTime(now.year, now.month, now.day);
                                            Evaluation ev = Evaluation(
                                              quote: q,
                                              shortEvaluation: evaluationController.text,
                                              user: widget.user,
                                              post: widget.post,
                                              evaluationTime: date,
                                            );
                                            var creationResult = await CreateEvaluation(ev);
                                            switch (creationResult) {
                                              case Creation_Deletation_Result.error_wrong_quote:
                                                final snackBar = PersonalSnackBarWidget("Inserisci un valore tra 1 e 5!", 0);
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                break;
                                              case Creation_Deletation_Result.already_created:
                                                Navigator.pop(context);
                                                final snackBar = PersonalSnackBarWidget("Hai già commentato questo post! Elimina il precedente commento", 0);
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                break;
                                              default:
                                                Navigator.pushNamed(context, "/Forumics/Homepage", arguments: user);
                                                final snackBar = PersonalSnackBarWidget("Post commentato", 1);
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            }
                                          }
                                        }))
                              ])
                            ])));
                  });
            },
          ),
          MaterialButton(
            color: const Color(0xff859398),
            child: Text("Elimina valutazione"),
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        content: SizedBox(
                            height: 80,
                            width: 350,
                            child: ListView(children: [
                              Column(children: <Widget>[
                                Text("Sei sicuro di voler cancellare la valutazione?"),
                                Padding(padding: EdgeInsets.only(top: 20),
                                  child: MaterialButton(
                                    child: Text("Cancella"),
                                    onPressed: () async {
                                      var deletationResult = await DeleteEvaluation(post.id, widget.user.id);
                                      if (deletationResult == Creation_Deletation_Result.no_evaluation_yet ||
                                          deletationResult == Creation_Deletation_Result.error_unknown) {
                                        Navigator.pop(context);
                                        final snackBar = PersonalSnackBarWidget("Non hai ancora commentato questo post!", 0);
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      } else {
                                        Navigator.pushNamed(context, "/Forumics/Homepage", arguments: user);
                                        final snackBar = PersonalSnackBarWidget("Valutazione cancellata", 1);
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }
                                    },
                                  ),
                                )
                              ])
                            ])));
                  });
            },
          ),
          MaterialButton(
              color: const Color(0xff859398),
              child: (Text("Indietro")),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/Forumics/Homepage",
                    arguments: user);
              }),
        ]),
      ),
      Divider(color: Colors.black),
      widget.evaluations.isNotEmpty
          ? isAdmin
              ? Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  shadowColor: Colors.transparent,
                  color: Color(0xff859398),
                  child: Table(
                    border: TableBorder.all(width: 1.0, color: Colors.black),
                    columnWidths: {3: FlexColumnWidth(0.2)},
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        Center(
                            child: Text("Commento",
                                style: TextStyle(fontSize: 20))),
                        Center(
                            child: Text("Commentatore",
                                style: TextStyle(fontSize: 20))),
                        Center(child: Text("")),
                      ]),
                      for (var i = 0; i < widget.evaluations.length; i++)
                        TableRow(children: [
                          Center(
                              child: Text(widget.evaluations[i].shortEvaluation
                                  .toString())),
                          Center(
                              child: Text(
                                  evaluations[i].user!.username.toString())),
                          MaterialButton(
                              child: Text("Cancella"),
                              onPressed: () async {
                                await DeleteEvaluation(
                                    post.id, evaluations[i].user!.id);
                                Navigator.pushNamed(
                                    context, "/Forumics/Homepage",
                                    arguments: user);
                                final snackBar = PersonalSnackBarWidget(
                                    "Valutazione cancellata", 1);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }),
                        ])
                    ],
                  ))
              : Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  shadowColor: Colors.transparent,
                  color: Color(0xff859398),
                  child: Table(
                    border: TableBorder.all(width: 1.0, color: Colors.black),
                    columnWidths: {5: FlexColumnWidth(0.2)},
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        Text(""),
                        Center(
                            child: Text("Valutazione",
                                style: TextStyle(fontSize: 20))),
                        Center(
                            child: Text("Commento",
                                style: TextStyle(fontSize: 20))),
                        Center(
                            child:
                                Text("Data", style: TextStyle(fontSize: 20))),
                        Center(
                            child: Text("Commentatore",
                                style: TextStyle(fontSize: 20))),
                      ]),
                      for (var i = 0; i < widget.evaluations.length; i++)
                        TableRow(children: [
                          Icon(Icons.chat, color: Colors.black),
                          Center(
                              child:
                                  Text(widget.evaluations[i].quote.toString())),
                          Center(
                              child: Text(widget.evaluations[i].shortEvaluation
                                  .toString())),
                          Center(
                              child:
                                  Text(widget.evaluations[i].toStringDate())),
                          Center(
                              child: Text(
                                  evaluations[i].user!.username.toString())),
                        ])
                    ],
                  ))
          : Center(
              child: Text("Non ci sono ancora valutazioni per questo post",
                  style: TextStyle(fontSize: 40))),
    ]);
  }
}
