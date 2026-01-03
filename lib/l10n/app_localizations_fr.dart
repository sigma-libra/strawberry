// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Strawberry';

  @override
  String get history => 'Historique';

  @override
  String get alerts => 'Alertes';

  @override
  String get stats => 'Statistiques';

  @override
  String get settings => 'Paramètres';

  @override
  String get deleteAll => 'Tout supprimer';

  @override
  String get deletedAllData => 'Toutes les données ont été supprimées';

  @override
  String get dailyInformation => 'Informations quotidiennes';

  @override
  String get date => 'Date';

  @override
  String get moonPhase => 'Phase lunaire';

  @override
  String get onBirthControl => 'Sous contraception';

  @override
  String get temperature => 'Température';

  @override
  String get hadSex => 'Rapports sexuels';

  @override
  String get notes => 'Notes';

  @override
  String get noDaySelected => 'Aucun jour sélectionné';

  @override
  String get removedPeriod => 'Période supprimée';

  @override
  String get addedPeriod => 'Période ajoutée';

  @override
  String get periodStart => 'Début des règles';

  @override
  String get periodStartBody =>
      'Vos règles sont prévues pour commencer aujourd\'hui';

  @override
  String get markYourPeriod => 'Marquer vos règles';

  @override
  String get markYourPeriodBody =>
      'Avez-vous toujours vos règles aujourd\'hui?';

  @override
  String get newCycleStart => 'Nouveau cycle?';

  @override
  String get newCycleStartBody => 'Vos règles sont-elles terminées?';

  @override
  String get cycleDuration => 'Durée du cycle';

  @override
  String get cycleDurationHint =>
      'Nombre de jours entre les premiers jours de deux périodes consécutives.';

  @override
  String get periodDuration => 'Durée des règles';

  @override
  String get periodDurationHint =>
      'Nombre de jours du début à la fin d\'une période';

  @override
  String get baseBodyTemperature => 'Température corporelle de base';

  @override
  String get baseBodyTemperatureHint =>
      'Votre température corporelle habituelle. Vous pouvez également la définir par jour dans le calendrier. Les femmes sont généralement les plus fertiles depuis le début de leurs règles jusqu\'à 4 jours après une augmentation de leur température corporelle due à l\'ovulation. La température peut donc être utilisée comme estimation approximative du moment pour avoir des rapports sexuels pour induire ou éviter une grossesse. Cependant, notez que la température corporelle peut être influencée par d\'autres facteurs, comme le sommeil, les voyages, la maladie ou le stress. On estime qu\'1 femme sur 4 utilisant la température pour prévenir une grossesse tombe enceinte dans l\'année.';

  @override
  String get savedNewSettings => 'Nouveaux paramètres enregistrés';

  @override
  String get reportUpcomingPeriod => 'Signaler les règles à venir';

  @override
  String get reportUpcomingPeriodHint =>
      'Choisissez si vous souhaitez être notifiée un jour avant le début prévu de vos règles.';

  @override
  String get allowNotificationPermissions =>
      'Autorisez les permissions de notification pour l\'application dans les paramètres pour activer';

  @override
  String get askAboutCurrentPeriod => 'Demander à propos des règles actuelles';

  @override
  String get askAboutCurrentPeriodHint =>
      'Choisissez si vous souhaitez qu\'on vous demande si vous avez vos règles un jour où vous êtes censée les avoir (afin de pouvoir les marquer).';

  @override
  String get onBirthControlByDefault => 'Sous contraception par défaut';

  @override
  String get onBirthControlByDefaultHint =>
      'Si par défaut vous utilisez une contraception quotidienne, par exemple un implant ou un DIU. Cela ne mettra à jour que les jours non modifiés. N\'oubliez pas de suivre la date d\'expiration de votre contraception.';

  @override
  String get useManualInputs => 'Utiliser les entrées manuelles';

  @override
  String get useManualInputsHint =>
      'Choisissez si vous souhaitez utiliser vos entrées manuelles, ou si vous voulez calculer vos futures règles en fonction de vos règles passées. Les valeurs par défaut seront utilisées jusqu\'à ce qu\'au moins 3 périodes passées existent.';

  @override
  String get notificationTime => 'Heure de notification';

  @override
  String get notificationTimeHint =>
      'L\'heure de la journée à laquelle vous souhaitez être notifiée.';

  @override
  String get sexTypeNo => 'Non';

  @override
  String get sexTypeProtected => 'Oui (protégé)';

  @override
  String get sexTypeUnprotected => 'Oui (non protégé)';

  @override
  String get notificationChannelDescription =>
      'Canal pour les notifications des jours de règles';

  @override
  String get thereWasAnError => 'Il y a eu une erreur :(';

  @override
  String get logIn => 'Se connecter';

  @override
  String get authenticate => 'S\'authentifier';

  @override
  String get pleaseConfirm => 'Veuillez confirmer';

  @override
  String get deleteAllDataConfirmation =>
      'Êtes-vous sûr de vouloir supprimer toutes les données ? Cette action ne peut pas être annulée.';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get save => 'Enregistrer';
}
