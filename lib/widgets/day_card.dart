import 'package:flutter/material.dart';
import 'package:workout_app/Data/database.dart';
import 'package:workout_app/utils/global_variables.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pie_chart/pie_chart.dart';

class DayCard extends StatefulWidget {
  final StatefulWidget widget;
  final String day;
  const DayCard({
    Key? key,
    required this.widget,
    required this.day,
  }) : super(key: key);

  @override
  State<DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> {
  double done = 0;
  double completionRatio = 0;
  late final Box myBox;
  late WorkoutDataBase wdb;
  Map<String, double>? dataMap;

  @override
  void initState() {
    super.initState();

    myBox = Hive.box(widget.day);
    wdb = WorkoutDataBase(day: widget.day);
    //If this is the first time the user loads the app
    if (myBox.get('exercises') == null) {
      wdb.createInitialData();
    } else {
      wdb.loadData();
    }
    completionRatio = wdb.getCompletionRatio();
  }

  @override
  Widget build(BuildContext context) {
    done = completionRatio;
    dataMap = {'done': done, 'notDone': 1 - done};
    double w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
      child: InkWell(
          onTap: () {
            Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => widget.widget,
              ),
            );
          },
          child: Container(
              width: w,
              height: 80,
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 5,
                    color: highlightColor,
                  ),
                  borderRadius:
                      BorderRadius.all(Radius.circular(roundBoxRadius))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      widget.day,
                      style: headingTextStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0.0),
                    child: PieChart(
                      chartRadius: 90,
                      colorList: const [Colors.greenAccent, Colors.redAccent],
                      chartValuesOptions:
                          const ChartValuesOptions(showChartValues: false),
                      dataMap: dataMap!,
                      legendOptions: const LegendOptions(showLegends: false),
                    ),
                  ),
                ],
              ))),
    );
  }
}
