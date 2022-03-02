import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:news/login.dart';
import 'package:news/registration.dart';
import 'package:news/profile.dart';
import 'package:news/launch_screen.dart';
import 'package:news/localStorage.dart';
import 'package:provider/provider.dart';
import 'package:news/provider/profile_provider.dart';
import 'package:news/localStorage.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  bool authenticated = false;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map profile = {};
  bool reload = false;

  @override
  void initState() {
    auth();
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  auth() async {
    var check = await checkToken();
    setState(() {
      widget.authenticated = check;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
      ],
      child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          home: Launch_screen()
      ),
    );
  }
}



