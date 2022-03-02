import 'package:flutter/material.dart';
import 'package:news/post.dart';
import 'package:news/provider/profile_provider.dart';
import 'package:news/publisher_list.dart';
import 'package:provider/provider.dart';
import 'package:news/avatar.dart';
import 'package:news/profile_info.dart';

import 'api.dart';

class User extends StatefulWidget{
  Map profile = {};
  bool isFollow = false;
  List items = [];

  User(this.profile);

  @override
  User_state createState() => User_state();
}

class User_state extends State<User>{
   bool loading = false;
   late String email = Provider.of<ProfileProvider>(context, listen: false).profile["email"];
   bool animated = false;

   var scrollController = ScrollController();

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
   initItems() async {
     List data = [];
      for(var post in widget.profile['posts']){
        data.add(post['id']);
      }
     var posts = await get_my_posts(data);
     if(posts['favorite'].length > 0){
       setState(() {
         widget.items = posts["favorite"];

       });
     }
    }

  @override
  void initState() {
    super.initState();
    setState(() {
      widget.isFollow = widget.profile['isFollow'];
    });
    initItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProfileProvider>(
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
                padding: const EdgeInsets.only(top: 24),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(8)
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
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
                      widget.profile.isNotEmpty ? Info(widget.profile['following'], widget.profile['liked']) : const SizedBox(),

                      const SizedBox(height: 50),
                      Container(
                        padding: const EdgeInsets.all(9),
                        height: MediaQuery.of(context).size.height - 120,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            topLeft: Radius.circular(16)
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text("Записи", style: TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w500),),
                                SizedBox(width: 2),
                                Icon(Icons.library_books_sharp,  size: 22, color: Colors.redAccent),
                              ],
                            ),
                            const SizedBox(height: 10),
                            AnimatedContainer(

                                duration: const Duration(milliseconds: 400),
                                child:
                                loading ? Center(child: Image.asset("images/loadingw.gif", width: 210)) :
                                widget.items.isNotEmpty ? ListView.builder(
                                    shrinkWrap: true,
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
                                ) : const Center( child: Text("Записи не найдены!", style: TextStyle(color: Colors.black54, fontSize: 19, fontWeight: FontWeight.w500)) )

                            )
                          ],
                        ),

                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}