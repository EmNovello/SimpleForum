import 'package:intl/intl.dart';

import 'Post.dart';
import 'User.dart';

typedef Json = Map<String, dynamic>;

class Evaluation {
  int? id;
  int? quote;
  String? shortEvaluation;
  DateTime? evaluationTime;
  User? user;
  Post? post;

  Evaluation(
      {this.id,
      this.quote,
      this.shortEvaluation,
      this.evaluationTime,
      this.user,
      this.post});

  factory Evaluation.fromJson(Map<String, dynamic> json) {
    return Evaluation(
      id: json['id'],
      quote: json["quote"],
      shortEvaluation: json['shortEvaluation'],
      evaluationTime: DateTime(json['evaluationTime'][0],
          json['evaluationTime'][1], json['evaluationTime'][2]),
      user: User.fromJson(json["user"]),
      post: Post.fromJson(json["post"]),
    );
  }

  Json toJson() => {
        'id': id,
        'quote': quote,
        'shortEvaluation': shortEvaluation,
        "user": user,
        "post": post,
        'evaluationTime': [
          evaluationTime?.year,
          evaluationTime?.month,
          evaluationTime?.day
        ],
      };

  @override
  String toStringDate() {
    DateFormat format = DateFormat("dd-MM-yyyy");
    String formattedDate = format.format(evaluationTime!);
    return '$formattedDate';
  }
}