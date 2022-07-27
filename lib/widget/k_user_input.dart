import 'package:flutter/material.dart';

class KUserInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final String? errorText;
  final bool obscureText;
  final int? maxLines;
  final bool readOnly;
  final Function()? onTap;
  final IconData? prefixIcon;
  final bool isError;

  const KUserInput({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.errorText,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.prefixIcon,
    this.isError = false,
    super.key,
  }) : maxLines = keyboardType == TextInputType.multiline ? null : 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: isError
                ? Border.all(
                    color: Theme.of(context).colorScheme.error,
                    width: 1,
                  )
                : null,
            color: Colors.blueGrey.shade200,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 3),
              child: TextField(
                onTap: onTap,
                readOnly: readOnly,
                style: const TextStyle(color: Colors.white),
                controller: controller,
                decoration: InputDecoration(
                  suffixIcon: isError ? const Icon(Icons.error) : null,
                  suffixIconColor: Theme.of(context).colorScheme.error,
                  prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
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
            ),
          ),
        ),
        if (isError)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 3,
              horizontal: 25,
            ),
            child: Text(
              errorText!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
      ],
    );
  }
}
