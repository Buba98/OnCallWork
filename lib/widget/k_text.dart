import 'package:flutter/material.dart';

class KText extends StatelessWidget {
  final String text;
  final bool isError;
  final String? errorText;

  const KText(this.text, {Key? key, this.isError = false, this.errorText})
      : assert(!isError || (errorText != null && isError)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      isError ? errorText! : text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.onBackground,
      ),
    );
  }
}
