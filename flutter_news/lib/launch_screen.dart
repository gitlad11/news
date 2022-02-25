import 'package:flutter/material.dart';
import 'dart:async';

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
              Text("Подождите" + dots, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500))
            ],
          ),
      ),
    );
  }
}