import 'package:flutter/material.dart';
import 'package:news/input.dart';
import 'package:news/rounded_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news/login.dart';
import 'package:news/api.dart';
import 'dart:async';
import 'package:news/snackbar.dart';

class Registration extends StatefulWidget{
  late String _email;
  late String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Registration_state createState() => Registration_state();
}

class Registration_state extends State<Registration>{
  bool loading = false;
  bool showSnackBar = false;
  String showError = '';
  bool validate_email = false;
  bool validate_password = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  on_email_change(value){
    setState(() {
      widget._email = value;
    });
  }

  on_password_change(value){
    setState(() {
      widget._password = value;
    });
  }

  on_submit() async {
    setState(() {
      loading = true;
    });
    var result = await registration({ "email" : widget._email.trim(), "password" : widget._password.trim() });
    if(result['success'] == true){
      setState(() {
        loading = false;
      });
      show_snackbar();
    } else {
      setState(() {
        loading = false;
        showError = result['message'];
      });
      show_snackbar();
    }
  }

  on_validate_email(valid){
    setState(() {
      validate_email = valid;
    });
  }

  on_validate_password(valid){
    setState(() {
      validate_password = valid;
    });
  }

  show_snackbar(){
    setState(() {
      showSnackBar = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showSnackBar = false;
      });
    });
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        showError = '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              color: Colors.black
          ),
          child: Stack(
            children: [
              Image.asset("images/background.gif", height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width),

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
              Form(
                key: _formKey,
                child: Column( children:  [

                  Container( alignment: Alignment.center,
                      padding: EdgeInsets.all(20),
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child:  SvgPicture.asset("images/registration.svg", height: 190)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Регистрация", style: TextStyle( fontSize: 30 , color: Colors.white, fontWeight: FontWeight.w500 ))
                    ],
                  ),
                  Row( mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Input("email", "email",
                          const Icon(
                            Icons.person,
                            color: Color(0xFF6F35A5),
                            ),
                            on_email_change,
                            on_validate_email
                        ),
                      ] ),
                  Row( mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Input("Пароль", "Password",
                          const Icon(
                            Icons.lock,
                            color: Color(0xFF6F35A5),
                          ),
                            on_password_change,
                            on_validate_password,
                        ),
                      ] ),
                  Row( mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundedButton(text: "Создать аккаунт", press: (){
                          if (validate_email && validate_password) {
                            on_submit();
                          }
                          })
                      ] ),
                  Padding(padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Уже есть профиль?",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        GestureDetector(
                          onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));},
                          child: const Text("  Войти", style : TextStyle( fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                        )
                      ],
                    ),)
                ], crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center),
              ),
              loading ? Opacity(
                opacity: 0.5,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: double.infinity,
                    child: Center(child: Image.asset("images/loading.gif", width: 260)),
                    decoration: const BoxDecoration( color: Colors.black ),
                ),
              ) : const SizedBox(),
              Positioned(
                  bottom: 30,
                  child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: showSnackBar ? 1 : 0,
                      child: Custom_snackbar(showError.isNotEmpty ? showError : "Регистрация прошла успешно!", showError.isNotEmpty ? "error" : "success"))
              )
            ],
          ),
        ),
      ),
    );
  }
}
