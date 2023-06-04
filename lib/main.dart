import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:strawberry/notification/notifications_service.dart';
import 'package:strawberry/period/repository/period_repository.dart';
import 'package:strawberry/period/service/period_service.dart';
import 'package:strawberry/settings/settings_service.dart';
import 'package:strawberry/start_page.dart';
import 'package:strawberry/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SettingsService settings = SettingsService();
  await settings.init();
  PeriodService periodService = PeriodService(settings);
  PeriodRepository periodRepository = PeriodRepository();
  await periodRepository.init();
  final NotificationService notificationService = NotificationService();
  await notificationService.init();
  initializeDateFormatting().then((_) => runApp(MyApp(
        periodRepository: periodRepository,
        periodService: periodService,
        notificationService: notificationService,
        settings: settings,
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({
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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strawberry',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(color: CUSTOM_BLUE),
      ),
      home: StartPage(
        periodRepository: periodRepository,
        periodService: periodService,
        notificationService: notificationService,
        settings: settings,
      ),
    );
  }
}
