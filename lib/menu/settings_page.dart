import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strawberry/notification/local_notifications_service.dart';
import 'package:strawberry/period/model/period_constants.dart';
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

  bool _useManualAverages = DEFAULT_MANUAL_AVERAGES;

  bool _notificationsOn = DEFAULT_NOTIFICATIONS_ON;

  bool _currentNotificationsOn = DEFAULT_CURRENT_NOTIFICATIONS_ON;

  TimeOfDay _notificationTime = const TimeOfDay(
      hour: DEFAULT_NOTIFICATION_HOUR, minute: DEFAULT_NOTIFICATION_MINUTE);

  @override
  void initState() {
    super.initState();
    _cycleController = TextEditingController(
        text: widget.configs.getInt(AVERAGE_CYCLE_KEY).toString());
    _periodController = TextEditingController(
        text: widget.configs.getInt(AVERAGE_PERIOD_KEY).toString());
    _useManualAverages = widget.configs.getBool(USE_MANUAL_AVERAGES_KEY) ??
        DEFAULT_MANUAL_AVERAGES;
    _notificationsOn = widget.configs.getBool(NOTIFICATIONS_ON_KEY) ??
        DEFAULT_NOTIFICATIONS_ON;
    _currentNotificationsOn =
        widget.configs.getBool(CURRENT_NOTIFICATIONS_ON_KEY) ??
            DEFAULT_CURRENT_NOTIFICATIONS_ON;

    int notificationHour = widget.configs.getInt(NOTIFICATION_HOUR_KEY) ??
        DEFAULT_NOTIFICATION_HOUR;
    int notificationMinute = widget.configs.getInt(NOTIFICATION_MINUTE_KEY) ??
        DEFAULT_NOTIFICATION_MINUTE;

    _notificationTime =
        TimeOfDay(hour: notificationHour, minute: notificationMinute);
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
            _timeField(),
            _divider(),
            _manualSwitch(),
            _numberField(_cycleController, "Cycle"),
            _numberField(_periodController, "Period"),
            ElevatedButton(
              onPressed: () {
                _setNotificationsFlag();
                _setCurrentNotificationsFlag();
                _setNotificationTime();
                _setManualFlag();
                if (_useManualAverages) {
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
              enabled: _useManualAverages,
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
            value: _notificationsOn,
            activeColor: CUSTOM_YELLOW,
            onChanged: (bool value) {
              // This is called when the user toggles the switch.
              setState(() {
                _notificationsOn = value;
                _currentNotificationsOn = _currentNotificationsOn && value;
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
            value: _notificationsOn && _currentNotificationsOn,
            activeColor: CUSTOM_YELLOW,
            onChanged: (bool value) {
              // This is called when the user toggles the switch.
              setState(() {
                _currentNotificationsOn = value;
              });
            },
          ),
        ]);
  }

  Widget _divider() {
    return Divider(
      color: CUSTOM_BLUE,
      thickness: 2,
    );
  }

  Color _enabledTextColor() {
    if (_useManualAverages) {
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
            value: _useManualAverages,
            activeColor: CUSTOM_RED,
            onChanged: (bool value) {
              // This is called when the user toggles the switch.
              setState(() {
                _useManualAverages = value;
              });
            },
          ),
        ]);
  }

  Widget _timeField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Notification time"),
        SizedBox(
            width: 80,
            child: ElevatedButton(
              onPressed: () {
                return _selectTime(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: CUSTOM_YELLOW),
              child: Text(_notificationTime.format(context)),
            ))
      ],
    );
  }

  void _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _notificationTime,
    );
    setState(() {
      if (picked != null) {
        _notificationTime = picked;
      }
    });
  }

  void _setNotificationsFlag() =>
      widget.configs.setBool(NOTIFICATIONS_ON_KEY, _notificationsOn);

  void _setCurrentNotificationsFlag() => widget.configs
      .setBool(CURRENT_NOTIFICATIONS_ON_KEY, _currentNotificationsOn);

  void _setManualFlag() =>
      widget.configs.setBool(USE_MANUAL_AVERAGES_KEY, _useManualAverages);

  void _setPeriod(String value) =>
      widget.configs.setInt(AVERAGE_PERIOD_KEY, int.parse(value));

  void _setCycle(String value) =>
      widget.configs.setInt(AVERAGE_CYCLE_KEY, int.parse(value));

  void _setNotificationTime() {
    widget.configs.setInt(NOTIFICATION_HOUR_KEY, _notificationTime.hour);
    widget.configs.setInt(NOTIFICATION_MINUTE_KEY, _notificationTime.minute);
  }
}
