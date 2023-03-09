import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strawberry/notification/local_notifications_service.dart';
import 'package:strawberry/period/model/period.dart';
import 'package:strawberry/period/model/period_constants.dart';
import 'package:strawberry/period/repository/period_repository.dart';
import 'package:strawberry/period/service/period_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(
      {super.key, required this.notificationService, required this.configs});

  final LocalNotificationService notificationService;
  final SharedPreferences configs;

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {

   TextEditingController _cycleController = TextEditingController();
   TextEditingController _periodController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cycleController = TextEditingController(text: widget.configs.getInt(AVERAGE_CYCLE_KEY).toString());
    _periodController = TextEditingController(text: widget.configs.getInt(AVERAGE_PERIOD_KEY).toString());
  }

  @override
  void dispose() {
    _cycleController.dispose();
    _periodController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: _makeSettings());
  }

  Container _makeSettings() {
    return Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _cycleController,
              decoration: const InputDecoration(labelText: "Cycle Duration"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            TextFormField(
              controller: _periodController,
              decoration: const InputDecoration(labelText: "Period Duration"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _setPeriod(_periodController.value.text);
                _setCycle(_cycleController.value.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ));
  }

  void _setPeriod(String value) =>
      widget.configs.setInt(AVERAGE_PERIOD_KEY, int.parse(value));

  void _setCycle(String value) =>
      widget.configs.setInt(AVERAGE_CYCLE_KEY, int.parse(value));
}
