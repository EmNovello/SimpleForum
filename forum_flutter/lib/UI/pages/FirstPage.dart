import 'package:flutter/material.dart';

import 'package:forum_flutter/model/objects/User.dart';
import '../../model/Model.dart';
import '../../model/objects/Post.dart';
import '../widgets/PagingWidget.dart';
import '../widgets/PostsWidget.dart';

class FirstPage extends StatefulWidget {
  final User user;
  final List<Post> posts;

  const FirstPage({Key? key, required this.posts, required this.user}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  late List<Post> posts = widget.posts;
  late User user = widget.user;

  int pageNumber = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(children:[Column(
      children: [
        PostsWidget(posts: posts, user: user),
        Container(
          child: PagingWidget(
            pageNumber: pageNumber,
            previousPage: () async {
              var posts = await getPosts(pageNumber - 1);
              setState(() {
                this.posts = posts;
                pageNumber--;
              });
            },
            nextPage: () async {
              var posts = await getPosts(pageNumber + 1);
              setState(() {
                this.posts = posts;
                pageNumber++;
              });
            },
          ),
        ),
      ],
    )]);
  }
}
