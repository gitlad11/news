import 'package:flutter/material.dart';
import 'package:news/news.dart';
import 'package:news/provider/profile_provider.dart';
import 'package:news/publisher.dart';
import 'package:news/api.dart';
import 'package:news/snackbar.dart';
import 'package:provider/provider.dart';


class Publisher_list extends StatefulWidget{
  List items = [];
  String message = '';
  @override
  Publisher_list_state createState() => Publisher_list_state();
}

class Publisher_list_state extends State<Publisher_list>{
  bool playAnimation = false;
  String error = '';

  show_snackbar(message){
    setState(() {
      playAnimation = true;
      widget.message = message;
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        playAnimation = false;
      });
    });
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        message = "";
      });
    });
  }

  init_publishers() async {

    var posts = await get_profiles();
    setState(() {
      widget.items =  posts.reversed.toList();
    });
    return true;
  }

  @override
  void initState() {
    super.initState();
    init_publishers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top : 34, left: 8, right: 8),
          decoration: const BoxDecoration( color: Colors.white ),
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      const Text("Публикации", style: TextStyle(color: Colors.black87, fontSize: 23, fontWeight: FontWeight.w500)),
                      GestureDetector(
                        onTap: (){  Navigator.push(context, MaterialPageRoute(builder: (context) => News())); },
                        child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.redAccent, size: 31),
                      )
                    ],
                  ),
                  widget.items.isNotEmpty ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.items.length,
                      itemBuilder: (BuildContext context, int index){
                        if(widget.items[index]['email'] != Provider.of<ProfileProvider>(context, listen: false).profile["email"]){
                          return Publisher(
                              index,
                              widget.items[index]['image'],
                              widget.items[index]['email'],
                              widget.items[index]['following'],
                              widget.items[index]['posts'],
                              widget.items[index]["liked"],
                              show_snackbar
                          );
                        }  else {
                          return const SizedBox();
                        }
                      }
                  ) : Container(
                      height: MediaQuery.of(context).size.height - 80,
                      width: MediaQuery.of(context).size.width,
                      child: Center(child: Image.asset("images/loadingw.gif", width: 210))),
                ],
              ),
              Positioned(
                  bottom: 30,
                  child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: playAnimation ? 1 : 0,
                      child: Custom_snackbar(widget.message.isNotEmpty ? widget.message : "добавлено!", error.isNotEmpty ? "error" : "success"))
              )
            ],
          ),
      ),
    );
  }
}