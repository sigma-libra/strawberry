import 'package:flutter/material.dart';
import 'package:strawberry/notification/notifications_service.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key, required this.notificationService});

  final NotificationService notificationService;

  @override
  AlertsPageState createState() => AlertsPageState();
}

class AlertsPageState extends State<AlertsPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.notificationService.getNotificationsList(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasError) {
            return Text(
              'There was an error :(',
              style: Theme.of(context).textTheme.displayLarge,
            );
          } else if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("History"),
                ),
                body: _makeAlertList(snapshot.requireData.toList()));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  ListView _makeAlertList(List<String> notifications) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Card(
              child: ListTile(
            title: Text(notifications[index]),
          )),
        );
      },
    );
  }
}
