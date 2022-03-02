import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

dynamic authenticate() async {
final LocalStorage storage = LocalStorage('tokens');
var authentication = await storage.getItem("token");

if(authentication == null){
  return null;
} else {
  final response = await http.post(Uri.https('news-serve.herokuapp.com', '/authenticate'), body: jsonEncode({ "token" : authentication }) ,  headers: {
    HttpHeaders.contentTypeHeader: 'application/json'
  });
  final Map parsed = json.decode(response.body);
  if(parsed['success'] == true){
    return parsed['profile'];
    } else {

    return null;
  }
  }
}

checkToken() async{
  final LocalStorage storage = LocalStorage("tokens");
  var user_exists = await storage.getItem("token");
  if(user_exists != null){
    return true;
  } else {
    return false;
  }
}

setToken(token) async {
  final LocalStorage storage = LocalStorage("tokens");
  var user_added = storage.setItem("token", token);
  return storage.getItem("token");
}

removeToken() async {
  final LocalStorage storage = LocalStorage('tokens');
  var user_deleted = storage.setItem("token", null);
  return true;
}

