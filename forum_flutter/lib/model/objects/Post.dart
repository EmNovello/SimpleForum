import 'package:intl/intl.dart';

import 'User.dart';

typedef Json = Map<String, dynamic>;

class Post {
  int? id;
  String title;
  String? description;
  String? typology;
  DateTime? creationTime;
  int? comments;
  User? user;

  Post({
    this.id,
    required this.title,
    this.description,
    this.typology,
    this.creationTime,
    this.comments,
    this.user,
    //this.evaluations
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      creationTime: DateTime(json['creationTime'][0], json['creationTime'][1],
          json['creationTime'][2]),
      typology: json["typology"],
      comments: json['comments'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        "typology": typology,
        'comments': comments,
        'user': user,
        'creationTime': [
          creationTime?.year,
          creationTime?.month,
          creationTime?.day
        ],
      };

  @override
  String toStringDate() {
    DateFormat format = DateFormat("dd-MM-yyyy");
    String formattedDate = format.format(creationTime!);
    return '$formattedDate';
  }

  @override
  String toString() {
    return title;
  }
}