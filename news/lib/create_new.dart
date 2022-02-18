import 'dart:async';
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:news/gradient_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news/permission_handler.dart';
import 'package:news/api.dart';
import 'package:news/profile.dart';
import 'package:news/snackbar.dart';
import 'package:news/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'news.dart';

class Create_new extends StatefulWidget{

  String author = '';
  String title = '';
  String preview = '';
  File preview_file = File('');
  String text = '';
  bool loading = false;

  @override
  Create_new_state createState() => Create_new_state();
}


class Create_new_state extends State<Create_new>{
  bool keyboard_is_on = false;
  bool permissionGranted = false;
  bool showSnackBar = false;
  String showError = "";

  var imagePicker = ImagePicker();


  _getStoragePermission() async {
    storagePermission(getImage);
  }

  getImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    final imageFile = File(image!.path);

    setState(() {
      widget.preview = imageFile.path;
      widget.preview_file = imageFile;

    });

  }

  on_submit() async {

    setState(() {
      widget.loading = true;
    });
    if(widget.author.isNotEmpty && widget.title.isNotEmpty && widget.text.isNotEmpty){
      var response = await create_post(widget.author, widget.title, widget.text, widget.preview_file);
      if(response == true){
        setState(() {
          widget.loading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => News() ));
      } else {
        setState(() {
          widget.loading = false;
          showError = 'Произошла ошибка!';
        });
        show_snackbar();
      }
    }
  }

  show_snackbar(){

    setState(() {
      showSnackBar = true;
    });
    Future.delayed(const Duration(seconds: 3), (){
      setState(() {
        showSnackBar = false;
      });
    });
    Future.delayed(const Duration(seconds: 4), (){
      setState(() {
        showError = "";
      });
    });
  }

  @override
  void initState() {
    setState(() {
      widget.author = Provider.of<Map>(context, listen: false)["email"];
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.only(top : 34, left: 8, right: 8),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector( onTap: (){ Navigator.pop(context); },
                            child: const Icon(Icons.arrow_back_ios_rounded, size: 28, color: Colors.black87)
                        ),
                        const Text('Создание записи', style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.w500, wordSpacing: 0.1)),
                        const SizedBox(),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 6, right: 6),
                      child: TextField(
                        onChanged: (text){
                          setState(() {
                            widget.title = text;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "Заголовок"
                        ),
                      ),
                    ),

                    const SizedBox( height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Обложка', style: TextStyle( color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 19 ))
                      ],
                    ),

                    const SizedBox( height: 10),
                    GestureDetector(
                      onTap: () {  _getStoragePermission(); },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        color: Colors.grey.shade200,
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        margin: const EdgeInsets.all(4),
                        child: DottedBorder(
                          color: Colors.red,
                          strokeWidth: 1,
                          child: Center(child: widget.preview.isEmpty ? Image.asset("images/photo.png", height: 90, width: 99) : Image.file(widget.preview_file)),
                        )
                      ),
                    ),

                    const SizedBox( height: 20 ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Текст записи', style: TextStyle( color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 19 ))
                      ],
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        padding: const EdgeInsets.all(8),
                        child:  TextField(
                          onChanged: (text){
                            setState(() {
                              widget.text = text;
                            });
                          },
                          minLines: 5,
                          maxLines: 5,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              hintText: "текст ",

                          ),
                        ),
                      ),
                    ),

                   !widget.loading ?
                   Gradient_button("Создать запись", (){ on_submit(); }, Icons.add) :
                   Center(child: Image.asset("images/loadingw.gif", width: 160)),
                    const SizedBox( height: 20 ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 30,
              child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: showSnackBar ? 1 : 0,
                  child: Custom_snackbar(showError.isNotEmpty ? showError : "Регистрация прошла успешно!", showError.isNotEmpty ? "error" : "success"))
          )
        ],
      ),
    );
  }
}