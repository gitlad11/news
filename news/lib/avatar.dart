import 'dart:io';

import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  final String imagePath;
  final bool isEdit;
  late bool isUser;
  final bool avatar;
  final VoidCallback onClicked;
  ProfileWidget({
    Key? key,
    required this.imagePath,
    this.isEdit = false,
    this.avatar = false,
    this.isUser = false,
    required this.onClicked,
  }) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late bool animation = false;

  animate() {
    setState(() {
      animation = true;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), animate);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          AnimatedOpacity(
              opacity: animation ? 1 : 0,
              duration: const Duration(milliseconds: 600),
              child: buildImage()
          ),
          this.widget.isUser ?
          SizedBox() :
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final image = AssetImage(widget.imagePath);
    return ClipOval(
      child : Container(
        color: Colors.white,
        width: 163,
        height: 163,
        padding: const EdgeInsets.all(2),
        child:
      ClipOval(
      child: Material(
        color: Colors.transparent,
        child: !widget.avatar ? Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 160,
          height: 160,
          child: InkWell(onTap: widget.onClicked),
        ) : Image.network(widget.imagePath, width: 160, height: 160, fit: BoxFit.cover),
      ),
    )
      )
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
    color: Colors.white,
    all: 2,
    child: buildCircle(
      color: color,
      all: 8,
      child: Icon(
        widget.isEdit ? Icons.add_a_photo : Icons.edit,
        color: Colors.white,
        size: 22,
      ),
    ),
  );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      GestureDetector(
        onTap: (){ widget.onClicked(); },
        child: ClipOval(
          child: Container(
            padding: EdgeInsets.all(all),
            color: color,
            child: child,
          ),
        ),
      );
}