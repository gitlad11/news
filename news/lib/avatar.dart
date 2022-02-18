import 'dart:io';

import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final bool isEdit;
  final bool avatar;
  final VoidCallback onClicked;
  const ProfileWidget({
    Key? key,
    required this.imagePath,
    this.isEdit = false,
    this.avatar = false,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
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
    print(avatar);
    final image = AssetImage(imagePath);
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
        child: !avatar ? Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 160,
          height: 160,
          child: InkWell(onTap: onClicked),
        ) : Image.network(imagePath, width: 160, height: 160, fit: BoxFit.cover),
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
        isEdit ? Icons.add_a_photo : Icons.edit,
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
        onTap: (){ onClicked(); },
        child: ClipOval(
          child: Container(
            padding: EdgeInsets.all(all),
            color: color,
            child: child,
          ),
        ),
      );
}