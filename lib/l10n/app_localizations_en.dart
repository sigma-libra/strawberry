// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Strawberry';

  @override
  String get history => 'History';

  @override
  String get alerts => 'Alerts';

  @override
  String get stats => 'Stats';

  @override
  String get settings => 'Settings';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get deletedAllData => 'Deleted all data';

  @override
  String get dailyInformation => 'Daily Information';

  @override
  String get date => 'Date';

  @override
  String get moonPhase => 'Moon Phase';

  @override
  String get onBirthControl => 'On Birth Control';

  @override
  String get temperature => 'Temperature';

  @override
  String get hadSex => 'Had Sex';

  @override
  String get notes => 'Notes';

  @override
  String get noDaySelected => 'No day selected';

  @override
  String get removedPeriod => 'Removed period';

  @override
  String get addedPeriod => 'Added period';

  @override
  String get periodStart => 'Period start';

  @override
  String get periodStartBody => 'Your period is scheduled to start today';

  @override
  String get markYourPeriod => 'Mark your period';

  @override
  String get markYourPeriodBody => 'Do you still have your period today?';

  @override
  String get newCycleStart => 'New cycle start?';

  @override
  String get newCycleStartBody => 'Is your period over yet?';

  @override
  String get cycleDuration => 'Cycle Duration';

  @override
  String get cycleDurationHint =>
      'Number of days between the first days of two consecutive periods.';

  @override
  String get periodDuration => 'Period Duration';

  @override
  String get periodDurationHint =>
      'Number of days from start to end of a period';

  @override
  String get baseBodyTemperature => 'Base Body Temperature';

  @override
  String get baseBodyTemperatureHint =>
      'Your usual body temperature. You can also set this per day in the calendar. Women are typically most fertile from the start of their period until 4 days after a rise in their body temperature due to ovulation. Temperature can therefore be used as an approximate estimate of when to have sex to induce or avoid pregnancy. However, note that body temperature can be influenced by other things, like sleep, travel, illness or stress. An estimated 1 in 4 women using temperature to prevent pregnancy become pregnant within a year.';

  @override
  String get savedNewSettings => 'Saved new settings';

  @override
  String get reportUpcomingPeriod => 'Report upcoming period';

  @override
  String get reportUpcomingPeriodHint =>
      'Choose whether to be notified a day before your period is predicted to start.';

  @override
  String get allowNotificationPermissions =>
      'Allow notification permissions for app in settings to enable';

  @override
  String get askAboutCurrentPeriod => 'Ask about current period';

  @override
  String get askAboutCurrentPeriodHint =>
      'Choose whether to be asked whether you have your period on a day you are predicted to have your period (so you can mark it).';

  @override
  String get onBirthControlByDefault => 'On birth control by default';

  @override
  String get onBirthControlByDefaultHint =>
      'Whether per default you have birth control on a daily basis, for example an implant or IUD. This will only update unedited days. Remember to keep track of your birth control\'s expiration date.';

  @override
  String get useManualInputs => 'Use manual inputs';

  @override
  String get useManualInputsHint =>
      'Choose whether to use your manual inputs, or whether to calculate your future periods based on your past periods. Default values will be used until at least 3 past periods exist.';

  @override
  String get notificationTime => 'Notification time';

  @override
  String get notificationTimeHint =>
      'The time of day at which you would like to be notified.';

  @override
  String get sexTypeNo => 'No';

  @override
  String get sexTypeProtected => 'Yes (protected)';

  @override
  String get sexTypeUnprotected => 'Yes (unprotected)';

  @override
  String get notificationChannelDescription =>
      'Channel for notification of period days';

  @override
  String get thereWasAnError => 'There was an error :(';

  @override
  String get logIn => 'Log in';

  @override
  String get authenticate => 'Authenticate';

  @override
  String get pleaseConfirm => 'Please Confirm';

  @override
  String get deleteAllDataConfirmation =>
      'Are you sure to delete all data? This action cannot be reversed.';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get save => 'Save';
}
