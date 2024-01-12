typedef Json = Map<String, dynamic>;

class User {
  int? id;
  String username;
  String? email;
  String? password;

  User({this.id, required this.username, this.email, this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
    );
  }

  Json toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'password': password,
      };

  @override
  String toString() {
    return username;
  }
}