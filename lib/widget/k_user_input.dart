import 'package:flutter/material.dart';

class KUserInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final String? errorText;
  final bool obscureText;

  const KUserInput({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    this.errorText,
    this.obscureText = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
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
                    fontStyle: FontStyle.italic),
              ),
              keyboardType: keyboardType,
              obscureText: obscureText,
            ),
          )),
    );
  }
}
