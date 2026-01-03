// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Strawberry';

  @override
  String get history => 'Historial';

  @override
  String get alerts => 'Alertas';

  @override
  String get stats => 'Estadísticas';

  @override
  String get settings => 'Configuración';

  @override
  String get deleteAll => 'Eliminar todo';

  @override
  String get deletedAllData => 'Todos los datos han sido eliminados';

  @override
  String get dailyInformation => 'Información diaria';

  @override
  String get date => 'Fecha';

  @override
  String get moonPhase => 'Fase lunar';

  @override
  String get onBirthControl => 'Con anticonceptivos';

  @override
  String get temperature => 'Temperatura';

  @override
  String get hadSex => 'Relaciones sexuales';

  @override
  String get notes => 'Notas';

  @override
  String get noDaySelected => 'Ningún día seleccionado';

  @override
  String get removedPeriod => 'Período eliminado';

  @override
  String get addedPeriod => 'Período agregado';

  @override
  String get periodStart => 'Inicio del período';

  @override
  String get periodStartBody => 'Tu período está programado para comenzar hoy';

  @override
  String get markYourPeriod => 'Marcar tu período';

  @override
  String get markYourPeriodBody => '¿Todavía tienes tu período hoy?';

  @override
  String get newCycleStart => '¿Nuevo ciclo?';

  @override
  String get newCycleStartBody => '¿Ya terminó tu período?';

  @override
  String get cycleDuration => 'Duración del ciclo';

  @override
  String get cycleDurationHint =>
      'Número de días entre los primeros días de dos períodos consecutivos.';

  @override
  String get periodDuration => 'Duración del período';

  @override
  String get periodDurationHint =>
      'Número de días desde el inicio hasta el final de un período';

  @override
  String get baseBodyTemperature => 'Temperatura corporal basal';

  @override
  String get baseBodyTemperatureHint =>
      'Tu temperatura corporal habitual. También puedes establecerla por día en el calendario. Las mujeres suelen ser más fértiles desde el inicio de su período hasta 4 días después de un aumento en su temperatura corporal debido a la ovulación. Por lo tanto, la temperatura puede usarse como una estimación aproximada de cuándo tener relaciones sexuales para inducir o evitar el embarazo. Sin embargo, ten en cuenta que la temperatura corporal puede verse afectada por otros factores, como el sueño, los viajes, las enfermedades o el estrés. Se estima que 1 de cada 4 mujeres que usan la temperatura para prevenir el embarazo quedan embarazadas en un año.';

  @override
  String get savedNewSettings => 'Nueva configuración guardada';

  @override
  String get reportUpcomingPeriod => 'Reportar período próximo';

  @override
  String get reportUpcomingPeriodHint =>
      'Elige si deseas recibir una notificación un día antes de que se prediga que comience tu período.';

  @override
  String get allowNotificationPermissions =>
      'Permite permisos de notificación para la aplicación en la configuración para habilitar';

  @override
  String get askAboutCurrentPeriod => 'Preguntar sobre el período actual';

  @override
  String get askAboutCurrentPeriodHint =>
      'Elige si deseas que se te pregunte si tienes tu período en un día en el que se predice que lo tendrás (para que puedas marcarlo).';

  @override
  String get onBirthControlByDefault => 'Con anticonceptivos por defecto';

  @override
  String get onBirthControlByDefaultHint =>
      'Si por defecto usas anticonceptivos a diario, por ejemplo, un implante o DIU. Esto solo actualizará los días no editados. Recuerda llevar un registro de la fecha de vencimiento de tus anticonceptivos.';

  @override
  String get useManualInputs => 'Usar entradas manuales';

  @override
  String get useManualInputsHint =>
      'Elige si deseas usar tus entradas manuales o si deseas calcular tus períodos futuros basándose en tus períodos pasados. Se usarán valores predeterminados hasta que existan al menos 3 períodos pasados.';

  @override
  String get notificationTime => 'Hora de notificación';

  @override
  String get notificationTimeHint =>
      'La hora del día en la que te gustaría recibir notificaciones.';

  @override
  String get sexTypeNo => 'No';

  @override
  String get sexTypeProtected => 'Sí (protegido)';

  @override
  String get sexTypeUnprotected => 'Sí (sin protección)';

  @override
  String get notificationChannelDescription =>
      'Canal para notificaciones de días de período';

  @override
  String get thereWasAnError => 'Hubo un error :(';

  @override
  String get logIn => 'Iniciar sesión';

  @override
  String get authenticate => 'Autenticar';

  @override
  String get pleaseConfirm => 'Por favor confirme';

  @override
  String get deleteAllDataConfirmation =>
      '¿Está seguro de que desea eliminar todos los datos? Esta acción no se puede revertir.';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get save => 'Guardar';
}
