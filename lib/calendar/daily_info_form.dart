import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:strawberry/info/model/daily_info.dart';
import 'package:strawberry/info/model/sex_type.dart';

class DailyInfoForm extends StatefulWidget {
  DailyInfoForm(DateTime date, DailyInfo? dailyInfo, {Key? key})
      : dailyInfo = dailyInfo ?? DailyInfo.create(date),
        super(key: key);

  final DailyInfo dailyInfo;

  @override
  DailyInfoFormState createState() {
    return DailyInfoFormState();
  }
}

class DailyInfoFormState extends State<DailyInfoForm> {
  final _formKey = GlobalKey<FormState>();

  late DailyInfo _dailyInfo;

  @override
  void initState() {
    _dailyInfo = widget.dailyInfo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Daily Info"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createSexTypeField(),
              _createBirthControlCheck(),
              _createTemperatureField(),
              _createNotesField(),
              _createSubmissionButton(screenSize.width)
            ],
          ),
        ),
      ),
    );
  }

  Checkbox _createBirthControlCheck() {
    return Checkbox(
        key: Key(_dailyInfo.birthControl.toString()),
        value: _dailyInfo.birthControl,
        onChanged: (checked) {
          _dailyInfo.birthControl = !_dailyInfo.birthControl;
        });
  }

  FormField _createNotesField() {
    return TextFormField(
        key: Key(_dailyInfo.notes),
        initialValue: _dailyInfo.temperature.toString(),
        decoration: const InputDecoration(
            hintText: "Notes",
            labelText: "Notes",
            contentPadding: EdgeInsets.all(16.0)),
        onSaved: (value) {
          _dailyInfo.notes = value ?? "";
        });
  }

  FormField _createTemperatureField() {
    return TextFormField(
        key: Key(_dailyInfo.temperature.toString()),
        keyboardType: TextInputType.number,
        validator: _validateTemperature,
        initialValue: _dailyInfo.temperature.toString(),
        maxLength: 3,
        decoration: const InputDecoration(
            hintText: "Temperature",
            labelText: "Temperature",
            contentPadding: EdgeInsets.all(16.0)),
        onSaved: (value) {
          _dailyInfo.temperature = double.tryParse(value ?? "0") ?? 0;
        });
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

  FormField _createSexTypeField() {
    return DropdownButtonFormField<SexType>(
      items: _getSexTypeAsDropDown(),
      value: _dailyInfo.sex,
      onChanged: (newValue) {
        setState(() {
          _dailyInfo.sex = newValue!;
        });
      },
      decoration: const InputDecoration(
          hintText: "Had protected/unprotected sex",
          labelText: "Type of sex",
          contentPadding: EdgeInsets.all(16.0)),
      onSaved: (value) {
        _dailyInfo.sex = value ?? SexType.NONE;
      },
    );
  }

  List<DropdownMenuItem<SexType>> _getSexTypeAsDropDown() {
    return SexType.values.map((SexType sexType) {
      return DropdownMenuItem<SexType>(
        value: sexType,
        child: Text(sexTypes[sexType]!.toString()),
      );
    }).toList();
  }

  SizedBox _createSubmissionButton(double screenWidth) {
    return SizedBox(
      width: screenWidth,
      height: 88.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
        child: ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ),
    );
  }

  void _submit() {
    // First validate form.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      developer.log(
          "Creating daily info for day ${_dailyInfo.date} with id ${_dailyInfo.id}");
      Navigator.pop(context, _dailyInfo);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid input")));
      developer.log("New daily info invalid");
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    super.dispose();
  }
}
