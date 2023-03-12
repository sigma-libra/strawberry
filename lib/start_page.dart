import 'package:flutter/material.dart';
import 'package:strawberry/calendar/calendar_page.dart';
import 'package:strawberry/menu/alerts_page.dart';
import 'package:strawberry/menu/history_page.dart';
import 'package:strawberry/menu/settings_page.dart';
import 'package:strawberry/period/repository/period_repository.dart';
import 'package:strawberry/period/service/period_service.dart';
import 'package:strawberry/settings/settings_service.dart';

import 'notification/notifications_service.dart';

class StartPage extends StatefulWidget {
  const StartPage({
    super.key,
    required this.repository,
    required this.service,
    required this.notificationService,
    required this.settings,
  });

  final PeriodRepository repository;
  final PeriodService service;
  final NotificationService notificationService;
  final SettingsService settings;

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
                // const PopupMenuItem<int>(
                //   value: 1,
                //   child: Text("Alerts"),
                // ),
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
              // } else if (value == 1) {
              //   _showAlerts(context);
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
          settings: widget.settings,
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
                settings: widget.settings,
              )),
    ).then((_) => setState(() {}));
  }
}
