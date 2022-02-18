import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  List following;
  List liked;

  Info(this.following, this.liked);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      buildButton(context, widget.following.length.toString(), 'Following', Icons.person_rounded),
      buildDivider(),
      buildButton(context, widget.liked.length.toString(), 'likes',  Icons.favorite),
    ],
  );

  Widget buildDivider() => Container(
    height: 24,
    child: const VerticalDivider(),
  );

  Widget buildButton(BuildContext context, String value, String text, icon) =>
      MaterialButton(
        ///USER LIKES AND FOLLOWING WIDGET
        padding: const EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
              ),
             const SizedBox(width: 2),
              Icon(icon, color: Colors.redAccent, size: 25)],
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      );
}