import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:strawberry/notification/notifications_service.dart';
import 'package:strawberry/settings/settings_constants.dart';
import 'package:strawberry/settings/settings_service.dart';
import 'package:strawberry/utils/colors.dart';
import 'package:strawberry/utils/info_tooltip.dart';
import 'package:strawberry/utils/snackbar.dart';
import 'package:strawberry/l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.notificationService, required this.settings});

  final NotificationService notificationService;
  final SettingsService settings;

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  TextEditingController _cycleController = TextEditingController();
  TextEditingController _periodController = TextEditingController();
  TextEditingController _temperatureController = TextEditingController();

  bool _useManualAverages = DEFAULT_MANUAL_AVERAGES;

  bool _notificationsOn = DEFAULT_NOTIFICATIONS_ON;

  bool _currentNotificationsOn = DEFAULT_CURRENT_NOTIFICATIONS_ON;

  bool _defaultOnBirthControl = DEFAULT_BIRTH_CONTROL;

  TimeOfDay _notificationTime = const TimeOfDay(hour: DEFAULT_NOTIFICATION_HOUR, minute: DEFAULT_NOTIFICATION_MINUTE);

  @override
  void initState() {
    super.initState();
    _cycleController = TextEditingController(text: widget.settings.getCycle().toString());
    _periodController = TextEditingController(text: widget.settings.getPeriod().toString());
    _temperatureController = TextEditingController(text: widget.settings.getTemperature().toString());
    _useManualAverages = widget.settings.getManualAveragesFlag();
    _notificationsOn = widget.settings.getNotificationsFlag() && widget.settings.getNotificationsPermittedFlag();
    _currentNotificationsOn = widget.settings.getCurrentNotificationsFlag();
    _notificationTime = widget.settings.getNotificationTime();
    _defaultOnBirthControl = widget.settings.getBirthControl();
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
          title: Text(AppLocalizations.of(context)!.settings),
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
            _numberField(_cycleController, AppLocalizations.of(context)!.cycleDuration,
                AppLocalizations.of(context)!.cycleDurationHint, 2,
                enablingFlag: _useManualAverages),
            _numberField(_periodController, AppLocalizations.of(context)!.periodDuration, AppLocalizations.of(context)!.periodDurationHint, 2,
                enablingFlag: _useManualAverages),
            _divider(),
            _numberField(
                _temperatureController,
                AppLocalizations.of(context)!.baseBodyTemperature,
                AppLocalizations.of(context)!.baseBodyTemperatureHint,
                5),
            _birthControlSwitch(),
            ElevatedButton(
              onPressed: () {
                widget.settings.setNotificationsFlag(_notificationsOn);
                widget.settings.setCurrentNotificationsFlag(_currentNotificationsOn);
                widget.settings.setNotificationTime(_notificationTime);
                widget.settings.setManualAveragesFlag(_useManualAverages);
                if (_useManualAverages) {
                  widget.settings.setPeriod(int.parse(_periodController.value.text));
                  widget.settings.setCycle(int.parse(_cycleController.value.text));
                }
                widget.settings.setTemperature(double.parse(_temperatureController.value.text));
                widget.settings.setBirthControl(_defaultOnBirthControl);
                showSnackBar(context, AppLocalizations.of(context)!.savedNewSettings);
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        ));
  }

  Row _numberField(TextEditingController controller, String label, String tooltip, int maxLength,
      {bool enablingFlag = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        showTextWithTooltip(label, tooltip),
        SizedBox(
            width: 50,
            child: TextField(
              enabled: enablingFlag,
              style: TextStyle(color: _enabledTextColor(enabledFlag: enablingFlag)),
              cursorColor: _enabledTextColor(),
              controller: controller,
              textDirection: TextDirection.ltr,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              maxLength: maxLength,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
              ],
            ))
      ],
    );
  }

  Row _notificationSwitch() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
      showTextWithTooltip(
          AppLocalizations.of(context)!.reportUpcomingPeriod, AppLocalizations.of(context)!.reportUpcomingPeriodHint),
      Switch(
          value: _notificationsOn,
          activeColor: CUSTOM_YELLOW,
          onChanged: (bool value) {
            if (widget.settings.getNotificationsPermittedFlag()) {
              setState(() {
                _notificationsOn = value;
                _currentNotificationsOn = _currentNotificationsOn && value;
              });
            } else {
              showSnackBar(context, AppLocalizations.of(context)!.allowNotificationPermissions);
            }
          }),
    ]);
  }

  Row _currentNotificationSwitch() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
      showTextWithTooltip(AppLocalizations.of(context)!.askAboutCurrentPeriod,
          AppLocalizations.of(context)!.askAboutCurrentPeriodHint),
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

  Row _birthControlSwitch() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
      showTextWithTooltip(
          AppLocalizations.of(context)!.onBirthControlByDefault,
          AppLocalizations.of(context)!.onBirthControlByDefaultHint),
      Switch(
        value: _defaultOnBirthControl,
        activeColor: CUSTOM_YELLOW,
        onChanged: (bool value) {
          // This is called when the user toggles the switch.
          setState(() {
            _defaultOnBirthControl = value;
          });
        },
      ),
    ]);
  }

  Divider _divider() {
    return const Divider(
      color: CUSTOM_BLUE,
      thickness: 2,
    );
  }

  Color _enabledTextColor({bool enabledFlag = true}) {
    if (enabledFlag) {
      return Colors.black;
    } else {
      return Colors.grey;
    }
  }

  Row _manualSwitch() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
      showTextWithTooltip(
          AppLocalizations.of(context)!.useManualInputs,
          AppLocalizations.of(context)!.useManualInputsHint),
      Switch(
        value: _useManualAverages,
        activeColor: CUSTOM_RED,
        onChanged: (bool value) {
          // This is called when the user toggles the switch.
          setState(() {
            _useManualAverages = value;
            if (!_useManualAverages) {
              _cycleController.text = widget.settings.getCycle().toString();
              _periodController.text = widget.settings.getPeriod().toString();
            }
          });
        },
      ),
    ]);
  }

  Row _timeField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        showTextWithTooltip(AppLocalizations.of(context)!.notificationTime, AppLocalizations.of(context)!.notificationTimeHint),
        SizedBox(
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
