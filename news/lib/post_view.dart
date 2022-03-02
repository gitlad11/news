import 'package:flutter/material.dart';
import 'package:news/comment.dart';
import 'package:news/comments.dart';

class Post_view extends StatefulWidget{
  String id;
  String title;
  String preview;
  String text;
  List<dynamic> likes;
  List comments;

  Post_view(this.id, this.title, this.preview, this.text, this.likes, this.comments);

  @override
  Post_view_state createState() => Post_view_state();
}

class Post_view_state extends State<Post_view>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only( top :  30),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.white
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector( onTap: (){ Navigator.pop(context); },
                          child: const Icon(Icons.arrow_back_ios_rounded, size: 28, color: Colors.black87)
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(widget.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 14),
                Image.network(widget.preview, width: MediaQuery.of(context).size.width),
                const SizedBox(height: 9),


              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row( children: [

                      Text(widget.likes.isNotEmpty ? widget.likes.length.toString() + ' ' : ' '),

                      GestureDetector(
                        child: const Icon(Icons.favorite, size: 25, color: Colors.black54),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => Comments(widget.id, widget.title, widget.comments) )); },
                        child: const Icon(Icons.comment, size: 25, color: Colors.black54),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        Text('Коментарии: ', style : TextStyle( color: Colors.black87, fontSize: 16 )),
                      ],
                    ),
                    const SizedBox(height: 6),
                    widget.comments.isNotEmpty ? GestureDetector(
                      onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => Comments(widget.id, widget.title, widget.comments))); },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 14,
                        child: Comment(widget.comments[widget.comments.length - 1]["from"],
                                        widget.comments[widget.comments.length - 1]["text"],
                                        widget.comments[widget.comments.length - 1]["date"]),
                      ),
                    ) : GestureDetector(
                        onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => Comments(widget.id, widget.title, widget.comments))); },
                        child: const Text('нет коментариев...', style: TextStyle( color: Colors.black54, fontSize: 15 ))),
                  ],
                ),
              ),
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(widget.text, overflow: TextOverflow.ellipsis, maxLines: 999, style: const  TextStyle( color: Colors.black87, fontSize: 16 ))),


            ],
          ),
        ),
      ),
    );
  }
}