import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:strawberry/notification/notification_id_constants.dart';
import 'package:strawberry/utils/date_time_utils.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

class NotificationService {
  NotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@drawable/moon_icon');

    DarwinInitializationSettings iosInitializeSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification);

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializeSettings,
    );

    await _localNotificationService.initialize(settings, onDidReceiveNotificationResponse: onSelectNotification);
  }

  void _onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {}

  void onSelectNotification(NotificationResponse details) {}

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      "period_day_notification_channel_id",
      "period_day_notification_channel_name",
      channelDescription: "Channel for notification of period days",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );
    const DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails();

    return const NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);
  }

  Future<void> showNotification({required int id, required String title, required String body}) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }

  Future<void> showScheduledNotification(
      {required int id, required String title, required String body, required DateTime date}) async {
    if (date.isAfter(DateTime.now().toUtc())) {
      final details = await _notificationDetails();
      final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      Location location = tz.getLocation(currentTimeZone);
      final tz.TZDateTime dateTime = tz.TZDateTime.from(date, location);
      await _localNotificationService.zonedSchedule(id, title, body, dateTime, details,
          payload: DateTimeUtils.formatPrettyDate(date),
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true);
    }
  }

  Future<List<String>> getNotificationsList() async {
    List<PendingNotificationRequest> requests = await _localNotificationService.pendingNotificationRequests();
    return requests.map((e) => "${e.payload}: ${e.body!}").toList();
  }

  Future<void> clearOldPeriodStartNotifications() async {
    await _localNotificationService.cancel(PERIOD_START_NOTIFICATION_ID);
  }

  Future<void> clearOldPeriodEndCheckNotifications() async {
    List<PendingNotificationRequest> notifications = await _localNotificationService.pendingNotificationRequests();
    for (PendingNotificationRequest notification in notifications) {
      int id = notification.id;
      if (id >= PERIOD_END_NOTIFICATION_ID_FLOOR) {
        await _localNotificationService.cancel(id);
      }
    }
  }

  Future<void> clearAll() async {
    await _localNotificationService.cancelAll();
  }
}
