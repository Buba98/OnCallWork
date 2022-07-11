import 'package:flutter/material.dart';

class FromInputScreen extends StatefulWidget {
  final Function(DateTime) onPressed;

  const FromInputScreen({
    Key? key,
    required this.onPressed,
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: error
              ? const Text('Shift cannot start in the past')
              : const Text('Enter when the work shift starts'),
        ),
        TextField(
          readOnly: true,
          onTap: () => _selectDate(context),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.calendar_month),
            labelText: 'Start date',
          ),
          controller: dateTextEditingController,
        ),
        const Spacer(
          flex: 1,
        ),
        TextField(
          readOnly: true,
          onTap: () => _selectTime(context),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.watch_later_outlined),
            labelText: 'Start date',
          ),
          controller: timeTextEditingController,
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
      dateTextEditingController.text = date.toString().split(' ')[0];
      if (timeOfDay != null) {
        DateTime dateTime = this.dateTime!.add(
              Duration(
                hours: timeOfDay!.hour,
                minutes: timeOfDay!.minute,
              ),
            );

        if (dateTime.isBefore(DateTime.now())) {
          setState(() => error = true);
        } else {
          setState(() => error = false);
        }
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (timeOfDay != null) {
      this.timeOfDay = timeOfDay;
      timeTextEditingController.text = '${timeOfDay.hour}:${timeOfDay.minute}';
      if (dateTime != null) {
        DateTime dateTime = this.dateTime!.add(
              Duration(
                hours: timeOfDay.hour,
                minutes: timeOfDay.minute,
              ),
            );

        if (dateTime.isBefore(DateTime.now())) {
          setState(() => error = true);
        } else {
          setState(() => error = false);
        }
      }
    }
  }

  void _onPressed() {
    if (dateTime != null && timeOfDay != null && !error) {
      widget.onPressed(
        dateTime!.add(
          Duration(
            hours: timeOfDay!.hour,
            minutes: timeOfDay!.minute,
          ),
        ),
      );
    }
  }
}
