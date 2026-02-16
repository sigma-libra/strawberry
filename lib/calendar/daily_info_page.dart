import 'package:flutter/material.dart';
import 'package:strawberry/model/daily_info.dart';
import 'package:strawberry/model/sex_type.dart';
import 'package:strawberry/moon/moon_phase.dart';
import 'package:strawberry/period/repository/period_repository.dart';
import 'package:strawberry/settings/settings_constants.dart';
import 'package:strawberry/utils/colors.dart';
import 'package:strawberry/utils/date_time_utils.dart';
import 'package:strawberry/l10n/app_localizations.dart';

class DailyInfoPage extends StatefulWidget {
  const DailyInfoPage(this.periodRepository, this.dailyInfo, {super.key});

  final PeriodRepository periodRepository;
  final DailyInfo dailyInfo;

  @override
  DailyInfoPageState createState() {
    return DailyInfoPageState();
  }
}

class DailyInfoPageState extends State<DailyInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            AppLocalizations.of(context)!.dailyInformation,
            style: const TextStyle(color: CUSTOM_BLUE, fontWeight: FontWeight.w500, fontSize: 18),
          ),
        ),
        _makeInfoTile(AppLocalizations.of(context)!.date, DateTimeUtils.formatPrettyDate(widget.dailyInfo.date)),
        _makeMoonTile(widget.dailyInfo.date),
        _createSexType(),
        _createBirthControlCheck(),
        _createTemperatureCheck(),
        _createNotes()
      ],
    );
  }

  ListTile _makeInfoTile(String title, String value) {
    return ListTile(
      leading: Text(
        title,
        style: const TextStyle(color: CUSTOM_RED, fontWeight: FontWeight.w400),
      ),
      trailing: Text(value),
    );
  }

  ListTile _makeMoonTile(DateTime date) {
    return ListTile(
      leading: Text(
        AppLocalizations.of(context)!.moonPhase,
        style: const TextStyle(color: CUSTOM_RED, fontWeight: FontWeight.w400),
      ),
      trailing: MoonWidget(
        date: date,
      ),
    );
  }

  ListTile _createBirthControlCheck() {
    return ListTile(
        leading: Text(
          AppLocalizations.of(context)!.onBirthControl,
          style: const TextStyle(color: CUSTOM_RED, fontWeight: FontWeight.w400),
        ),
        trailing: Checkbox(
            key: Key(widget.dailyInfo.birthControl.toString()),
            value: widget.dailyInfo.birthControl,
            onChanged: (checked) {
              widget.dailyInfo.birthControl = !widget.dailyInfo.birthControl;
              _updateDailyInfo();
            }));
  }

  Padding _createTemperatureCheck() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          flex: 5,
          child: Text(
            AppLocalizations.of(context)!.temperature,
            style: const TextStyle(color: CUSTOM_RED, fontWeight: FontWeight.w400),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextFormField(
              key: Key(widget.dailyInfo.temperature.toString()),
              keyboardType: TextInputType.number,
              initialValue: widget.dailyInfo.temperature.toString(),
              maxLength: 4,
              textAlign: TextAlign.end,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
                _setTemperature(widget.dailyInfo.temperature.toString());
              },
              onFieldSubmitted: _setTemperature),
        )
      ]),
    );
  }

  void _setTemperature(String? value) {
    widget.dailyInfo.temperature =
        double.tryParse(value ?? DEFAULT_AVERAGE_TEMPERATURE.toString()) ?? DEFAULT_AVERAGE_TEMPERATURE;
  }

  Padding _createSexType() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        Expanded(
            flex: 5,
            child: Text(
              AppLocalizations.of(context)!.hadSex,
              style: const TextStyle(color: CUSTOM_RED, fontWeight: FontWeight.w400),
            )),
        Expanded(
            flex: 5,
            child: DropdownButtonFormField<SexType>(
              items: _getSexTypeAsDropDown(),
              value: widget.dailyInfo.hadSex,
              decoration: const InputDecoration(contentPadding: EdgeInsets.all(16.0)),
              onChanged: (value) {
                widget.dailyInfo.hadSex = value ?? SexType.NONE;
                _updateDailyInfo();
              },
            ))
      ]),
    );
  }

  Padding _createNotes() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                flex: 5,
                child: Text(
                  AppLocalizations.of(context)!.notes,
                  style: const TextStyle(color: CUSTOM_RED, fontWeight: FontWeight.w400),
                ))
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          Expanded(
              flex: 5,
              child: TextFormField(
                key: Key(widget.dailyInfo.notes),
                initialValue: widget.dailyInfo.notes,
                minLines: 1,
                maxLines: 10,
                onChanged: (value) {
                  widget.dailyInfo.notes = value;
                },
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (widget.dailyInfo.notes.isNotEmpty) {
                    _updateDailyInfo();
                  }
                },
              ))
        ])
      ]),
    );
  }

  List<DropdownMenuItem<SexType>> _getSexTypeAsDropDown() {
    return SexType.values.map((SexType sexType) {
      String displayString;
      switch (sexType) {
        case SexType.NONE:
          displayString = AppLocalizations.of(context)!.sexTypeNo;
          break;
        case SexType.PROTECTED:
          displayString = AppLocalizations.of(context)!.sexTypeProtected;
          break;
        case SexType.UNPROTECTED:
          displayString = AppLocalizations.of(context)!.sexTypeUnprotected;
          break;
      }
      return DropdownMenuItem<SexType>(
        value: sexType,
        child: Text(displayString),
      );
    }).toList();
  }

  Future<void> _updateDailyInfo() async {
    await widget.periodRepository.insertInfoForDay(widget.dailyInfo);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }
}
