// lib/insights/date_selector.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatelessWidget {
  final List<DateTime> weekDates;
  final DateTime selectedDate;
  final void Function(DateTime) onDateSelected;

  const DateSelector({
    Key? key,
    required this.weekDates,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(7, (index) {
        final date = weekDates[index];
        final isSelected = date.day == selectedDate.day &&
            date.month == selectedDate.month &&
            date.year == selectedDate.year;

        return GestureDetector(
          onTap: () => onDateSelected(date),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue[600] : Colors.blue[300],
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              DateFormat.E().format(date)[0],
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
    );
  }
}
