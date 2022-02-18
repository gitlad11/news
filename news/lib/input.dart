import 'package:async/async.dart';
import 'package:flutter/material.dart';


class Input extends StatefulWidget{
  String text = '';
  String type = 'text';
  Widget icon;
  Function onChange;
  late Function validate;
  Input(this.text, this.type, this.icon, this.onChange, this.validate);

  @override
  Input_state createState() => Input_state();
}

class Input_state extends State<Input>{
  bool show = false;
  String validate = '';
 /// var controller = TextEditingController();


  ///@override
  ///void dispose() {
    ///удаляет прототип контроллера когда данный виджет unmounted
    ///controller.dispose();
    ///super.dispose();
  ///}


  @override
  Widget build(BuildContext context) {

    return TextFieldContainer(
      validate: validate,
      child :  TextFormField(

        onChanged: (value){ setState(() {
          widget.text = value;
          if(widget.text.isEmpty){
            setState(() {
              validate = "заполните поле";
            });
            widget.validate(false);
          } else if(!widget.text.contains('@') && widget.type == "email") {
            setState(() {
              validate = "неправильный email";
            });
            widget.validate(false);
          } else {
            setState(() {
              validate = '';
            });
            widget.validate(true);
          }
        });
        widget.onChange(widget.text);
        },
        obscureText: widget.type == "Password" && show == false ? true : false,
        validator: (String? value){},
        cursorColor: const Color(0xFF6F35A5),
        decoration: InputDecoration(
          hintText: widget.text,
          icon: widget.icon != null ? widget.icon : const Icon(
            Icons.lock,
            color: const Color(0xFF6F35A5),
          ),
          suffixIcon: widget.type == "Password" ? GestureDetector(
            onTap: (){ setState(() {
              show = !show;
            }); },

             child: !show ? const Icon(
              Icons.visibility,
              color: Color(0xFF6F35A5),
            ) : const Icon( Icons.visibility_off, color: Color(0xD0713DA0),),
          ) : null,
          border: InputBorder.none,
        ),
      ),
    );
  }
}


class TextFieldContainer extends StatelessWidget {
  final Widget child;
  String validate;
  TextFieldContainer({
    required this.child,
    required this.validate
  }) : super();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          width: size.width * 0.8,
          decoration: BoxDecoration(
            color: const Color(0xFFF1E6FF),
            borderRadius: BorderRadius.circular(29),
          ),
          child: child,
        ),
        Row(
          children: [
            const SizedBox(width: 10),
            AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: validate.isNotEmpty ? 1 : 0,
                child: Text(validate, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w400, fontSize: 16))),
          ],
        )
      ],
    );
  }
}