import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strawberry/calendar/calendar_page.dart';
import 'package:strawberry/menu/alerts_page.dart';
import 'package:strawberry/menu/history_page.dart';
import 'package:strawberry/menu/settings_page.dart';
import 'package:strawberry/notification/local_notifications_service.dart';
import 'package:strawberry/period/repository/period_repository.dart';
import 'package:strawberry/period/service/period_service.dart';
import 'package:strawberry/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences configs = await SharedPreferences.getInstance();
  PeriodService periodService = PeriodService(configs);
  PeriodRepository repository = PeriodRepository();
  await repository.initDatabase();
  final LocalNotificationService notificationService =
      LocalNotificationService();
  await notificationService.initialize();
  initializeDateFormatting().then((_) => runApp(MyApp(
        repository: repository,
        periodService: periodService,
        notificationService: notificationService,
        configs: configs,
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.repository,
    required this.periodService,
    required this.notificationService,
    required this.configs,
  });

  final PeriodRepository repository;
  final PeriodService periodService;
  final LocalNotificationService notificationService;
  final SharedPreferences configs;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strawberry',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(color: CUSTOM_BLUE),
      ),
      home: StartPage(
        repository: repository,
        service: periodService,
        notificationService: notificationService,
        configs: configs,
      ),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({
    super.key,
    required this.repository,
    required this.service,
    required this.notificationService,
    required this.configs,
  });

  final PeriodRepository repository;
  final PeriodService service;
  final LocalNotificationService notificationService;
  final SharedPreferences configs;

  @override
  StartPageState createState() => StartPageState();
}

class StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Strawberry'),
          actions: [
            PopupMenuButton(
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("History"),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("Alerts"),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Text("Settings"),
                ),
                const PopupMenuItem<int>(
                  value: 3,
                  child: Text("Delete All"),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                _showHistory(context);
              } else if (value == 1) {
                _showAlerts(context);
              } else if (value == 2) {
                _showSettings(context);
              } else if (value == 3) {
                _delete(context);
              }
            }),
          ],
        ),
        body: Calendar(
          repository: widget.repository,
          service: widget.service,
          notificationService: widget.notificationService,
          configs: widget.configs,
        ));
  }

  void _delete(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: const Text(
                'Are you sure to delete all data? This action cannot be reversed.'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    // Remove the box
                    setState(() {
                      widget.repository.truncate();
                      widget.notificationService.clearAll();
                    });

                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  void _showHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HistoryPage(
                repository: widget.repository,
                service: widget.service,
              )),
    );
  }

  void _showAlerts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AlertsPage(
                notificationService: widget.notificationService,
              )),
    );
  }

  void _showSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SettingsPage(
                notificationService: widget.notificationService,
                configs: widget.configs,
              )),
    ).then((_) => setState(() {}));
  }
}
