import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strawberry/settings/settings_constants.dart';

class SettingsService {
  late SharedPreferences _preferences;

  Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  void setNotificationsFlag(bool value) =>
      _preferences.setBool(NOTIFICATIONS_ON_KEY, value);

  bool getNotificationsFlag() =>
      _preferences.getBool(NOTIFICATIONS_ON_KEY) ?? DEFAULT_NOTIFICATIONS_ON;

  void setCurrentNotificationsFlag(bool value) =>
      _preferences.setBool(CURRENT_NOTIFICATIONS_ON_KEY, value);

  bool getCurrentNotificationsFlag() =>
      _preferences.getBool(CURRENT_NOTIFICATIONS_ON_KEY) ??
      DEFAULT_CURRENT_NOTIFICATIONS_ON;

  void setManualAveragesFlag(bool value) =>
      _preferences.setBool(USE_MANUAL_AVERAGES_KEY, value);

  bool getManualAveragesFlag() =>
      _preferences.getBool(USE_MANUAL_AVERAGES_KEY) ?? DEFAULT_MANUAL_AVERAGES;

  void setPeriod(int value) => _preferences.setInt(AVERAGE_PERIOD_KEY, value);

  int getPeriod() =>
      _preferences.getInt(AVERAGE_PERIOD_KEY) ?? DEFAULT_AVERAGE_PERIOD_LENGTH;

  void setTemperature(double value) => _preferences.setDouble(AVERAGE_TEMPERATURE_KEY, value);

  double getTemperature() =>
      _preferences.getDouble(AVERAGE_TEMPERATURE_KEY) ?? DEFAULT_AVERAGE_TEMPERATURE;

  void setCycle(int value) => _preferences.setInt(AVERAGE_CYCLE_KEY, value);

  int getCycle() =>
      _preferences.getInt(AVERAGE_CYCLE_KEY) ?? DEFAULT_AVERAGE_CYCLE_LENGTH;

  void setNotificationTime(TimeOfDay time) {
    _preferences.setInt(NOTIFICATION_HOUR_KEY, time.hour);
    _preferences.setInt(NOTIFICATION_MINUTE_KEY, time.minute);
  }

  TimeOfDay getNotificationTime() {
    int hour =
        _preferences.getInt(NOTIFICATION_HOUR_KEY) ?? DEFAULT_NOTIFICATION_HOUR;
    int minute = _preferences.getInt(NOTIFICATION_MINUTE_KEY) ??
        DEFAULT_NOTIFICATION_MINUTE;
    return TimeOfDay(hour: hour, minute: minute);
  }
}
