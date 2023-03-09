import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strawberry/notification/local_notifications_service.dart';
import 'package:strawberry/period/model/period.dart';
import 'package:strawberry/period/model/period_constants.dart';
import 'package:strawberry/period/repository/period_repository.dart';
import 'package:strawberry/period/service/period_service.dart';
import 'package:strawberry/utils/colors.dart';

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

  bool useManualAverages = DEFAULT_MANUAL_AVERAGES;

  bool notificationsOn = DEFAULT_NOTIFICATIONS_ON;

  bool currentNotificationsOn = DEFAULT_CURRENT_NOTIFICATIONS_ON;

  @override
  void initState() {
    super.initState();
    _cycleController = TextEditingController(
        text: widget.configs.getInt(AVERAGE_CYCLE_KEY).toString());
    _periodController = TextEditingController(
        text: widget.configs.getInt(AVERAGE_PERIOD_KEY).toString());
    useManualAverages = widget.configs.getBool(USE_MANUAL_AVERAGES_KEY) ??
        DEFAULT_MANUAL_AVERAGES;
    notificationsOn = widget.configs.getBool(NOTIFICATIONS_ON_KEY) ??
        DEFAULT_NOTIFICATIONS_ON;
    currentNotificationsOn =
        widget.configs.getBool(CURRENT_NOTIFICATIONS_ON_KEY) ??
            DEFAULT_CURRENT_NOTIFICATIONS_ON;
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _notificationSwitch(),
            _currentNotificationSwitch(),
            _divider(),
            _manualSwitch(),
            _numberField(_cycleController, "Cycle"),
            _numberField(_periodController, "Period"),
            ElevatedButton(
              onPressed: () {
                _setNotificationsFlag();
                _setCurrentNotificationsFlag();
                _setManualFlag();
                if (useManualAverages) {
                  _setPeriod(_periodController.value.text);
                  _setCycle(_cycleController.value.text);
                }
                
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ));
  }

  Widget _numberField(TextEditingController controller, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$label Duration"),
        SizedBox(
            width: 40,
            child: TextField(
              enabled: useManualAverages,
              style: TextStyle(color: _enabledTextColor()),
              cursorColor: _enabledTextColor(),
              controller: controller,
              textDirection: TextDirection.rtl,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              maxLength: 2,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ))
      ],
    );
  }

  Widget _notificationSwitch() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text("All notifications"),
          Switch(
            value: notificationsOn,
            activeColor: CUSTOM_YELLOW,
            onChanged: (bool value) {
              // This is called when the user toggles the switch.
              setState(() {
                notificationsOn = value;
                currentNotificationsOn = currentNotificationsOn && value;
              });
            },
          ),
        ]);
  }

  Widget _currentNotificationSwitch() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text("Current period notification"),
          Switch(
            value: notificationsOn && currentNotificationsOn,
            activeColor: CUSTOM_YELLOW,
            onChanged: (bool value) {
              // This is called when the user toggles the switch.
              setState(() {
                currentNotificationsOn = value;
              });
            },
          ),
        ]);
  }

  Widget _divider() {
    return const Divider(
      color: Colors.black,
      thickness: 2,
    );
  }

  Color _enabledTextColor() {
    if (useManualAverages) {
      return Colors.black;
    } else {
      return Colors.grey;
    }
  }

  Widget _manualSwitch() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text("Use manual inputs"),
          Switch(
            value: useManualAverages,
            activeColor: Colors.red,
            onChanged: (bool value) {
              // This is called when the user toggles the switch.
              setState(() {
                useManualAverages = value;
              });
            },
          ),
        ]);
  }

  void _setNotificationsFlag() =>
      widget.configs.setBool(NOTIFICATIONS_ON_KEY, notificationsOn);

  void _setCurrentNotificationsFlag() =>
      widget.configs.setBool(CURRENT_NOTIFICATIONS_ON_KEY, currentNotificationsOn);

  void _setManualFlag() =>
      widget.configs.setBool(USE_MANUAL_AVERAGES_KEY, useManualAverages);

  void _setPeriod(String value) =>
      widget.configs.setInt(AVERAGE_PERIOD_KEY, int.parse(value));

  void _setCycle(String value) =>
      widget.configs.setInt(AVERAGE_CYCLE_KEY, int.parse(value));
}
