import 'package:flutter/material.dart';
import 'package:news/comments.dart';
import 'package:news/comment.dart';
import 'package:news/post_view.dart';
import 'package:news/api.dart';
import 'package:news/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class Post extends StatefulWidget{
  late int index;
  late String id;
  late String author;
  late String title;
  late String image;
  late String text;
  late List<dynamic> likes;
  late List comments;
  late String date;
  late String avatar = '';

  Post(this.index, this.id, this.author, this.title, this.image, this.text, this.likes, this.comments, this.date);

  @override
  Post_state createState() => Post_state();
}

class Post_state extends State<Post> with AutomaticKeepAliveClientMixin{
  bool likedList = false;
  String ava = '';
  bool animate = false;
  bool liked = false;
  bool animateLike = false;
  bool animateImages = false;

  show_likes(){
      setState(() {
        likedList = true;
      });
  }

  close_likes(){
    setState(() {
      likedList = false;
    });
  }
  
  init_avatar() async {
   var avatar = await get_avatar(widget.author);
   setState(() {
     if(avatar != null){
       widget.avatar = avatar;
     } 
   });
   setState(() {
     ava = widget.avatar;
   });
   print(ava);
  }

  init_likes() async {
    var email = Provider.of<ProfileProvider>(context, listen: false).profile["email"];
    for(var i in widget.likes){
      if(email == i['email']){
        setState(() {
          liked = true;
        });
      }
    }
  }

  add_like() async{
    var email = Provider.of<ProfileProvider>(context, listen: false).profile["email"];
    var image = Provider.of<ProfileProvider>(context, listen: false).profile["image"];
    var result = await post_like(email,image, widget.id);
    if(result['success'] == true){
          setState(() {
            liked = true;
            animateLike = true;
          });
    } else {
          setState(() {
            liked = false;
            animateLike = true;
          });
    }
    Provider.of<ProfileProvider>(context, listen: false).initUser();
  }

  animateImage(){
    setState(() {
      animateImages = true;
    });
  }

  @override
  void initState() {
    super.initState();
    init_likes();
    init_avatar();
    if(widget.image.isNotEmpty){
      Future.delayed(const Duration(milliseconds: 400), animateImage );
    }
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){ close_likes(); },
      child: Container(
        padding: const EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            color: Colors.white,

        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///AVATAR AND NAME OF AUTHOR
            Row(
              children: [
                ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: ava.length > 1 ?
                     AnimatedOpacity(
                         opacity: animateImages ? 1 : 0,
                         duration: const Duration(milliseconds: 500),
                         child: Image.network(ava, width: 36, height: 36))
                    : AnimatedOpacity(
                      opacity: animateImages ? 1 : 0,
                      duration: const Duration(milliseconds: 500),
                      child: Ink.image(
                        image: const AssetImage('images/user.png'),
                        fit: BoxFit.cover,
                        width: 36,
                        height: 36,
                        child: InkWell(onTap: (){}),
                      ),
                    ),
                  )
                ),
                const SizedBox(width: 8),
                Text(widget.author, style: const TextStyle(fontWeight: FontWeight.w500)),
                Expanded(child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                  Text(widget.date, style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500))
                ], ))
            ]),

            const SizedBox(height: 10),
            ///PREVIEW FOR POST
            GestureDetector(
              onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => Post_view(widget.id, widget.title, widget.image, widget.text, widget.likes, widget.comments) )); },
              child: Row( children: [
                AnimatedOpacity(
                  opacity: animateImages ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  child: Image.network(widget.image, width: MediaQuery.of(context).size.width - 34, loadingBuilder:
                      (BuildContext context, Widget child, ImageChunkEvent? loadingProgress){
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width - 34,
                          child: Center(
                            child: Image.asset("images/loadingw.gif", width: 140),
                          ),
                        );
                  }),
                )
              ] ),
            ),
            const SizedBox(height: 10),

            ///CONTENT
            GestureDetector(
                onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => Post_view(widget.id, widget.title, widget.image, widget.text, widget.likes, widget.comments) )); },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title, style: const TextStyle(color: Colors.black87, fontSize: 19, fontWeight: FontWeight.w500, wordSpacing: 0.3)),
                    const SizedBox(height: 8),
                    Text(widget.text, overflow: TextOverflow.ellipsis, maxLines: 5,
                        style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.normal )),
                  ],
                )),
            ///LIKES AND COMMENTS
            const SizedBox(height: 20),
            Row( children: [
              GestureDetector(
                  onLongPress: (){ show_likes(); },
                  child: Row(children: [
                Text(widget.likes.isNotEmpty ? widget.likes.length.toString() + '' : ' '),
                GestureDetector(
                  onTap: (){ add_like(); },
                  child:  Container(
                    width: 30,
                    height: 30,
                    child: Stack(
                      children: [
                        AnimatedOpacity(
                            opacity: animateLike ? 0.5 : 0, duration: const Duration(milliseconds: 300),
                            onEnd: (){ setState(() {
                              animateLike = false;
                            }); },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration( color: Colors.redAccent, shape: BoxShape.circle, ),
                          ),
                        ),
                        Positioned(
                            top: 4,
                            left: 3,
                            child: !liked ? const Icon(Icons.favorite, size: 24, color: Colors.black54) :
                            const Icon(Icons.favorite, size: 24, color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ),
                ),
              ])),
              const SizedBox(width: 16),
              Container(
                width:  160,
                height: 40,
                child: Stack(
                  children: [
                    Positioned(
                      top : 9,
                      child: Row(
                        children: [
                          Text(widget.comments.isNotEmpty ? widget.comments.length.toString() + ' ' : ' '),
                          GestureDetector(
                            onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => Comments(widget.id, widget.title, widget.comments) )); },
                            child: const Icon(Icons.comment, size: 25, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    ///LIST OF LIKED PEOPLE AFTER LONG PRESS
                    widget.likes.length > 2 ? Positioned(
                      child: AnimatedContainer(
                        padding: const EdgeInsets.all(3),
                        height: 40,
                        duration: const Duration(milliseconds: 300),
                        ///LIKED WIDTH ANIMATION
                        width: likedList ? 135 : 0,
                        child: ListView(

                          padding: const EdgeInsets.all(2),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: [
                            ///AVATARS OF LIKED PERSONS
                            widget.likes[widget.likes.length - 1]['image'] != null ?
                            CircleAvatar(
                              backgroundImage: NetworkImage(widget.likes[widget.likes.length - 1]['image']),
                            ) : const CircleAvatar(
                              backgroundImage: AssetImage("images/user.png"),
                            ),
                            widget.likes[widget.likes.length - 2]['image'] != null ?
                            CircleAvatar(
                              backgroundImage: NetworkImage(widget.likes[widget.likes.length - 2]['image']),
                            ) : const CircleAvatar(
                              backgroundImage: AssetImage("images/user.png"),
                            ),
                            widget.likes[widget.likes.length - 3]['image'] != null ?
                            CircleAvatar(
                              backgroundImage: NetworkImage(widget.likes[widget.likes.length - 3]['image']),
                            ) : const CircleAvatar(
                              backgroundImage: AssetImage("images/user.png"),
                            ),
                          ],
                        ),
                        decoration: likedList ? const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 2), // changes position of shadow
                            ),
                          ]
                        ) : const BoxDecoration()
                      )
                    ) : const SizedBox(),
                  ],
                ),
              ),
            ]),

           const SizedBox(height: 20),
           ///COMMENTS
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
            const SizedBox(height: 6),
            const Divider(height: 3, thickness: 2.1)

          ]
        )
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
//Здесь был Николай