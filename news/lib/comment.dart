import 'dart:io';

import 'package:flutter/material.dart';

class Comment extends StatelessWidget{
  String from = '';
  String text = '';
  String date = '';
  Comment(this.from , this.text, this.date);

  @override
  Widget build(BuildContext context) {
   return Container(
     decoration: BoxDecoration(
       color: Colors.grey.shade100,
     ),
     padding: const EdgeInsets.all(8),
     margin: const EdgeInsets.all(6),
     width: MediaQuery.of(context).size.width - 10,
     child: Column(

       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Row(
           children: [
             const Text('от: ', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 16)),
             Expanded(child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(from, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 17),),
                 Text(date, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54, fontSize: 14),),
               ],
             )),
           ],
         ),
         const SizedBox(height: 5),
         Row(
           children: [
             const SizedBox(width: 25),
             Expanded(child: Text(text,  style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16))),
           ],
         ),
       ],
     ),
   );
  }
}




