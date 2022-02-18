import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:news/avatar.dart';
import 'package:news/profile_info.dart';
import 'package:news/post.dart';
import 'package:news/api.dart';
import 'package:provider/provider.dart';

class Bottom_scroll extends StatefulWidget{
  List links = [];
  String title = '';
  double height = 100;
  double fixedHeight;
  bool opened = false;
  var icon = Icons.favorite;
  int index;
  int tab;
  Function onTab;
  late List items = [];

  Bottom_scroll(this.links, this.title, this.height, this.fixedHeight, this.icon, this.index, this.tab, this.onTab);

  @override
  Bottom_scroll_state createState() => Bottom_scroll_state();
}

class Bottom_scroll_state extends State<Bottom_scroll>{

  @override
  void didUpdateWidget(covariant Bottom_scroll oldWidget) {

    if(widget.tab == widget.index){
      setState(() {
        widget.height = MediaQuery.of(context).size.height;
        widget.opened = true;
      });
    } else {
      setState(() {
        widget.height = widget.fixedHeight;
        widget.opened = false;

      });
    }
  }

  @override
  void initState() {
    print(widget.links);
    initItems();
    super.initState();
  }

  initItems() async {
    var favorite = await get_favorite(widget.links);
    if(favorite["success"] == true){
    }
  }

  @override
  Widget build(BuildContext context) {


    return Positioned(
      bottom: 0,
      child: GestureDetector(
        ///ON CLICK SET HEIGHT TO FULL SCREEN
        onTap: (){
          widget.onTab(widget.index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: widget.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: widget.opened ? 30 : 10),
             Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children : [
                ///BACK BUTTON
               AnimatedOpacity(
                   opacity: widget.opened ? 1 : 0,
                   duration: const Duration(milliseconds: 500),
                   child: GestureDetector(
                     onTap: (){
                       widget.onTab(999);
                     },
                       child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black87, size: 28)
                   )
               ),
               ///DECORATIVE ICON
               Row(
                 children: [
                   Text(widget.title, style: const TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w500),),
                   const SizedBox(width: 2),
                   widget.icon != null ? Icon(widget.icon, size: 22, color: Colors.redAccent ) : const SizedBox(),
                 ],
               ),
                   const SizedBox(),
             ]),
              SizedBox( height: widget.opened ? 10 : 30 ),
              Container(
                height: MediaQuery.of(context).size.height - 88,
                child: widget.items.isNotEmpty ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Post(index,
                                widget.items[index]["_id"],
                                widget.items[index]['author'],
                                widget.items[index]['title'],
                                widget.items[index]['image'],
                                widget.items[index]['text'],
                                widget.items[index]["likes"],
                                widget.items[index]["comments"],
                                widget.items[index]['date']
                        );
                  }
            ) : const Center( child: Text("Записи не найдены!", style: TextStyle(color: Colors.black54, fontSize: 19, fontWeight: FontWeight.w500)) ),
              )
            ]
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
        ),
        ],
          ),
        ),
      ),
    ) ;
  }
}