import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProfilePicture extends StatefulWidget {
  final Future<String?> pictureUrl;
  final Uint8List? newPicture;

  const ProfilePicture({
    Key? key,
    required this.pictureUrl,
    required this.newPicture,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  void initState() {
    if (widget.newPicture != null) {
      setState(
        () => imageProvider = MemoryImage(widget.newPicture!),
      );
    } else {
      widget.pictureUrl.then((value) {
        if (value != null) {
          setState(
            () => imageProvider = NetworkImage(value),
          );
        }
      });
    }
    super.initState();
  }

  ImageProvider imageProvider =
      const AssetImage('assets/images/profile_picture_placeholder.png');

  @override
  Widget build(BuildContext context) {

    print(1);

    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        border: Border.all(
          width: 4,
          color: Colors.white,
        ),
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 10,
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 10),
          )
        ],
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: imageProvider,
        ),
      ),
    );
  }
}
