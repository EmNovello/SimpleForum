import 'package:flutter/material.dart';
import 'package:forum_flutter/UI/widgets/BackgroundWidget.dart';

import '../../model/Model.dart';
import '../../model/objects/Post.dart';
import '../../model/objects/User.dart';
import 'FirstPage.dart';
import 'SecondPage.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User user = widget.user;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: isAdmin ? Text("Benvenuto admin") : Text("Homepage di " + user.username.toString()),
              backgroundColor: Colors.black,
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: MaterialButton(
                    child: Text("ELIMINA ACCOUNT", style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              scrollable: true,
                              content: SizedBox(
                                  height: 80,
                                  width: 400,
                                  child: ListView(children: [
                                    Column(children:[
                                      Center(child: Text("Sei sicuro di voler eliminare questo account?")),
                              Center(child: Text("Post e interventi verranno eliminati con l'account")),
                              Center(
                                child: MaterialButton(
                                  child: Text("Elimina", style: TextStyle(color: Colors.red)),
                                  onPressed: () async {
                                    if (await deleteUser(user.id))
                                      Navigator.pushReplacementNamed(context, "/Forumics");
                                  }),
                            ),
                          ])])));
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: IconButton(
                    onPressed: () async {
                      if (await logOut())
                        Navigator.pushReplacementNamed(context, "/Forumics");
                    },
                    icon: Icon(Icons.logout),
                    tooltip: "Esci",
                  ),
                ),
              ],
              bottom: TabBar(
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.blue, width: 10.0),
                ),
                tabs: [
                  Tab(text: "Post", icon: Icon(Icons.home_rounded)),
                  Tab(text: "Cerca", icon: Icon(Icons.search_rounded)),
                ],
              ),
            ),
            SliverFillRemaining(
              child: Container(
                decoration: BackgroundWidget(),
                child: TabBarView(
                  children: [
                    First(user),
                    SecondPage(user: user),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<Post>> First(User user) {
    return FutureBuilder(
      future: getPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: FirstPage(posts: snapshot.data as List<Post>, user: user),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}