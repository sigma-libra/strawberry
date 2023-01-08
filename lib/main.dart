import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:strawberry/calendar_page.dart';
import 'package:strawberry/period/period_repository.dart';
import 'package:strawberry/period/period_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PeriodService service = PeriodService();
  PeriodRepository repository = PeriodRepository();
  await repository.initDatabase();
  initializeDateFormatting().then((_) => runApp(MyApp(
        repository: repository,
        service: service,
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.repository, required this.service});

  final PeriodRepository repository;
  final PeriodService service;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strawberry',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: StartPage(
        repository: repository,
        service: service,
      ),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({super.key, required this.repository, required this.service});

  final PeriodRepository repository;
  final PeriodService service;

  @override
  StartPageState createState() => StartPageState();
}

class StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Strawberry'),
        ),
        body: Calendar(
          repository: widget.repository,
          service: widget.service,
        ));
  }
}
