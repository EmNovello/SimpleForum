import 'dart:async';
import 'dart:convert';
import 'package:forum_flutter/model/objects/Evaluation.dart';
import 'package:forum_flutter/model/support/Constants.dart';
import 'package:forum_flutter/model/RestManager.dart';
import 'package:forum_flutter/model/support/Creation_Deletation_Result.dart';
import 'package:forum_flutter/model/support/LoginResult.dart';
import 'package:forum_flutter/model/objects/AuthenticationData.dart';
import 'package:forum_flutter/model/objects/User.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'objects/Post.dart';

// Le operazioni asincrone si completano mentre ne sono in corso altre (Es.Recupero di dati su una rete)
// Forniscono il risultato come Future <T>
// Si usano "async" (Funzione) e "await" (Solo in funzioni async per avere Future<T>)

User? thisUser;
bool isAdmin = false;
bool isLogged = false;

late AuthenticationData _authenticationData;
RestManager restManager = RestManager();

Future<LogInResult> logIn(String email, String password) async {
  try {
    Map<String, String> params = Map();
    params["grant_type"] = "password";
    params["client_id"] = clientId;
    params["client_secret"] = clientSecret;
    params["username"] = email;
    params["password"] = password;
    String result = await restManager.makePostRequest(
        authenticationServerUrl, loginRequest, params,
        type: TypeHeader.urlencoded);

    _authenticationData = AuthenticationData.fromJson(jsonDecode(result));

    if (_authenticationData.hasError()) {
      if (_authenticationData.error == "Invalid user credentials") {
        return LogInResult.error_unknown;
      }
    }
    isLogged = true;
    restManager.token = _authenticationData.accessToken;
    isAdmin = Jwt.parseJwt(restManager.token!)["realm_access"]["roles"]
        .contains("admin_role");
    Timer.periodic(Duration(seconds: (_authenticationData.expiresIn - 50)),
            (Timer t) {
          _refreshToken();
        });
    return isAdmin ? LogInResult.logged_admin : LogInResult.logged;
  } catch (e) {
    return LogInResult.error_unknown;
  }
}

Future<bool> _refreshToken() async {
  try {
    Map<String, String> params = Map();
    params["grant_type"] = "refresh_token";
    params["client_id"] = clientId;
    params["client_secret"] = clientSecret;
    params["refresh_token"] = _authenticationData.refreshToken;
    String result = await restManager.makePostRequest(
        authenticationServerUrl, loginRequest, params,
        type: TypeHeader.urlencoded);
    _authenticationData = AuthenticationData.fromJson(jsonDecode(result));
    if (_authenticationData.hasError()) {
      return false;
    }
    restManager.token = _authenticationData.accessToken;
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> logOut() async {
  try {
    Map<String, String> params = Map();
    restManager.token;
    params["client_id"] = clientId;
    params["client_secret"] = clientSecret;
    params["refresh_token"] = _authenticationData.refreshToken;
    await restManager.makePostRequest(
        authenticationServerUrl, logoutRequest, params,
        type: TypeHeader.urlencoded);
    thisUser = null;
    isAdmin = false;
    isLogged = false;
    return true;
  } catch (e) {
    return false;
  }
}

///METODI PER USER

Future<LogInResult> addUser(User user) async {
  try {
    String rawResult = await restManager.makePostRequest(
        serverBaseUrl, "/user/register", user);
    if (rawResult.contains("ERROR:email_already_exists")) {
      return LogInResult.email_exists;
    } else if (rawResult.contains("ERROR:username_already_taken")) {
      return LogInResult.username_exists;
    } else {
      return LogInResult.created;
    }
  } catch (e) {
    return LogInResult.error_unknown;
  }
}

Future<bool> deleteUser(int? userId) async {
  var params = {};
  try {
    String rawResult = await restManager.makePostRequest(
        serverBaseUrl, "/user/delete/$userId", params);
    if (rawResult.contains("SUCCESS")) return true;
    return false;
  } catch (e) {
    return false;
  }
}

Future<List<User>> getUsers([int pageNumber = 0]) async {
  var params = {'pageNumber': pageNumber.toString()};
  try {
    var response = await restManager.makeGetRequest(
        serverBaseUrl, '/search/users', params);
    var decodedResponse = jsonDecode(response);
    return List<User>.from(
        decodedResponse.map((i) => User.fromJson(i)).toList());
  } catch (e, s) {
    print(e);
    print(s);
    return [];
  }
}

Future<User> findUser(String email) async {
  var params = {'email': email};
  try {
    String rawResult =
    await restManager.makeGetRequest(serverBaseUrl, "/search/user", params);
    if (rawResult.contains("ERROR:User_not_found")) {
      return Future.error('User not found');
    } else {
      return User.fromJson(jsonDecode(rawResult));
    }
  } catch (e) {
    return Future.error('User not found');
  }
}

Future<List<User>> getUsersByUsername(String username, [int pageNumber = 0]) async {
  var params = {"username": username, 'pageNumber': pageNumber.toString()};
  try {
    var response = await restManager.makeGetRequest(
        serverBaseUrl, 'search/user/username', params);
    var decodedResponse = jsonDecode(response);
    return List<User>.from(
        decodedResponse.map((i) => User.fromJson(i)).toList());
  } catch (e, s) {
    print(e);
    print(s);
    return [];
  }
}

///METODI PER POST

Future<Creation_Deletation_Result> CreatePost(Post post) async {
  try {
    String rawResult =
    await restManager.makePostRequest(serverBaseUrl, "/post/create", post);
    if (rawResult.contains("ERROR:TITLE_ALREADY_EXISTS")) {
      return Creation_Deletation_Result.already_created;
    } else {
      return Creation_Deletation_Result.created;
    }
  } catch (e) {
    return Creation_Deletation_Result.error_unknown;
  }
}

Future<List<Post>> getPosts([int pageNumber = 0]) async {
  var params = {'pageNumber': pageNumber.toString()};
  try {
    var response = await restManager.makeGetRequest(
        serverBaseUrl, '/search/posts/populars', params);
    var decodedResponse = jsonDecode(response);
    return List<Post>.from(
        decodedResponse.map((i) => Post.fromJson(i)).toList());
  } catch (e, s) {
    print(e);
    print(s);
    return [];
  }
}

Future<List<Post>> getPostsByUsername(String username,
    [int pageNumber = 0]) async {
  var params = {"username": username, 'pageNumber': pageNumber.toString()};
  try {
    var response = await restManager.makeGetRequest(
        serverBaseUrl, 'search/posts/username', params);
    var decodedResponse = jsonDecode(response);
    return List<Post>.from(
        decodedResponse.map((i) => Post.fromJson(i)).toList());
  } catch (e, s) {
    print(e);
    print(s);
    return [];
  }
}

Future<List<Post>> getPostsByTitle(String title, [int pageNumber = 0]) async {
  var params = {"title": title, 'pageNumber': pageNumber.toString()};
  try {
    var response = await restManager.makeGetRequest(
        serverBaseUrl, 'search/posts/title', params);
    var decodedResponse = jsonDecode(response);
    return List<Post>.from(
        decodedResponse.map((i) => Post.fromJson(i)).toList());
  } catch (e, s) {
    print(e);
    print(s);
    return [];
  }
}

Future<List<Post>> getPostsByTypology(String typology,
    [int pageNumber = 0]) async {
  var params = {"typology": typology, 'pageNumber': pageNumber.toString()};
  try {
    var response = await restManager.makeGetRequest(
        serverBaseUrl, 'search/posts/typology', params);
    var decodedResponse = jsonDecode(response);
    return List<Post>.from(
        decodedResponse.map((i) => Post.fromJson(i)).toList());
  } catch (e, s) {
    print(e);
    print(s);
    return [];
  }
}

Future<List<Evaluation>> getPostEvaluations(int? postId, [int pageNumber = 0]) async {
  var params = {'pageNumber': pageNumber.toString()};
  try {
    var response = await restManager.makeGetRequest(
        serverBaseUrl, '/evaluation/evaluations/$postId', params);
    var decodedResponse = jsonDecode(response);
    return List<Evaluation>.from(
        decodedResponse.map((i) => Evaluation.fromJson(i)).toList());
  } catch (e, s) {
    print(e);
    print(s);
    return [];
  }
}

Future<Creation_Deletation_Result> DeletePost(int? postId, int? userId) async {
  var params = {};
  try {
    String rawResult = await restManager.makePostRequest(
        serverBaseUrl, "/post/delete/$postId/$userId", params);
    if (rawResult.contains("SUCCESS"))
      return Creation_Deletation_Result.deleted;
    return Creation_Deletation_Result.error_unknown;
  } catch (e) {
    return Creation_Deletation_Result.error_unknown;
  }
}

///METODI PER EVALUATION

Future<Creation_Deletation_Result> CreateEvaluation(
    Evaluation evaluation) async {
  try {
    String rawResult = await restManager.makePostRequest(
        serverBaseUrl, "/evaluation/create", evaluation);
    if (rawResult.contains("ERROR:Wrong_quote")) {
      return Creation_Deletation_Result.error_wrong_quote;
    } else if (rawResult.contains("ERROR:Already_valutated")) {
      return Creation_Deletation_Result.already_created;
    } else {
      return Creation_Deletation_Result.created;
    }
  } catch (e) {
    return Creation_Deletation_Result.error_unknown;
  }
}

Future<Creation_Deletation_Result> DeleteEvaluation(
    int? postId, int? userId) async {
  var params = {};
  try {
    String rawResult = await restManager.makePostRequest(
        serverBaseUrl, "evaluation/delete/$postId/$userId", params);
    if (rawResult.contains("ERROR:NO_EVALUATION"))
      return Creation_Deletation_Result.no_evaluation_yet;
    return Creation_Deletation_Result.deleted;
  } catch (e) {
    return Creation_Deletation_Result.error_unknown;
  }
}