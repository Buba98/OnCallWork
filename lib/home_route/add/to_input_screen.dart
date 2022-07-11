import 'package:flutter/material.dart';

class ToInputScreen extends StatefulWidget {
  final Function(DateTime) onPressed;
  final DateTime from;

  const ToInputScreen({
    Key? key,
    required this.onPressed,
    required this.from,
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: error
              ? Text(
                  'Shift cannot end before starting',
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                  ),
                )
              : const Text('Enter when the work shift ends'),
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
      initialDate: widget.from,
      firstDate: widget.from,
      lastDate: widget.from.add(const Duration(
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

        if (dateTime.isBefore(widget.from)) {
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

        if (dateTime.isBefore(widget.from)) {
          setState(() => error = true);
        } else {
          setState(() => error = false);
        }
      }
    }
  }

  void _onPressed() {
    if (dateTime != null && timeOfDay != null && !error) {
      DateTime dateTime = this.dateTime!.add(
            Duration(
              hours: timeOfDay!.hour,
              minutes: timeOfDay!.minute,
            ),
          );
      widget.onPressed(dateTime);
    }
  }
}
