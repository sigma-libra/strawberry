import 'package:flutter/material.dart';
import 'package:strawberry/period/period.dart';
import 'package:strawberry/period/period_day.dart';
import 'package:strawberry/period/period_repository.dart';
import 'package:strawberry/period/period_service.dart';
import 'package:strawberry/period/stats.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key, required this.repository, required this.service});

  final PeriodRepository repository;
  final PeriodService service;

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.repository.getPeriodDates(),
        builder:
            (BuildContext context, AsyncSnapshot<List<DateTime>> snapshot) {
          if (snapshot.hasError) {
            return Text(
              'There was an error :(',
              style: Theme.of(context).textTheme.headline1,
            );
          } else if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                makeCalendar(snapshot.requireData.toList(growable: true)),
                makeStatsPage(snapshot.requireData.toList()),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget makeCalendar(List<DateTime> periods) {
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
      onDayLongPressed: (DateTime selectedDay, DateTime focusedDay) {
        setState(() {
          if (periods.contains(selectedDay)) {
            widget.repository.deletePeriod(selectedDay);
          } else {
            widget.repository.insertPeriod(PeriodDay.create(selectedDay));
          }
        });
      },
      onPageChanged: (focusedDay) {
        // No need to call `setState()` here
        _focusedDay = focusedDay;
      },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          for (DateTime d in periods) {
            if (isSameDay(day, d)) {
              return markDay(day, Colors.red);
            }
          }
          List<DateTime> futurePeriods =
              widget.service.getPredictedPeriods(12, periods);
          for (DateTime d in futurePeriods) {
            if (isSameDay(day, d)) {
              return markDay(day, Colors.grey);
            }
          }
          return null;
        },
      ),
    );
  }

  Container markDay(DateTime day, MaterialColor dayColor) {
    return Container(
      decoration: BoxDecoration(
        color: dayColor,
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget makeStatsPage(List<DateTime> periodDays) {
    List<Period> periods = widget.service.getPeriods(periodDays);
    Stats stats = widget.service.getStats(periods);
    return Flexible(
        child: ListView(
      children: [
        const ListTile(
          title: Text("Stats"),
        ),
        ListTile(
          leading: const Text("Cycle Length"),
          trailing: Text("${stats.cycleLength}"),
        ),
        ListTile(
          leading: const Text("Period Length"),
          trailing: Text("${stats.periodLength}"),
        )
      ],
    ));
  }
}
