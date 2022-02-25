
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Gradient_button extends StatefulWidget{
  String title;
  Function onClick;
  IconData icon;

  Gradient_button(this.title, this.onClick, this.icon);

  @override
  Gradient_button_state createState() => Gradient_button_state();
}

class Gradient_button_state extends State<Gradient_button>{
  @override
  Widget build(BuildContext context) {
    return  Container(
        height: 50,
        width: double.infinity,
        ///RAISED BUTTON DOES NOT LOOK PROPERLY WITH INK GRADIENT
        child: TextButton(

          onPressed: (){
            widget.onClick();
          },

          child: Ink(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xffff5f6d),
                      Color(0xffff5f6d),
                      Color(0xffffc371),
                    ]
                )
            ),
            child: Container( alignment: Alignment.center,
                constraints: const BoxConstraints(maxWidth: double.infinity, minHeight: 50),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children:  <Widget>[
                    Icon(widget.icon, color : Colors.white),
                    Text(widget.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center)
                  ],)
            ),
          ),

        )
    );
  }
}