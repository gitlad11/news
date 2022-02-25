import 'package:flutter/material.dart';
import 'package:news/publisher_list.dart';
import 'package:provider/provider.dart';
import 'package:news/avatar.dart';
import 'package:news/profile_info.dart';

import 'api.dart';

class User extends StatefulWidget{
  Map profile = {};
  bool isFollow = false;

  User(this.profile);

  @override
  User_state createState() => User_state();
}

class User_state extends State<User>{
   bool loading = false;
   late String email = Provider.of<Map>(context, listen: false)["email"];
    bool animated = false;

   init_follow() async{
     for(var follow in widget.profile["following"]){
       if(follow["email"] == email){
         setState(() {
           widget.isFollow = true;

         });
       }
     }
   }

   handleFollow() async {
     var result = await post_following(email, widget.profile["email"]);
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
  @override
  void initState() {
    super.initState();
    setState(() {
      widget.isFollow = widget.profile['isFollow'];
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, profile, child) => Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment(-1.0, -1),
                      end: Alignment(-1.0, 1),
                      colors: [Colors.deepPurpleAccent, Colors.purple, Colors.purpleAccent]),
                  borderRadius: BorderRadius.circular(8)
              ),
            ),
            ///SHADOW FOR GRADIENT BACKGROUND
            Opacity(
              opacity: 0.3,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.black
                ),
              ),
            ),
            ///CONTENT
            Center(
              child: Container(
                padding: const EdgeInsets.all(6),
                height: MediaQuery.of(context).size.height - 100,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(8)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(

                      children: [
                        GestureDetector(
                          onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => Publisher_list())); },
                          child: const Icon(
                            Icons.arrow_back_ios_sharp,
                            size: 24,
                            color: Colors.white70,

                          ),
                        ),
                        const Text("Публикация", style: TextStyle( fontWeight: FontWeight.w500, color: Colors.white, fontSize: 28 )),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),

                    ///PROFILE AVATAR AND EMAIL
                    const SizedBox(height: 90),
                    loading ? Center(child: ClipOval(
                      child: Container( width: 160, height: 160,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                          child: Image.asset('images/giphy (1).gif', width: 160, height: 160)),
                    ) ) :
                    widget.profile['image'] != null ? ProfileWidget(imagePath: widget.profile['image'], avatar: true, isUser: true,  onClicked: (){})
                        :  ProfileWidget(imagePath: 'images/user.png', avatar: false,  onClicked: (){}),
                    const SizedBox(height: 23),
                    Text(widget.profile.isNotEmpty ? widget.profile['email'] : '', softWrap: true, style: const TextStyle(color: Colors.white, fontSize: 18) ),
                    const SizedBox(height: 23),

                    ///LIKES AND FOLLOWING
                    widget.profile.isNotEmpty ? Info(widget.profile['following'], widget.profile['liked']) : const SizedBox()

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}