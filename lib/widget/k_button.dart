import 'package:flutter/material.dart';

class KButton extends StatelessWidget {
  final String text;
  final Color colorBackground;
  final Color colorForeground;
  final Function() onPressed;

  const KButton({
    Key? key,
    required this.text,
    this.colorBackground = Colors.indigo,
    this.colorForeground = Colors.white,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.resolveWith((states) => colorBackground),
          shape: MaterialStateProperty.resolveWith(
            (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: colorForeground,
          ),
        ),
      ),
    );
  }
}
