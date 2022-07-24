import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KUserInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final String? errorText;
  final bool obscureText;
  final int? maxLines;

  const KUserInput({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    this.errorText,
    this.obscureText = false,
    super.key,
  }) : maxLines = keyboardType == TextInputType.multiline ? null : 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 3),
        child: TextField(
          style: const TextStyle(color: Colors.white),
          controller: controller,
          decoration: InputDecoration(
            errorText: errorText,
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
          obscureText: obscureText,
        ),
      )),
    );
  }
}
