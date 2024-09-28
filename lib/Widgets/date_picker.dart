

import 'package:flutter/cupertino.dart';

class DatePickerWidget extends StatelessWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  const DatePickerWidget({super.key,
    required this.initialDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: CupertinoColors.white, // Set a background color
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16)), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: initialDate,
        onDateTimeChanged: onDateChanged,
      ),
    );
  }
}
