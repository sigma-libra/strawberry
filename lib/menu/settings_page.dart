import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strawberry/notification/notifications_service.dart';
import 'package:strawberry/settings/settings_constants.dart';
import 'package:strawberry/settings/settings_service.dart';
import 'package:strawberry/utils/colors.dart';
import 'package:strawberry/utils/snackbar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(
      {super.key, required this.notificationService, required this.settings});

  final NotificationService notificationService;
  final SettingsService settings;

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
    _cycleController =
        TextEditingController(text: widget.settings.getCycle().toString());
    _periodController =
        TextEditingController(text: widget.settings.getPeriod().toString());
    _useManualAverages = widget.settings.getManualAveragesFlag();
    _notificationsOn = widget.settings.getNotificationsFlag();
    _currentNotificationsOn = widget.settings.getCurrentNotificationsFlag();
    _notificationTime = widget.settings.getNotificationTime();
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
        padding: const EdgeInsets.all(30.0),
        child: ListView(
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
                widget.settings.setNotificationsFlag(_notificationsOn);
                widget.settings
                    .setCurrentNotificationsFlag(_currentNotificationsOn);
                widget.settings.setNotificationTime(_notificationTime);
                widget.settings.setManualAveragesFlag(_useManualAverages);
                if (_useManualAverages) {
                  widget.settings
                      .setPeriod(int.parse(_periodController.value.text));
                  widget.settings
                      .setCycle(int.parse(_cycleController.value.text));
                }
                showSnackBar(context, "Saved new settings");
              },
              child: const Text('Save'),
            ),
          ],
        ));
  }

  Row _numberField(TextEditingController controller, String label) {
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

  Row _notificationSwitch() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text("Report upcoming period"),
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

  Row _currentNotificationSwitch() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text("Ask about current period"),
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

  Divider _divider() {
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

  Row _manualSwitch() {
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

  Row _timeField() {
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
}
