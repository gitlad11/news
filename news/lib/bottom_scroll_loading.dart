import 'dart:ui';
import 'package:flutter/material.dart';


class Bottom_scroll_loading extends StatelessWidget{
  double height;

  Bottom_scroll_loading(this.height);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        width: MediaQuery.of(context).size.width,
        child: Container(
          height: height,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('images/giphy (1).gif', width: 160, height: 80)
                ],
              )
            ],
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              )
            ]
          ),
        ));
  }
}
