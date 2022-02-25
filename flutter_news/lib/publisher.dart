import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/api.dart';
import 'package:provider/provider.dart';
import 'package:news/user.dart';

class Publisher extends StatefulWidget{
  int index;
  late String avatar;
  late String  email;
  late List following;
  late List posts;
  late List liked;
  late bool isFollow = false;
  late Function show_snackbar;

  Publisher(this.index, this.avatar, this.email, this.following, this.posts,this.liked,this.show_snackbar);

  @override
  Publisher_state createState() => Publisher_state();
}

class Publisher_state extends State<Publisher>{
  bool animated = false;
  late String email = Provider.of<Map>(context, listen: false)["email"];

  handleFollow() async {
    var result = await post_following(email, widget.email);
    if(result["success"] == true){
      if(result["follow"] == true){
        setState(() {
          widget.isFollow = true;
          animated = true;
        });

      } else {
        setState(() {
          widget.isFollow = false;
          animated = true;
        });

      }
    }
  }


  init_follow() async{
    for(var follow in widget.following){
      if(follow["email"] == email){
        setState(() {
          widget.isFollow = true;

        });
      }
    }
  }

  open_user() async {
    Map profile = {
      "email" : widget.email,
      "following" : widget.following,
      "liked" : widget.liked,
      "image" : widget.avatar,
      "posts" : widget.posts,
      "isFollow" : widget.isFollow
  };
    Navigator.push(context, MaterialPageRoute(builder: (context) => User(profile)));
  }

  @override
  void initState() {
    super.initState();
    init_follow();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){ open_user(); },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(6),
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){ open_user(); },
                  child: ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: widget.avatar.length > 1 ?
                        Image.network(widget.avatar, width: 79, height: 79)
                            : Ink.image(
                          image: const AssetImage('images/user.png'),
                          fit: BoxFit.cover,
                          width: 79,
                          height: 79,
                          child: InkWell(onTap: (){}),
                        ),
                      )
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.email, style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500 )),
                    const SizedBox(height: 6),
                    Text("подписано: " + widget.following.length.toString(), style: const TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w500 )),
                    const SizedBox(height: 6),
                    Text("записей: " + widget.posts.length.toString(), style: const TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w500 ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    !widget.isFollow ? Stack(
                      children: [
                        Positioned(
                          top: 5,
                          left: 5,
                          child: AnimatedOpacity(
                              opacity: animated ? 0.6 : 0,
                              onEnd: (){
                                setState(() {
                                  animated = false;
                                });
                              },
                              duration: const Duration(milliseconds: 600),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(  color: Colors.redAccent, shape: BoxShape.circle ) )),
                        ),
                        IconButton(onPressed: (){ handleFollow(); }, icon : const Icon(Icons.person_add, color: Colors.redAccent, size: 30)),
                      ],
                    ) :
                    Stack(
                      children: [
                        Positioned(
                          top: 5,
                          left: 5,
                          child: AnimatedOpacity(
                              opacity: animated ? 0.6 : 0,
                              duration: const Duration(milliseconds: 600),
                              onEnd: (){
                                setState(() {
                                  animated = false;
                                });
                              },
                              child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration( color: Colors.blueAccent, shape: BoxShape.circle )  )),
                        ),
                        IconButton(onPressed: (){ handleFollow(); }, icon : const Icon(Icons.person_add_disabled, color: Colors.blueAccent, size: 30)),
                      ],
                    )
                  ],
                )
              ],
            ),
            const Divider( height: 2, color: Colors.grey )
          ],
        ),
      ),
    );
  }
}