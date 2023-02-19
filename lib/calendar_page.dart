import 'package:flutter/material.dart';
import 'package:strawberry/local_notifications_service.dart';
import 'package:strawberry/period/period.dart';
import 'package:strawberry/period/period_day.dart';
import 'package:strawberry/period/period_repository.dart';
import 'package:strawberry/period/period_service.dart';
import 'package:strawberry/period/stats.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar(
      {super.key,
      required this.repository,
      required this.service,
      required this.notificationService});

  final PeriodRepository repository;
  final PeriodService service;
  final LocalNotificationService notificationService;

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now().add(const Duration(days: 4));
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
              style: Theme.of(context).textTheme.displayLarge,
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
      currentDay: DateTime.utc(1970),
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
          // widget.notificationService.showNotification(
          //     id: testId,
          //     title: "Test notification",
          //     body: "Testing on insert/delete");
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
              return markDay(day, Colors.red, Colors.white);
            }
          }
          Map<DateTime, bool> futurePeriods =
              widget.service.getPredictedPeriods(12, periods, DateTime.now());

          for (DateTime d in futurePeriods.keys) {
            if (isSameDay(day, d)) {
              return markDay(day, Colors.amberAccent, Colors.black);
            }
          }
          if (isSameDay(day, DateTime.now())) {
            return markDay(day, Colors.white, Colors.black);
          }
          if (futurePeriods.isNotEmpty) {
            DateTime nextPeriodStart = futurePeriods.entries
                .firstWhere((element) => element.value)
                .key
                .add(const Duration(hours: 7));
            setNewNextPeriodStartNotification(nextPeriodStart);

            List<DateTime> periodContinuations = futurePeriods.entries
                .where((element) => !element.value)
                .map((e) => e.key)
                .toList();
            setNewPeriodEndCheckNotification(periodContinuations);
          }

          return null;
        },
      ),
    );
  }

  Container markDay(DateTime day, Color dayColor, Color numberColor) {
    var borderColor = dayColor;
    if (isSameDay(day, DateTime.now())) {
      borderColor = Colors.blueAccent;
    }
    return Container(
      decoration: BoxDecoration(
          color: dayColor, border: Border.all(color: borderColor, width: 5.0)),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(color: numberColor),
        ),
      ),
    );
  }

  Widget makeStatsPage(List<DateTime> periodDays) {
    List<Period> periods = widget.service.getSortedPeriods(periodDays);
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

  void setNewNextPeriodStartNotification(DateTime nextPeriodStart) {
    widget.notificationService.clearOldPeriodStartNotifications();
    widget.notificationService.showScheduledNotification(
        id: periodStartId,
        title: "Period start",
        body: "Your period is scheduled to start today",
        date: nextPeriodStart);
  }

  void setNewPeriodEndCheckNotification(List<DateTime> dates) {
    widget.notificationService.clearOldPeriodEndCheckNotifications();
    for (DateTime date in dates) {
      widget.notificationService.showScheduledNotification(
          id: periodEndCheckId,
          title: "Period ended?",
          body: "Do you still have your period today?",
          date: date);
    }
  }
}
