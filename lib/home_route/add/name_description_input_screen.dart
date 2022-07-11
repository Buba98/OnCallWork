import 'package:flutter/material.dart';

class NameDescriptionInputScreen extends StatefulWidget {
  final Function(String, String) onPressed;

  const NameDescriptionInputScreen({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NameDescriptionInputScreenState();
}

class _NameDescriptionInputScreenState
    extends State<NameDescriptionInputScreen> {
  final TextEditingController nameTextEditingController =
      TextEditingController();

  final TextEditingController descriptionTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text('Enter name and description of your job offer'),
        ),
        TextField(
          controller: nameTextEditingController,
          decoration: const InputDecoration(
            labelText: 'Name',
          ),
        ),
        const Spacer(
          flex: 1,
        ),
        TextField(
          controller: descriptionTextEditingController,
          decoration: const InputDecoration(
            labelText: 'Description',
          ),
        ),
        const Spacer(
          flex: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: ElevatedButton(
            onPressed: _onPressed,
            child: const Text('Next'),
          ),
        ),
      ],
    );
  }

  void _onPressed() {
    if (nameTextEditingController.text.isNotEmpty &&
        descriptionTextEditingController.text.isNotEmpty) {
      widget.onPressed(nameTextEditingController.text,
          descriptionTextEditingController.text);
    }
  }
}
