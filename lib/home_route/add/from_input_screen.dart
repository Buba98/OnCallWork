import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/helper/date_helper.dart';
import 'package:on_call_work/home_route/add/add_bloc.dart';
import 'package:on_call_work/widget/k_button.dart';
import 'package:on_call_work/widget/k_text.dart';
import 'package:on_call_work/widget/k_user_input.dart';

class FromInputScreen extends StatefulWidget {
  final AddFromState state;

  const FromInputScreen({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FromInputScreenState();
}

class _FromInputScreenState extends State<FromInputScreen> {
  final TextEditingController dateTextEditingController =
      TextEditingController();
  final TextEditingController timeTextEditingController =
      TextEditingController();

  DateTime? dateTime;
  TimeOfDay? timeOfDay;

  bool error = false;

  @override
  void initState() {
    if (widget.state.from != null) {
      dateTime = DateTime(
        widget.state.from!.year,
        widget.state.from!.month,
        widget.state.from!.day,
      );
      timeOfDay = TimeOfDay(
        hour: widget.state.from!.hour,
        minute: widget.state.from!.minute,
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
            'Enter when the work shift starts',
            errorText: 'Work shift cannot start before now',
            isError: widget.state.isDateFromBeforeNow,
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
          isError: error && timeOfDay == null,
          errorText: 'Please select a time',
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
      context.read<AddBloc>().add(AddFromEvent(
          from: dateTime!.add(
              Duration(hours: timeOfDay!.hour, minutes: timeOfDay!.minute))));
      setState(() => error = false);
    } else {
      setState(() => error = true);
    }
  }
}
