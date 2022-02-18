import 'package:flutter/material.dart';

class Custom_snackbar extends StatefulWidget{
  String text;
  String type;

  Custom_snackbar(this.text, this.type);

  @override
  SnackBar_state createState() => SnackBar_state();
}

class SnackBar_state extends State<Custom_snackbar>{
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: AnimatedContainer(
          padding: const EdgeInsets.all(14),
          duration: const Duration(milliseconds: 400),

          decoration: BoxDecoration(
              color: widget.type == 'success' ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]),
          child: Text(widget.text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17)),
      ),
    );
  }
}