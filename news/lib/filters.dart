import 'dart:io';
import 'package:flutter/material.dart';

class Filter extends StatefulWidget{
  @override
  Filter_state createState() => Filter_state();
}

class Filter_state extends State<Filter>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 6),
      height: 45,
      alignment: Alignment.center,
      ///FILTER BUTTONS
      child: ListView(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: (){},
            child: const Text('Новое',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19, letterSpacing: 0.1, color: Colors.blueAccent)),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: (){},
            child: const Text('Лучшее',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19, letterSpacing: 0.1)),
          ),
        ],
      ),
      decoration: const BoxDecoration(
        color: Colors.white
      ),
    );
  }
}
