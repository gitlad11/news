import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';


Future<String> test_request(url) async {
  final response = await http.get(Uri.http(url, '/'), headers: {
    HttpHeaders.contentTypeHeader: 'application/json'});
  if (response.statusCode == 200) {
    print(response.body);
    return response.body;
  } else {
    return "error: " + response.statusCode.toString();
  }
}

Future main() async {
  return test_request('localhost:3002');
}
