import 'package:flutter/material.dart';
import 'package:strawberry/calendar/daily_info_page.dart';
import 'package:strawberry/model/daily_info.dart';
import 'package:strawberry/notification/notifications_service.dart';
import 'package:strawberry/notification/notification_id_constants.dart';
import 'package:strawberry/model/day_type.dart';
import 'package:strawberry/period/repository/period_repository.dart';
import 'package:strawberry/period/service/period_service.dart';
import 'package:strawberry/settings/settings_service.dart';
import 'package:strawberry/utils/colors.dart';
import 'package:strawberry/utils/snackbar.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({
    super.key,
    required this.periodRepository,
    required this.service,
    required this.notificationService,
    required this.settings,
  });

  final PeriodRepository periodRepository;
  final PeriodService service;
  final NotificationService notificationService;
  final SettingsService settings;

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _displayDay;
  DailyInfo? _displayDayInfo;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.periodRepository.getPeriodDates(),
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
            widget.service.calculateStatsFromPeriods(periodDates);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _makeCalendar(periodDates),
                _divider(),
                _makeInfoPage(),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget _makeInfoPage() {
    if (_displayDay == null) {
      return const Text("No day selected");
    } else {
      _displayDayInfo ??= DailyInfo.create(_displayDay!, widget.settings.getTemperature(), widget.settings.getBirthControl());
      return DailyInfoPage(widget.periodRepository, _displayDayInfo!);
    }
  }

  TableCalendar _makeCalendar(List<DateTime> periods) {
    double defaultTemperature = widget.settings.getTemperature();
    bool defaultBirthControl = widget.settings.getBirthControl();
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
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) async {
        await widget.periodRepository
            .getInfoForDate(selectedDay, defaultTemperature, defaultBirthControl)
            .then((value) => _displayDayInfo = value);
        setState(() {
          _displayDay = selectedDay;
        });
      },
      onDayLongPressed: (DateTime selectedDay, DateTime focusedDay) async {
        String message = "";
        await widget.periodRepository
            .getInfoForDate(selectedDay, defaultTemperature, defaultBirthControl)
            .then((value) => _changePeriodStatus(value));
        if (periods.contains(selectedDay)) {
          await widget.periodRepository.deleteInfoForDate(selectedDay);
          message = "Removed period";
        } else {
          await widget.periodRepository
              .insertInfoForDay(DailyInfo.create(selectedDay, defaultTemperature, defaultBirthControl));
          message = "Added period";
        }
        setState(() {
          showSnackBar(context, message);
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
          if (isSameDay(day, DateTime.now()) || isSameDay(day, _displayDay)) {
            return _markDay(day, Colors.white, Colors.black);
          }

          return null;
        },
      ),
    );
  }

  void _changePeriodStatus(DailyInfo info) {
    info.hadPeriod = !info.hadPeriod;
    widget.periodRepository.insertInfoForDay(info);
  }

  Container _markDay(DateTime day, Color dayColor, Color numberColor) {
    var borderColor = dayColor;
    if (isSameDay(day, DateTime.now())) {
      borderColor = CUSTOM_BLUE;
    }
    if (isSameDay(day, _displayDay)) {
      borderColor = Colors.green;
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

  void _setPeriodNotifications(Map<DateTime, DateType> futurePeriods) {
    bool setAnyNotifications = widget.service.getPeriodNotifications();
    bool setCurrentPeriodNotifications =
        widget.service.setCurrentPeriodNotifications();
    if (futurePeriods.isNotEmpty) {
      Map<DateTime, DateType> localDates = futurePeriods.map(
          (key, value) => MapEntry(_parseNotificationDateTime(key), value));
      DateTime nextPeriodStart = localDates.entries
          .firstWhere(
              (element) => element.value == DateType.START_OF_NEXT_PERIOD)
          .key;
      _setNewNextPeriodStartNotification(nextPeriodStart, setAnyNotifications);

      List<DateTime> periodContinuations = localDates.entries
          .where((element) => element.value == DateType.IN_CURRENT_PERIOD)
          .map((e) => e.key)
          .toList();
      _setNewPeriodEndCheckNotification(periodContinuations,
          setAnyNotifications && setCurrentPeriodNotifications);
    }
  }

  DateTime _parseNotificationDateTime(DateTime date) {
    TimeOfDay time = widget.settings.getNotificationTime();
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _setNewNextPeriodStartNotification(
      DateTime nextPeriodStart, bool addNew) async {
    await widget.notificationService.clearOldPeriodStartNotifications();
    if (addNew) {
      await widget.notificationService.showScheduledNotification(
          id: PERIOD_START_NOTIFICATION_ID,
          title: "Period start",
          body: "Your period is scheduled to start today",
          date: nextPeriodStart);
    }
  }

  Future<void> _setNewPeriodEndCheckNotification(
      List<DateTime> dates, bool addNew) async {
    await widget.notificationService.clearOldPeriodEndCheckNotifications();
    if (addNew) {
      for (int i = 0; i < dates.length; i++) {
        DateTime date = dates[i];
        await widget.notificationService.showScheduledNotification(
            id: PERIOD_END_NOTIFICATION_ID_FLOOR + i,
            title: "Mark your period",
            body: "Do you still have your period today?",
            date: date);
      }
    }
  }

  Divider _divider() {
    return const Divider(
      color: CUSTOM_YELLOW,
      thickness: 2,
    );
  }
}
