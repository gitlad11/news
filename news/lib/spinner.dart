
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Spinner extends StatefulWidget{
  bool loading;

  Spinner(this.loading);

  @override
  Spinner_state createState() => Spinner_state();
}

class Spinner_state extends State<Spinner>{
  @override
  Widget build(BuildContext context) {

    ///SPINNER FOR RELOADING PAGES ON SCROLLING UP
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      top: widget.loading ? 10 : -80,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade500,
                offset: const Offset(
                  3.0,
                  3.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ), //BoxShadow
              const BoxShadow(
                color: Colors.white,
                offset: Offset(0.0, 0.0),
                blurRadius: 0.0,
                spreadRadius: 0.0,
              ), //BoxShadow
            ],
          ),
          alignment: Alignment.center,
          width: 40,
          height: 40,
          child: const CircularProgressIndicator(valueColor : AlwaysStoppedAnimation<Color>(Colors.indigoAccent))
        ),
      ),
    );
  }
}