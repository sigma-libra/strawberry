import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:strawberry/notification/notifications_service.dart';
import 'package:strawberry/period/repository/period_repository.dart';
import 'package:strawberry/period/service/period_service.dart';
import 'package:strawberry/settings/settings_service.dart';
import 'package:strawberry/start_page.dart';

class AuthCodePage extends StatelessWidget {
  final PeriodRepository periodRepository;

  final PeriodService periodService;

  final NotificationService notificationService;

  final SettingsService settings;

  AuthCodePage({
    super.key,
    required this.periodRepository,
    required this.periodService,
    required this.notificationService,
    required this.settings,
  });

  final LocalAuthentication auth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: auth.authenticate(
            localizedReason: 'Authenticate',
            options: const AuthenticationOptions(biometricOnly: false)),
        builder: (BuildContext context, AsyncSnapshot<bool> pass) {
          if (pass.hasData && pass.data!) {
            return StartPage(
                periodRepository: periodRepository,
                periodService: periodService,
                notificationService: notificationService,
                settings: settings);
          } else {
            print("Error");
            print("Pass: ${pass.error}");
            return Text(
              'There was an error :(',
              style: Theme.of(context).textTheme.displayLarge,
            );
          }
        });
  }
}
