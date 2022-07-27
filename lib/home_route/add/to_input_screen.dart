import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/home_route/add/add_bloc.dart';
import 'package:on_call_work/widget/k_button.dart';
import 'package:on_call_work/widget/k_text.dart';
import 'package:on_call_work/widget/k_user_input.dart';

import '../../helper/date_helper.dart';

class ToInputScreen extends StatefulWidget {
  final AddToState state;

  const ToInputScreen({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ToInputScreenState();
}

class _ToInputScreenState extends State<ToInputScreen> {
  final TextEditingController dateTextEditingController =
      TextEditingController();
  final TextEditingController timeTextEditingController =
      TextEditingController();

  DateTime? dateTime;
  TimeOfDay? timeOfDay;

  bool error = false;

  @override
  void initState() {
    if (widget.state.to != null) {
      dateTime = DateTime(
        widget.state.to!.year,
        widget.state.to!.month,
        widget.state.to!.day,
      );
      timeOfDay = TimeOfDay(
        hour: widget.state.to!.hour,
        minute: widget.state.to!.minute,
      );

      dateTextEditingController.text =
          DateHelper.dateToString(dateTime!).split(' ')[0];

      timeTextEditingController.text =
          '${timeOfDay!.hour}:${timeOfDay!.minute < 10 ? '0${timeOfDay!.minute}' : timeOfDay!.minute}';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: KText(
            'Enter when the work shift ends',
            errorText: 'Work shift cannot end before starting',
            isError: widget.state.isDateToBeforeFrom,
          ),
        ),
        KUserInput(
          readOnly: true,
          onTap: () => _selectDate(context),
          prefixIcon: Icons.calendar_month,
          hintText: 'Start date',
          isError: error && dateTime == null,
          errorText: 'Please select a date',
          controller: dateTextEditingController,
        ),
        const Spacer(
          flex: 1,
        ),
        KUserInput(
          readOnly: true,
          onTap: () => _selectTime(context),
          prefixIcon: Icons.watch_later_outlined,
          hintText: 'Start time',
          errorText: 'Please select a time',
          isError: error && timeOfDay == null,
          controller: timeTextEditingController,
        ),
        const Spacer(
          flex: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: KButton(
            onPressed: _onPressed,
            text: 'Next',
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(
        days: 3650,
      )),
    );

    if (date != null) {
      dateTime = date;
      dateTextEditingController.text =
          DateHelper.dateToString(date).split(' ')[0];

      setState(() => error = false);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (timeOfDay != null) {
      this.timeOfDay = timeOfDay;
      timeTextEditingController.text =
          '${timeOfDay.hour}:${timeOfDay.minute < 10 ? '0${timeOfDay.minute}' : timeOfDay.minute}';

      setState(() => error = false);
    }
  }

  _onPressed() {
    if (dateTime != null || timeOfDay != null) {
      context.read<AddBloc>().add(AddToEvent(
          to: dateTime!.add(
              Duration(hours: timeOfDay!.hour, minutes: timeOfDay!.minute))));
      setState(() => error = false);
    } else {
      setState(() => error = true);
    }
  }
}
