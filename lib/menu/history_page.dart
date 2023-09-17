import 'package:flutter/material.dart';
import 'package:strawberry/model/period.dart';
import 'package:strawberry/period/repository/period_repository.dart';
import 'package:strawberry/period/service/period_service.dart';
import 'package:strawberry/utils/colors.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.repository, required this.service});

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
        builder: (BuildContext context, AsyncSnapshot<List<DateTime>> snapshot) {
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
                body: _makeHistoryList(snapshot.requireData.toList()));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  ListView _makeHistoryList(List<DateTime> periodDays) {
    List<Period> periods = widget.service.splitDaysIntoPeriods(periodDays).reversed.toList();
    return ListView.builder(
      itemCount: periods.length,
      itemBuilder: (context, index) {
        return Card(
          shadowColor: CUSTOM_YELLOW,
          elevation: 2,
          child: ListTile(
            title: Text(periods[index].prettyString()),
            textColor: CUSTOM_BLUE,
          ),
        );
      },
    );
  }
}
