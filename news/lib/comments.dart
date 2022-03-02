import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/comment.dart';
import 'package:news/provider/profile_provider.dart';
import 'package:provider/provider.dart';

import 'api.dart';
import 'package:news/news.dart';

class Comments extends StatefulWidget{
  String id = '';
  String name = '';
  bool sending = false;
  List comments = [];

  Comments(this.id, this.name, this.comments);

  @override
  Comments_state createState() => Comments_state();
}

class Comments_state extends State<Comments>{

  final controller = TextEditingController();

  add_coment() async{
    var email = Provider.of<ProfileProvider>(context, listen: false).profile["email"];
    var image = Provider.of<ProfileProvider>(context, listen: false).profile["image"];

    var result = await post_coment(email, image, controller.text, widget.id);
    if(result['success'] == true){
      setState(() {
        widget.comments = result['coments'];
        widget.sending = false;
        controller.text = '';
      });
    }
    Provider.of<ProfileProvider>(context, listen: false).initUser();
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ///APPBAR
          Positioned(
            top: 0,
            child: Container(
            padding: const EdgeInsets.only(top: 34, left: 3, right: 3),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  child: Row( children: [
                    GestureDetector(
                      onTap: (){ Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => News()));  },
                      child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black87, size: 28 ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width - 310),
                    const Icon(Icons.comment, color: Colors.black54,size: 24),
                    const SizedBox(width: 5),
                    const Text('Коментарии', style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.w500, wordSpacing: 0.1)),

                  ], ),
                ),
                const SizedBox( height: 15 ),
                Container(
                  width: MediaQuery.of(context).size.width ,
                  padding: const EdgeInsets.all(14),
                  child: Row( children: [
                                      const Text("к посту: ", style: TextStyle(color: Colors.black54, fontSize: 18)),
                                      Expanded(child: Text(widget.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))
                  ], ),
                ),
                ///COMMENTS
                Container(
                  height: MediaQuery.of(context).size.height - 200,
                  child: widget.comments.isNotEmpty ? ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: widget.comments.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Comment(widget.comments[index]["from"], widget.comments[index]["text"], widget.comments[index]["date"]);
                      }
                  ) : const Center( child: Text("Коментарии не найдены!", style: TextStyle(color: Colors.black54, fontSize: 19, fontWeight: FontWeight.w500)) ),
                ),
              ],
            ),
        ),
          ),

        ///INPUT FOR ADDING COMMENT
        Positioned(
            bottom: 0,
            child:
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border( top: BorderSide(width: 1, color: Colors.grey) )
              ),
              height: 60,

              padding: const EdgeInsets.only(left: 8),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(

                        controller: controller,
                        obscureText: false,
                    decoration: const InputDecoration(
                      labelText: 'Ваш комментарий...',
                    )),
                  ),
                  Container(
                      width: 36,
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: widget.sending ?
                      const Icon(Icons.send, size: 28, color: Colors.black38) :
                      GestureDetector(
                        onTap: (){ add_coment(); },
                        child: const Icon(Icons.send, size: 28, color: Colors.black54),)
                  )
                ],
              ),
            )
        )
        ]
      ),
    );
  }
}

//Здесь был Николай