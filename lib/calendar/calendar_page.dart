import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:strawberry/notification/local_notifications_service.dart';
import 'package:strawberry/period/model/day_type.dart';
import 'package:strawberry/period/model/period.dart';
import 'package:strawberry/period/model/period_day.dart';
import 'package:strawberry/period/repository/period_repository.dart';
import 'package:strawberry/period/service/period_service.dart';
import 'package:strawberry/period/model/stats.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils/colors.dart';

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

  static const int NOTIFICATION_HOUR = 7;

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
            List<DateTime> periodDates =
                snapshot.requireData.toList(growable: true);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _makeCalendar(periodDates),
                _makeStatsPage(periodDates),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget _makeCalendar(List<DateTime> periods) {
    return TableCalendar(
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      firstDay: DateTime.utc(2000),
      lastDay: DateTime.utc(2100),
      focusedDay: _focusedDay,
      currentDay: DateTime.utc(2000),
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.monday,
      sixWeekMonthsEnforced: true,
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
          // DateTime date = DateTime.now().add(const Duration(seconds: 20));
          // widget.notificationService.showScheduledNotification(
          //   id: testId,
          //   title: "Test notification",
          //   body: "Testing after 20 seconds: $date",
          //   date: date,
          // );
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
              return _markDay(day, CUSTOM_RED, Colors.white);
            }
          }
          Map<DateTime, DateType> futurePeriods =
              widget.service.getPredictedPeriods(12, periods, DateTime.now());

          _setPeriodNotifications(futurePeriods);

          for (DateTime d in futurePeriods.keys) {
            if (isSameDay(day, d)) {
              return _markDay(day, CUSTOM_YELLOW, Colors.black);
            }
          }
          if (isSameDay(day, DateTime.now())) {
            return _markDay(day, Colors.white, Colors.black);
          }

          return null;
        },
      ),
    );
  }

  Container _markDay(DateTime day, Color dayColor, Color numberColor) {
    var borderColor = dayColor;
    if (isSameDay(day, DateTime.now())) {
      borderColor = CUSTOM_BLUE;
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

  Widget _makeStatsPage(List<DateTime> periodDays) {
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

  void _setPeriodNotifications(Map<DateTime, DateType> futurePeriods) {
    if (futurePeriods.isNotEmpty) {
      Map<DateTime, DateType> localDates = futurePeriods.map((key, value) =>
          MapEntry(DateTime(key.year, key.month, key.day, NOTIFICATION_HOUR), value));
      DateTime nextPeriodStart = localDates.entries
          .firstWhere(
              (element) => element.value == DateType.START_OF_NEXT_PERIOD)
          .key;
      _setNewNextPeriodStartNotification(nextPeriodStart);

      List<DateTime> periodContinuations = localDates.entries
          .where((element) => element.value == DateType.IN_CURRENT_PERIOD)
          .map((e) => e.key)
          .toList();
      _setNewPeriodEndCheckNotification(periodContinuations);
    }
  }

  Future<void> _setNewNextPeriodStartNotification(
      DateTime nextPeriodStart) async {
    await widget.notificationService.clearOldPeriodStartNotifications();
    await widget.notificationService.showScheduledNotification(
        id: periodStartId,
        title: "Period start",
        body: "Your period is scheduled to start today",
        date: nextPeriodStart);
  }

  Future<void> _setNewPeriodEndCheckNotification(List<DateTime> dates) async {
    await widget.notificationService.clearOldPeriodEndCheckNotifications();
    for (int i = 0; i < dates.length; i++) {
      DateTime date = dates[i];
      await widget.notificationService.showScheduledNotification(
          id: periodEndCheckIdRange + i,
          title: "Period ended?",
          body: "Do you still have your period today ($date)?",
          date: date);
    }
  }
}
