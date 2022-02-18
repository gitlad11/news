import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:news/api.dart';
import 'package:news/profile.dart';
import 'package:news/create_new.dart';
import 'package:news/post.dart';
import 'package:news/filters.dart';
import 'package:news/spinner.dart';


class News extends StatefulWidget{

  List items = [];

  @override
  News_state createState() => News_state();
}

class News_state extends State<News>{

  bool _showBackToTopButton = false;
  bool loading = false;

  void reload() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    var result = await init_posts();
    if(result == true){
      loading_end();
    }
  }

  loading_end(){
    setState(() {
      loading = false;
    });
  }

  init_posts() async {
    var posts = await get_posts();
    setState(() {
      widget.items = posts.reversed.toList();
    });
    return true;
  }

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 400) {
            _showBackToTopButton = true; // show the back-to-top button
          } else {
            _showBackToTopButton = false; // hide the back-to-top button
          }
        });
      });
    init_posts();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.linear);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        opacity: _showBackToTopButton ? 1 : 0,
        duration: const Duration(milliseconds: 600),
        ///SCROLL TO TOP BUTTON
        child: FloatingActionButton(
          onPressed: () {
            if(_scrollController.offset >= 400){
              _scrollToTop();
            }
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.navigation),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top : 34, left: 8, right: 8),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///ADDING POST BUTTON
                    GestureDetector(
                      onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => Create_new()));  },
                      child: const Icon(Icons.add, color: Colors.redAccent, size: 34),
                    ),
                    const Text("Главная", style: TextStyle(color: Colors.black87, fontSize: 23, fontWeight: FontWeight.w500)),
                    ///USER PROFILE BUTTON
                    GestureDetector(
                      onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => Profile())); },
                      child: const Icon(Icons.account_circle, color: Colors.redAccent, size: 34),
                    )
              ]),
            ),
            Filter(),
            ///STACK FOR ABSOLUTE POSITION SPINNER ABOVE CONTENT
            Stack(
              children: [
                ///NOTIFICATION FOR SCROLL TO TOP BUTTON,WHEN IS NO SPACE ABOVE reload()
                Container(
                  height: MediaQuery.of(context).size.height - 117,
                  child: NotificationListener<UserScrollNotification>(
                    onNotification: (notification) {
                      final ScrollDirection direction = notification.direction;
                      setState(() {
                        if (direction == ScrollDirection.forward && _scrollController.offset == 0) {
                          reload();
                        }
                      });
                      return true;
                    },
                    child: widget.items.isNotEmpty ? ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: widget.items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Post(
                              index,
                              widget.items[index]['_id'],
                              widget.items[index]['author'],
                              widget.items[index]['title'],
                              widget.items[index]['image'],
                              widget.items[index]['text'],
                              widget.items[index]["liked"],
                              widget.items[index]["coments"],
                              widget.items[index]['date']
                            );
                        }
                    ) : Center(child: Image.asset("images/loadingw.gif", width: 210)),
                  ),
                ),
                Spinner(loading)
              ],
            )
          ],
        ),
      ),
    );
  }
}
//Здесь был Николай