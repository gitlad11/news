import 'package:flutter/material.dart';
import 'package:news/login.dart';
import 'package:news/profile.dart';
import 'dart:async';

import 'package:news/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class Launch_screen extends StatefulWidget{
  @override
  Launch_screen_state createState() => Launch_screen_state();
}

class Launch_screen_state extends State<Launch_screen>{
  String dots = '...';

  @override
  void initState() {
    // TODO: implement initState
    on_dots_change();
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), authenticate);
  }

  on_dots_change(){
    Timer.periodic(const Duration(milliseconds: 500), (Timer t) => {
        setState(() => {
          if(dots == '.'){
            dots = '..'
          }
          else if(dots == '..'){
            dots = '...'
          } else {
            dots = '.'
          }
        })
    });
  }

  authenticate() async {
    var user = await Provider.of<ProfileProvider>(context, listen: false).initUser();
    if(user == true){
      print(user);
      return Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
    } else {
      print(user);
      return Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration( color: Colors.black ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("images/loading.gif", width: MediaQuery.of(context).size.width),
              Text("Загрузка" + dots, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500))
            ],
          ),
      ),
    );
  }
}