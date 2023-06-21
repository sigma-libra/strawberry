import 'package:flutter/material.dart';
import 'package:strawberry/model/daily_info.dart';
import 'package:strawberry/model/sex_type.dart';
import 'package:strawberry/period/repository/period_repository.dart';
import 'package:strawberry/utils/colors.dart';
import 'dart:developer' as developer;

import 'package:strawberry/utils/date_time_utils.dart';

class DailyInfoPage extends StatefulWidget {
  DailyInfoPage(this.periodRepository, DateTime? date, DailyInfo? dailyInfo,
      {super.key}) {
    if (dailyInfo != null) {
      this.dailyInfo = dailyInfo;
    } else if (date != null) {
      this.dailyInfo = DailyInfo.create(date);
    } else {
      this.dailyInfo = null;
    }
  }

  final PeriodRepository periodRepository;
  late DailyInfo? dailyInfo;

  @override
  DailyInfoPageState createState() {
    return DailyInfoPageState();
  }
}

class DailyInfoPageState extends State<DailyInfoPage> {
  @override
  Widget build(BuildContext context) {
    final info = widget.dailyInfo;
    if (info == null) {
      return const Text("No day selected");
    } else {
      return Flexible(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            ListTile(
              title: Text(
                "Daily Information",
                style: TextStyle(
                    color: CUSTOM_BLUE,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
            ),
            _makeInfoTile("Date", DateTimeUtils.formatPrettyDate(info.date)),
            _createSexType(info),
            _createBirthControlCheck(info),
            _createTemperatureCheck(info),
            _createNotes(info)
          ],
        ),
      );
    }
  }

  ListTile _makeInfoTile(String title, String value) {
    return ListTile(
      leading: Text(
        title,
        style: TextStyle(color: CUSTOM_RED, fontWeight: FontWeight.w400),
      ),
      trailing: Text(value),
    );
  }

  ListTile _createPeriodCheck(DailyInfo info) {
    return ListTile(
        leading: Text(
          "Had Period",
          style: TextStyle(color: CUSTOM_RED, fontWeight: FontWeight.w400),
        ),
        trailing: Checkbox(
            key: Key(info.hadPeriod.toString()),
            value: info.hadPeriod,
            onChanged: (checked) {
              info.hadPeriod = !info.hadPeriod;
              _editDailyInfo(info);
            }));
  }

  ListTile _createBirthControlCheck(DailyInfo info) {
    return ListTile(
        leading: Text(
          "Birth Control",
          style: TextStyle(color: CUSTOM_RED, fontWeight: FontWeight.w400),
        ),
        trailing: Checkbox(
            key: Key(info.birthControl.toString()),
            value: info.birthControl,
            onChanged: (checked) {
              info.birthControl = !info.birthControl;
              _editDailyInfo(info);
            }));
  }

  Padding _createTemperatureCheck(DailyInfo info) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          flex: 5,
          child: Text(
            "Temperature",
            style: TextStyle(color: CUSTOM_RED, fontWeight: FontWeight.w400),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextFormField(
              key: Key(info.temperature.toString()),
              keyboardType: TextInputType.number,
              validator: _validateTemperature,
              initialValue: info.temperature.toString(),
              maxLength: 4,
              textAlign: TextAlign.end,
              onSaved: (value) {
                info.temperature = double.tryParse(value ?? "0") ?? 0;
                _editDailyInfo(info);
              }),
        )
      ]),
    );
  }

  void setTemperature(DailyInfo info, String value) {
    info.temperature = double.tryParse(value ?? "0") ?? 0;
    _editDailyInfo(info);
  }

  String? _validateTemperature(value) {
    final temperature = double.tryParse(value);
    if (value != null && !value.isEmpty && temperature == null) {
      developer.log("New temperature invalid: $value");
      return 'Please enter a number';
    }
    final nonNullTemperature = temperature ?? 0;
    if (nonNullTemperature < 0) {
      developer.log("New temperature invalid: $value");
      return 'Please enter a positive number';
    }
    return null;
  }

  Padding _createSexType(DailyInfo info) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                flex: 5,
                child: Text(
                  "Had Sex",
                  style:
                      TextStyle(color: CUSTOM_RED, fontWeight: FontWeight.w400),
                )),
            Expanded(
                flex: 5,
                child: DropdownButtonFormField<SexType>(
                  items: _getSexTypeAsDropDown(),
                  value: info.hadSex,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(16.0)),
                  onChanged: (value) {
                    info.hadSex = value ?? SexType.NONE;
                    _editDailyInfo(info);
                  },
                ))
          ]),
    );
  }

  Padding _createNotes(DailyInfo info) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                flex: 5,
                child: Text(
                  "Notes",
                  style:
                      TextStyle(color: CUSTOM_RED, fontWeight: FontWeight.w400),
                ))
          ],
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  flex: 5,
                  child: TextFormField(
                      key: Key(info.notes),
                      initialValue: info.notes.toString(),
                      onSaved: (value) {
                        info.notes = value ?? "";
                        _editDailyInfo(info);
                      }))
            ])
      ]),
    );
  }

  List<DropdownMenuItem<SexType>> _getSexTypeAsDropDown() {
    return SexType.values.map((SexType sexType) {
      return DropdownMenuItem<SexType>(
        value: sexType,
        child: Text(sexType.toDisplayString()),
      );
    }).toList();
  }

  Future<void> _editDailyInfo(DailyInfo info) async {
    setState(() {
      widget.dailyInfo = info;
      widget.periodRepository.insertInfoForDay(info);
    });
  }
}
