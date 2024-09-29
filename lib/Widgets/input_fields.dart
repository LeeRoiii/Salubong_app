import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' show DateFormat;


class DateField extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onTap;

  const DateField({super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DATE & TIME',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: CupertinoColors.systemGrey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                DateFormat.yMMMMd().format(selectedDate),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ReminderField extends StatelessWidget {
  final TextEditingController reminderController;

  const ReminderField({super.key, required this.reminderController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'REMINDERS',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        CupertinoTextField(
          controller: reminderController,
          placeholder: 'Optional Enter reminder...',
          padding: const EdgeInsets.all(16.0),
          style: const TextStyle(fontSize: 18),
          maxLength: 30,
        ),
      ],
    );
  }
}

class EventTitleField extends StatelessWidget {
  final TextEditingController eventNameController;

  const EventTitleField({super.key, required this.eventNameController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TITLE',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        CupertinoTextField(
          controller: eventNameController,
          placeholder: 'Birthday, Vacation, Christmas...',
          padding: const EdgeInsets.all(16.0),
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}