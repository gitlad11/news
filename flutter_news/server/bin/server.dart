import 'dart:collection';
import 'dart:io';
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:io' show Platform;
import 'dart:convert';

Future<HttpServer> createServer() async {
  final address = InternetAddress.loopbackIPv4;
  const port = 4042;
  return await HttpServer.bind(address, port);
}


Future<void> main() async {
  var path = Directory.current.path;
  var db;
  try {
    db = await Db.create("mongodb+srv://admin:password@cluster0.pcwin.mongodb.net/datab?retryWrites=true&w=majority");
    db.open();
  } catch(error){
    print("error with opening database" + error.toString());
  }

  final server = await createServer();
  print('✅ server started: ${server.address} port: ${server.port} ');
  await handleRequests(server, db);
}


Future<void> handleRequests(HttpServer server, db) async {
  await for (HttpRequest req in server){
    switch (req.method){

      case 'GET':
        String data = await utf8.decoder.bind(req).join();
        print("params :" + req.uri.toString());
        req.response..write("hello from server side!")..close();
        break;


      case 'POST':

        String data = await utf8.decoder.bind(req).join();
        var decoded = await json.decode(data);
        var map = HashMap.from(decoded);


        switch(req.uri.toString()){
          case '/registration':
            var user = [];
            print(req.uri.toString());
            map.forEach((key, value) { user.add(value); });
            var coll = db.collection('users');
            coll.insertOne({ "email" : user[0], "password" : user[1] });
            req.response..write("200")..close();
            break;

          case '/login':
            var user = [];
            print(req.uri.toString());
            map.forEach((key, value) { user.add(value); });
            var coll = db.collection('users');
            var value = await coll.findOne({ "email" : user[0], "password" : user[1] });
            if(value != Null){
              req.response..write(value)..close();
            } else {
              req.response..write("error")..close();
            }
            break;

          default:
            return;
        }

        break;

      default:
        req.response..write('error : ${req.method}')..close();
    }
  }
}

