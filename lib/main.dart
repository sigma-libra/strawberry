import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:strawberry/calendar_page.dart';
import 'package:strawberry/period/period_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PeriodRepository repository = PeriodRepository();
  await repository.initDatabase();
  initializeDateFormatting().then((_) => runApp(MyApp(repository: repository)));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.repository});

  final PeriodRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strawberry',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: StartPage(
        repository: repository,
      ),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({super.key, required this.repository});

  final PeriodRepository repository;

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
        ));
  }
}
