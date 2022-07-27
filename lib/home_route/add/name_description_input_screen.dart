import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/home_route/add/add_bloc.dart';
import 'package:on_call_work/widget/k_button.dart';
import 'package:on_call_work/widget/k_text.dart';
import 'package:on_call_work/widget/k_user_input.dart';

class NameDescriptionInputScreen extends StatefulWidget {
  final AddInitState state;

  const NameDescriptionInputScreen({
    Key? key,
    required this.state,
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
  void initState() {
    if (widget.state.name != null) {
      nameTextEditingController.text = widget.state.name!;
    }
    if (widget.state.description != null) {
      descriptionTextEditingController.text = widget.state.description!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: KText('Enter name and description of your job offer'),
        ),
        KUserInput(
          controller: nameTextEditingController,
          hintText: 'Name',
          errorText: widget.state.isNameMissing ? 'Name is required' : null,
        ),
        const Spacer(
          flex: 1,
        ),
        KUserInput(
          controller: descriptionTextEditingController,
          hintText: 'Description',
          errorText: widget.state.isDescriptionMissing
              ? 'Description is required'
              : null,
        ),
        const Spacer(
          flex: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: KButton(
            text: 'Next',
            onPressed: () => context.read<AddBloc>().add(
                  AddNameDescriptionEvent(
                    name: nameTextEditingController.text,
                    description: descriptionTextEditingController.text,
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
