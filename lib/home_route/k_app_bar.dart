import 'package:flutter/material.dart';

import 'button_chat.dart';

class KAppBar extends AppBar {
  KAppBar({Key? key, IconData? leadingIcon, Function()? leadingOnPressed})
      : assert((leadingIcon != null && leadingOnPressed != null) ||
            (leadingIcon == null && leadingOnPressed == null)),
        super(
          key: key,
          leading: IconButton(
            icon: Icon(
              leadingIcon,
            ),
            onPressed: leadingOnPressed,
          ),
          actions: const [
            ButtonChat(),
          ],
        );
}
