import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:strawberry/notification/notifications_service.dart';
import 'package:strawberry/period/repository/period_repository.dart';
import 'package:strawberry/period/service/period_service.dart';
import 'package:strawberry/settings/settings_service.dart';
import 'package:strawberry/start_page.dart';
import 'package:strawberry/utils/colors.dart';

class AuthCodePage extends StatefulWidget {
  final PeriodRepository periodRepository;

  final PeriodService periodService;

  final NotificationService notificationService;

  final SettingsService settings;

  const AuthCodePage({
    super.key,
    required this.periodRepository,
    required this.periodService,
    required this.notificationService,
    required this.settings,
  });

  @override
  State<AuthCodePage> createState() => _AuthCodePageState();
}

class _AuthCodePageState extends State<AuthCodePage> {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> _getAuth() async {
    return await auth.authenticate(
        localizedReason: 'Authenticate', options: const AuthenticationOptions(biometricOnly: false, stickyAuth: true));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getAuth(),
        builder: (BuildContext context, AsyncSnapshot<bool> pass) {
          if (pass.connectionState == ConnectionState.waiting) {
            return _loadingScreen();
          } else if (pass.hasData && pass.data!) {
            return StartPage(
                periodRepository: widget.periodRepository,
                periodService: widget.periodService,
                notificationService: widget.notificationService,
                settings: widget.settings);
          } else {
            return _retryScreen();
          }
        });
  }

  Container _retryScreen() {
    return Container(
      color: CUSTOM_BLUE,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your logo widget here
            Image.asset(
              'photos/app_launcher_icon.png',
              width: 150, // Adjust the width as needed
              height: 150, // Adjust the height as needed
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {}); // Retry by triggering a rebuild
              },
              child: const Text('Log back in'),
            )
          ],
        ),
      ),
    );
  }

  Container _loadingScreen() {
    return Container(
      color: CUSTOM_BLUE,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your logo widget here
            Image.asset(
              'photos/app_launcher_icon.png',
              width: 150, // Adjust the width as needed
              height: 150, // Adjust the height as needed
            ),
          ],
        ),
      ),
    );
  }
}
