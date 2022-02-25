import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:async/async.dart';

Future<List> get_posts() async {

  final response = await http.get(Uri.https('news-serve.herokuapp.com', '/posts'), headers: {
                                                                HttpHeaders.contentTypeHeader: 'application/json'});
  if (response.statusCode == 200){
    final List parsed = json.decode(response.body);
    return parsed;
  } else {
    return [];
  }
}

Future<List> get_profiles() async {
  final response = await http.get(Uri.https('news-serve.herokuapp.com', '/profiles'), headers: {
    HttpHeaders.contentTypeHeader: 'application/json'});
  if (response.statusCode == 200){
    final List parsed = json.decode(response.body);
    return parsed;
  } else {
    return [];
  }
}


Future registration(form) async {
  var data = jsonEncode(form);
  final response = await http.post(Uri.https('news-serve.herokuapp.com', '/registration'), body: data, headers: {
                                                                        HttpHeaders.contentTypeHeader: 'application/json'
                                                                        });
  if (response.statusCode == 200){
    final Map parsed = json.decode(response.body);
    return parsed;
  } else {
    final Map parsed = json.decode(response.body);
    return parsed;
  }
}


Future login(form) async {
  var data = jsonEncode(form);
  final response = await http.post(Uri.https('news-serve.herokuapp.com', '/login'), body: data,  headers: {
                                                                        HttpHeaders.contentTypeHeader: 'application/json'
                                                                          });

  if (response.statusCode == 200){
    final Map parsed = json.decode(response.body);
    return parsed;
  } else {
    final Map parsed = json.decode(response.body);
    return parsed;
  }
}

Future upload_image(email, File image) async {
  var request = http.MultipartRequest("POST", Uri.https('news-serve.herokuapp.com', '/image'));
  request.fields['user'] = email;
  request.files.add(
      http.MultipartFile(
          'image',
          image.readAsBytes().asStream(),
          image.lengthSync(),
          filename: image.path
      )
  );
  var response = await request.send();

  return true;
}

Future create_post(String email, String title, String text, File image) async {
  DateTime dateToday = DateTime.now();
  String date = dateToday.toString().substring(5,16);
  print(date);
  var request = http.MultipartRequest("POST", Uri.https('news-serve.herokuapp.com', '/create_post'));
  request.fields['title'] = title;
  request.fields['text'] = text;
  request.fields['author'] = email;
  request.fields['date'] = date;
  request.files.add(
      http.MultipartFile(
          'image',
          image.readAsBytes().asStream(),
          image.lengthSync(),
          filename: image.path
      )
  );
  var response = await request.send();
  final respStr = await response.stream.bytesToString();
  var res = json.decode(respStr);
  return res['success'];
}


Future get_avatar(String email) async {
  final response = await http.post(Uri.https('news-serve.herokuapp.com', '/avatar'), body: jsonEncode({ "email" : email }),  headers: {
    HttpHeaders.contentTypeHeader: 'application/json'
  });

  return response.body;
}

Future post_like(String email,dynamic image, String id) async {
  final response = await http.post(Uri.https('news-serve.herokuapp.com', '/post_like'), body: jsonEncode({ "email" : email, "image" : image, "id" : id }),  headers: {
    HttpHeaders.contentTypeHeader: 'application/json'
  });
  final Map parsed = json.decode(response.body);
  return parsed;
}

Future post_coment(String email, dynamic image, String text, String id) async {
  DateTime dateToday = DateTime.now();
  String date = dateToday.toString().substring(5,16);
  final response = await http.post(Uri.https('news-serve.herokuapp.com', '/post_coment'), body: jsonEncode({ "email" : email, "image" : image, "text" : text, "id" : id, "date" : date }),  headers: {
    HttpHeaders.contentTypeHeader: 'application/json'
  });
  final Map parsed = json.decode(response.body);
  return parsed;
}

Future get_favorite(liked) async {

  final response = await http.post(Uri.https('news-serve.herokuapp.com', '/favorite'), body: jsonEncode({ "items" : liked }),  headers: {
    HttpHeaders.contentTypeHeader: 'application/json'
  });
  if (response.statusCode == 200){
    final Map parsed = json.decode(response.body);
    return parsed;
  } else {
    return { "success" : false };
  }
}

Future get_my_posts(posts) async {
  final response = await http.post(Uri.https('news-serve.herokuapp.com', '/posts'), body: jsonEncode({ "items" : posts }),  headers: {
    HttpHeaders.contentTypeHeader: 'application/json'
  });
  if (response.statusCode == 200){
    final Map parsed = json.decode(response.body);
    return parsed;
  } else {
    return { "success" : false };
  }
}

Future post_following(String from, String on) async {
  final response = await http.post(Uri.https('news-serve.herokuapp.com', '/following'), body: jsonEncode({ "from" : from, "on" : on }),  headers: {
    HttpHeaders.contentTypeHeader: 'application/json'
  });
  if (response.statusCode == 200){
    final Map parsed = json.decode(response.body);
    return parsed;
  } else {
    return { "success" : false };
  }
}

///10.0.2.2:3002

Future main() async {
  var posts = await get_posts();

}

