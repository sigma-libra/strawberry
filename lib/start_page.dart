import 'package:flutter/material.dart';
import 'package:strawberry/calendar/calendar_page.dart';
import 'package:strawberry/menu/alerts_page.dart';
import 'package:strawberry/menu/history_page.dart';
import 'package:strawberry/menu/settings_page.dart';
import 'package:strawberry/menu/stats_page.dart';
import 'package:strawberry/period/repository/period_repository.dart';
import 'package:strawberry/period/service/period_service.dart';
import 'package:strawberry/settings/settings_service.dart';
import 'package:strawberry/utils/snackbar.dart';
import 'package:strawberry/l10n/app_localizations.dart';

import 'notification/notifications_service.dart';

class StartPage extends StatefulWidget {
  const StartPage({
    super.key,
    required this.periodRepository,
    required this.periodService,
    required this.notificationService,
    required this.settings,
  });

  final PeriodRepository periodRepository;
  final PeriodService periodService;
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
          title: Text(AppLocalizations.of(context)!.appTitle),
          actions: [
            PopupMenuButton(
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text(AppLocalizations.of(context)!.history),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text(AppLocalizations.of(context)!.alerts),
                ),
                //PopupMenuItem<int>(
                //  value: 2,
                //  child: Text(AppLocalizations.of(context)!.stats),
                //),
                PopupMenuItem<int>(
                  value: 3,
                  child: Text(AppLocalizations.of(context)!.settings),
                ),
                PopupMenuItem<int>(
                  value: 4,
                  child: Text(AppLocalizations.of(context)!.deleteAll),
                ),
              ];
            }, onSelected: (value) async {
              switch (value) {
                case 0:
                  _showHistory(context);
                  break;
                case 1:
                  _showAlerts(context);
                  break;
                case 2:
                  _showStats(context);
                  break;
                case 3:
                  _showSettings(context);
                  break;
                case 4:
                  _delete(context);
                  break;
              }
            }),
          ],
        ),
        body: Calendar(
          periodRepository: widget.periodRepository,
          service: widget.periodService,
          notificationService: widget.notificationService,
          settings: widget.settings,
        ));
  }

  void _delete(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.pleaseConfirm),
            content: Text(AppLocalizations.of(context)!.deleteAllDataConfirmation),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      widget.notificationService.clearAll();
                      widget.periodRepository.truncate();
                      widget.settings.resetDefaults();
                    });
                    Navigator.of(context).pop();
                    showSnackBar(context, AppLocalizations.of(context)!.deletedAllData);
                  },
                  child: Text(AppLocalizations.of(context)!.yes)),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.no))
            ],
          );
        });
  }

  void _showHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HistoryPage(
                repository: widget.periodRepository,
                service: widget.periodService,
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

  void _showStats(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => StatsPage(
                service: widget.periodService,
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
