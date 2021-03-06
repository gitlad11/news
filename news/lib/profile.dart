import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news/avatar.dart';
import 'package:news/profile_info.dart';
import 'package:news/bottom_scroll_view.dart';
import 'package:news/registration.dart';
import 'package:news/news.dart';
import 'package:news/localStorage.dart';
import 'package:news/login.dart';
import 'package:news/permission_handler.dart';
import 'package:news/api.dart';
import 'package:news/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:news/api.dart';
import 'package:news/bottom_scroll_loading.dart';


class Profile extends StatefulWidget{
  int tab = 999;
  Map profile = {};

  @override
  Profile_state createState() => Profile_state();
}

class Profile_state extends State<Profile>{
  List<String> items = [];
  bool loading = false;

  var imagePicker = ImagePicker();

  _getStoragePermission() async {
    storagePermission(getImage);
  }

  getImage() async {

    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    final imageFile = File(image!.path);
    setState(() {
      loading = true;
    });
    var result = await upload_image(Provider.of<ProfileProvider>(context, listen: false).profile['email'], Provider.of<ProfileProvider>(context, listen: false).profile['image'] , imageFile);
    if(result == true){
      auth();
    }
    setState(() {
      loading = false;
    });
  }

  on_tab(index){
    setState(() {
      widget.tab = index;
    });
  }

  @override
  void initState() {
    super.initState();
    auth();
  }


  auth() async {
    Provider.of<ProfileProvider>(context, listen: false).initUser();
  }

  log_out() async {
    var removed = await removeToken();
    Provider.of<ProfileProvider>(context, listen: false).removeUser();
    if(removed){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProfileProvider>(
        builder: (context, profile, child) => Stack(
          children: [

            ///GRADIENT BACKGROUND
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  gradient:  LinearGradient(
                      begin: Alignment(-1.0, -1),
                      end: Alignment(-1.0, 1),
                      colors: [Colors.purpleAccent, Colors.purple, Colors.deepPurpleAccent]),

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
                          onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => News() )); },
                          child: const Icon(
                            Icons.arrow_back_ios_sharp,
                            size: 24,
                            color: Colors.white70,

                          ),
                        ),
                        const Text("??????????????", style: TextStyle( fontWeight: FontWeight.w500, color: Colors.white, fontSize: 28 )),
                        GestureDetector(
                          onTap: (){
                            log_out();
                          },
                          child: const Icon(
                            Icons.exit_to_app,
                            size: 24,
                            color: Colors.white70,

                          ),
                        ),
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
                    profile.profile['image'] != null ? ProfileWidget(imagePath: profile.profile['image'], avatar: true,  onClicked: (){
                      _getStoragePermission();
                    })
                        :  ProfileWidget(imagePath: 'images/user.png', avatar: false,  onClicked: (){
                      _getStoragePermission();
                    }),
                    const SizedBox(height: 23),
                    Text(profile.profile.isNotEmpty ? profile.profile['email'] : '', softWrap: true, style: const TextStyle(color: Colors.white, fontSize: 18) ),
                    const SizedBox(height: 23),

                    ///LIKES AND FOLLOWING
                    profile.profile.isNotEmpty ? Info(profile.profile['following'], profile.profile['liked']) : const SizedBox()

                  ],
                ),
              ),
            ),
            profile.profile['posts'] != null ? Bottom_scroll(get_my_posts, profile.profile['posts'], "?????? ????????????", 135, 135, Icons.library_books_sharp, 0, widget.tab, on_tab) :
            Bottom_scroll_loading(135),
            profile.profile["liked"] != null ? Bottom_scroll(get_favorite, profile.profile["liked"], "??????????????????", widget.tab != 0 ? 70 : 0, widget.tab != 0 ? 70 : 0,  Icons.favorite, 1,widget.tab, on_tab) :
            Bottom_scroll_loading(70),
          ],
        ),
      ),
    );
  }
}
