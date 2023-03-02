import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

const int testId = 0;
const periodStartId = 100;
const periodEndCheckIdRange = 200;

class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@drawable/moon_icon');

    DarwinInitializationSettings iosInitializeSettings =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: _onDidReceiveLocalNotification);

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializeSettings,
    );

    await _localNotificationService.initialize(settings,
        onDidReceiveNotificationResponse: onSelectNotification);
  }

  void _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print("Id $id");
  }

  void onSelectNotification(NotificationResponse details) {
    print("$details");
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "period_day_notification_channel_id",
      "period_day_notification_channel_name",
      channelDescription: "Channel for notification of period days",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    return const NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
  }

  Future<void> showNotification(
      {required int id, required String title, required String body}) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }

  Future<void> showScheduledNotification(
      {required int id,
      required String title,
      required String body,
      required DateTime date}) async {
    if (date.isAfter(DateTime.now())) {
      final details = await _notificationDetails();
      final tz.TZDateTime dateTime = tz.TZDateTime.from(date, tz.local);
      await _localNotificationService.zonedSchedule(
          id, title, body, dateTime, details,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true);
    }
  }

  Future<void> clearOldPeriodStartNotifications() async {
    await _localNotificationService.cancel(periodStartId);
  }

  Future<void> clearOldPeriodEndCheckNotifications() async {
    List<PendingNotificationRequest> notifications = await _localNotificationService.pendingNotificationRequests();
    for(PendingNotificationRequest notification in notifications) {
      int id = notification.id;
      if(id >= periodEndCheckIdRange) {
        await _localNotificationService.cancel(id);
      }
    }
  }

  Future<void> clearAll() async {
    await _localNotificationService.cancelAll();
  }
}
