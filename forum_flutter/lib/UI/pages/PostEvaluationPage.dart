import 'package:flutter/material.dart';
import 'package:forum_flutter/UI/widgets/BackgroundWidget.dart';

import 'package:forum_flutter/model/Model.dart';
import '../../model/objects/Evaluation.dart';
import '../../model/objects/Post.dart';
import '../../model/objects/User.dart';
import '../widgets/PagingWidget.dart';
import '../widgets/EvaluationWidget.dart';

class PostEvaluationPage extends StatefulWidget {
  final List<Evaluation> evaluations;
  final Post post;
  final User user;

  const PostEvaluationPage(
      {Key? key,
      required this.evaluations,
      required this.post,
      required this.user})
      : super(key: key);

  @override
  _PostEvaluationPageState createState() => _PostEvaluationPageState();
}

class _PostEvaluationPageState extends State<PostEvaluationPage> {
  late List<Evaluation> evaluations = widget.evaluations;
  late Post post = widget.post;
  late User user = widget.user;

  int pageNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
            automaticallyImplyLeading: false,
            title: Text("Valutazioni di " + "'" + widget.post.toString() + "'"),
            backgroundColor: Colors.black),
        SliverFillRemaining(
            child: Container(
                decoration: BackgroundWidget(),
                child: ListView(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      EvaluationWidget(evaluations: evaluations, post: post, user: user, pageNumber: pageNumber),
                      PagingWidget(
                          pageNumber: pageNumber,
                          previousPage: () async {
                            var evaluations = await getPostEvaluations(post.id, pageNumber - 1);
                            setState(() {
                              this.evaluations = evaluations;
                              pageNumber--;
                            });
                          },
                          nextPage: () async {
                            print(this.evaluations);
                            var evaluations = await getPostEvaluations(post.id, pageNumber + 1);
                            setState(() {
                              this.evaluations = evaluations;
                              pageNumber++;
                            });
                          })
                    ],
                  )
                ])))
      ],
    ));
  }
}
