import 'package:flutter/material.dart';
import 'package:strawberry/period/period_repository.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key, required this.repository});

  final PeriodRepository repository;

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<DateTime> periods = [];

  void _onDayLongPressed(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        if (periods.contains(selectedDay)) {
          periods.remove(selectedDay);
        } else {
          periods.add(selectedDay);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      firstDay: DateTime.utc(1970),
      lastDay: DateTime.utc(2100),
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.monday,
      selectedDayPredicate: (day) {
        // Use `selectedDayPredicate` to determine which day is currently selected.
        // If this returns true, then `day` will be marked as selected.

        // Using `isSameDay` is recommended to disregard
        // the time-part of compared DateTime objects.
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          // Call `setState()` when updating the selected day
          setState(() {
            _selectedDay = selectedDay;
          });
        }
      },
      onDayLongPressed: _onDayLongPressed,
      onPageChanged: (focusedDay) {
        // No need to call `setState()` here
        _focusedDay = focusedDay;
      },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          for (DateTime d in periods) {
            if (isSameDay(day, d)) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
          }
          return null;
        },
      ),
    );
  }
}
