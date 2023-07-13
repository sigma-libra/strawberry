import 'package:flutter/material.dart';

import 'package:strawberry/period/service/period_service.dart';
import 'package:strawberry/utils/colors.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key, required this.service});

  final PeriodService service;

  @override
  StatsPageState createState() => StatsPageState();
}

class StatsPageState extends State<StatsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Stats"),
        ),
        body: _makeStats());
  }

  ListView _makeStats() {
    final stats = widget.service.getStats();
    return ListView(children: [
      _statEntry("Period length", stats.periodLength),
      _statEntry("Cycle length", stats.cycleLength),
    ]);
  }

  Card _statEntry(String label, int value) {
    return Card(
      shadowColor: CUSTOM_YELLOW,
      elevation: 2,
      child: ListTile(
        title: Text(label),
        trailing: Text(value.toString()),
        textColor: CUSTOM_BLUE,
      ),
    );
  }
}
