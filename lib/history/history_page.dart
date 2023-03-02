import 'package:flutter/material.dart';
import 'package:strawberry/period/model/period.dart';
import 'package:strawberry/period/model/period_day.dart';
import 'package:strawberry/period/repository/period_repository.dart';
import 'package:strawberry/period/service/period_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage(
      {super.key, required this.repository, required this.service});

  final PeriodRepository repository;
  final PeriodService service;

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.repository.getPeriodDates(),
        builder:
            (BuildContext context, AsyncSnapshot<List<DateTime>> snapshot) {
          if (snapshot.hasError) {
            return Text(
              'There was an error :(',
              style: Theme.of(context).textTheme.displayLarge,
            );
          } else if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("History"),
                ),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_makeHistoryList(snapshot.requireData.toList())],
                ));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget _makeHistoryList(List<DateTime> periodDays) {
    List<Period> periods = widget.service.getSortedPeriods(periodDays).reversed.toList();
    List<ListTile> tiles = periods.map((period) => period.asListTile()).toList();
    return Flexible(
        child: ListView(
      children: tiles
    ));
  }
}
