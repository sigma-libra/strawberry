import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
        builder: (BuildContext context, AsyncSnapshot<List<PendingNotificationRequest>> snapshot) {
          if (snapshot.hasError) {
            return Text(
              'There was an error : ${snapshot.error}',
              style: Theme.of(context).textTheme.displayLarge,
            );
          } else if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Alerts"),
                ),
                body: _makeAlertList(snapshot.requireData.toList()));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  ListView _makeAlertList(List<PendingNotificationRequest> notifications) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        PendingNotificationRequest notification = notifications[index];
        return ListTile(
          title: Card(
              child: ListTile(
            title: Text(widget.notificationService.toNotificationString(notification)),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => deleteNotification(notification),
            ),
          )),
        );
      },
    );
  }

  void deleteNotification(PendingNotificationRequest notification) {
    setState(() {
      widget.notificationService.deleteNotification(notification);
    });
  }
}
