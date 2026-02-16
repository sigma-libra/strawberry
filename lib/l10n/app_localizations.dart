import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Strawberry'**
  String get appTitle;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAll;

  /// No description provided for @deletedAllData.
  ///
  /// In en, this message translates to:
  /// **'Deleted all data'**
  String get deletedAllData;

  /// No description provided for @dailyInformation.
  ///
  /// In en, this message translates to:
  /// **'Daily Information'**
  String get dailyInformation;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @moonPhase.
  ///
  /// In en, this message translates to:
  /// **'Moon Phase'**
  String get moonPhase;

  /// No description provided for @onBirthControl.
  ///
  /// In en, this message translates to:
  /// **'On Birth Control'**
  String get onBirthControl;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @hadSex.
  ///
  /// In en, this message translates to:
  /// **'Had Sex'**
  String get hadSex;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @noDaySelected.
  ///
  /// In en, this message translates to:
  /// **'No day selected'**
  String get noDaySelected;

  /// No description provided for @removedPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period removed'**
  String get removedPeriod;

  /// No description provided for @addedPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period logged'**
  String get addedPeriod;

  /// No description provided for @periodStart.
  ///
  /// In en, this message translates to:
  /// **'Period start'**
  String get periodStart;

  /// No description provided for @periodStartBody.
  ///
  /// In en, this message translates to:
  /// **'Your period should start today'**
  String get periodStartBody;

  /// No description provided for @markYourPeriod.
  ///
  /// In en, this message translates to:
  /// **'Log your period'**
  String get markYourPeriod;

  /// No description provided for @markYourPeriodBody.
  ///
  /// In en, this message translates to:
  /// **'Still have your period?'**
  String get markYourPeriodBody;

  /// No description provided for @newCycleStart.
  ///
  /// In en, this message translates to:
  /// **'New cycle?'**
  String get newCycleStart;

  /// No description provided for @newCycleStartBody.
  ///
  /// In en, this message translates to:
  /// **'Is your period over?'**
  String get newCycleStartBody;

  /// No description provided for @cycleDuration.
  ///
  /// In en, this message translates to:
  /// **'Cycle Duration'**
  String get cycleDuration;

  /// No description provided for @cycleDurationHint.
  ///
  /// In en, this message translates to:
  /// **'Days between the start of each period.'**
  String get cycleDurationHint;

  /// No description provided for @periodDuration.
  ///
  /// In en, this message translates to:
  /// **'Period Duration'**
  String get periodDuration;

  /// No description provided for @periodDurationHint.
  ///
  /// In en, this message translates to:
  /// **'How many days your period lasts'**
  String get periodDurationHint;

  /// No description provided for @baseBodyTemperature.
  ///
  /// In en, this message translates to:
  /// **'Base Body Temperature'**
  String get baseBodyTemperature;

  /// No description provided for @baseBodyTemperatureHint.
  ///
  /// In en, this message translates to:
  /// **'Your usual body temperature. You can also track it daily in the calendar. You\'re typically most fertile from the start of your period until 4 days after your temperature rises due to ovulation. Temperature can help estimate when to have sex to get pregnant or avoid pregnancy. Keep in mind that sleep, travel, illness, or stress can affect your temperature. About 1 in 4 women using this method to prevent pregnancy get pregnant within a year.'**
  String get baseBodyTemperatureHint;

  /// No description provided for @savedNewSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get savedNewSettings;

  /// No description provided for @reportUpcomingPeriod.
  ///
  /// In en, this message translates to:
  /// **'Upcoming period alert'**
  String get reportUpcomingPeriod;

  /// No description provided for @reportUpcomingPeriodHint.
  ///
  /// In en, this message translates to:
  /// **'Get notified a day before your period is expected to start.'**
  String get reportUpcomingPeriodHint;

  /// No description provided for @allowNotificationPermissions.
  ///
  /// In en, this message translates to:
  /// **'Enable notification permissions in app settings'**
  String get allowNotificationPermissions;

  /// No description provided for @askAboutCurrentPeriod.
  ///
  /// In en, this message translates to:
  /// **'Current period reminder'**
  String get askAboutCurrentPeriod;

  /// No description provided for @askAboutCurrentPeriodHint.
  ///
  /// In en, this message translates to:
  /// **'Get a reminder to log your period on predicted days.'**
  String get askAboutCurrentPeriodHint;

  /// No description provided for @onBirthControlByDefault.
  ///
  /// In en, this message translates to:
  /// **'Using birth control regularly'**
  String get onBirthControlByDefault;

  /// No description provided for @onBirthControlByDefaultHint.
  ///
  /// In en, this message translates to:
  /// **'If you use continuous birth control like an implant or IUD (intrauterine device). This will only affect days you haven\'t edited. Remember to track your birth control\'s expiration date.'**
  String get onBirthControlByDefaultHint;

  /// No description provided for @useManualInputs.
  ///
  /// In en, this message translates to:
  /// **'Enter data manually'**
  String get useManualInputs;

  /// No description provided for @useManualInputsHint.
  ///
  /// In en, this message translates to:
  /// **'Choose whether to enter your data manually or predict future periods based on your history. Default values will be used until you have at least 3 logged periods.'**
  String get useManualInputsHint;

  /// No description provided for @notificationTime.
  ///
  /// In en, this message translates to:
  /// **'Notification time'**
  String get notificationTime;

  /// No description provided for @notificationTimeHint.
  ///
  /// In en, this message translates to:
  /// **'What time you want to receive notifications.'**
  String get notificationTimeHint;

  /// No description provided for @sexTypeNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get sexTypeNo;

  /// No description provided for @sexTypeProtected.
  ///
  /// In en, this message translates to:
  /// **'Yes (protected)'**
  String get sexTypeProtected;

  /// No description provided for @sexTypeUnprotected.
  ///
  /// In en, this message translates to:
  /// **'Yes (unprotected)'**
  String get sexTypeUnprotected;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Period notifications'**
  String get notificationChannelDescription;

  /// No description provided for @thereWasAnError.
  ///
  /// In en, this message translates to:
  /// **'There was an error :('**
  String get thereWasAnError;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @authenticate.
  ///
  /// In en, this message translates to:
  /// **'Authenticate'**
  String get authenticate;

  /// No description provided for @pleaseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Please Confirm'**
  String get pleaseConfirm;

  /// No description provided for @deleteAllDataConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all data? This can\'t be undone.'**
  String get deleteAllDataConfirmation;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
