import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:workout_app/screens/day_workout.dart';
import 'package:workout_app/utils/global_variables.dart';
import 'package:workout_app/widgets/day_card.dart';
import 'package:hive_flutter/hive_flutter.dart';
// ignore: unused_import
import 'package:workout_app/widgets/text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _weightController = TextEditingController();
  late Box weightBox;
  double weight = 0;
  String? selectedDay1;
  String? selectedDay2;

  @override
  void initState() {
    super.initState();
    weightBox = Hive.box('weight');
    loadWeight();
    _weightController.addListener(() {
      saveWeight();
    });
  }

  void loadWeight() {
    if (weightBox.get('weight') == null) {
      weight = 0;
      saveWeight();
    } else {
      weight = weightBox.get('weight');
      _weightController.text = weight.toString();
    }
  }

  void saveWeight() {
    double newWeight = double.tryParse(_weightController.text) ?? 0.0;
    if (newWeight != 0) {
      setState(() {
        weight = newWeight;
        weightBox.put('weight', weight);
      });
    } else {
      weightBox.put('weight', weight);
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Transform.scale(
          scale: 1.5,
          child: FloatingActionButton(
            onPressed: () {
              openDialog();
            },
            child: const Icon(Icons.move_down_outlined),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //AppBar
            Container(
              width: w,
              decoration: BoxDecoration(
                  color: solidColor,
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(roundBoxRadius),
                      bottomRight: Radius.circular(roundBoxRadius))),
              child: Column(
                children: [
                  SafeArea(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Title
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Plan To Get Shredded',
                            style: headingTextStyle,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            fullReset();
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: interactColor,
                            child: Icon(
                              size: 40,
                              Icons.restart_alt_outlined,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Weight:',
                        style: headingTextStyle,
                      ),
                      SizedBox(
                        width: 100,
                        height: 45,
                        child: TextFieldInputSecondStyleNumbers(
                            textEditingController: _weightController,
                            hintText: _weightController.text),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8)
                ],
              ),
            ),
            //Body content
            const DayCard(widget: DayWorkout(day: 'monday'), day: 'Monday'),
            const DayCard(widget: DayWorkout(day: 'tuesday'), day: 'Tuesday'),
            const DayCard(
                widget: DayWorkout(day: 'wednesday'), day: 'Wednesday'),
            const DayCard(widget: DayWorkout(day: 'thursday'), day: 'Thursday'),
            const DayCard(widget: DayWorkout(day: 'friday'), day: 'Friday'),
            const DayCard(widget: DayWorkout(day: 'saturday'), day: 'Saturday'),
            const DayCard(widget: DayWorkout(day: 'sunday'), day: 'Sunday'),
            const SizedBox(
              height: 120,
            )
          ],
        ),
      ),
    );
  }

  void fullReset() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: solidColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Reset Completed',
              style: headingTextStyle,
            ),
            Text(
              'Exercises?',
              style: headingTextStyle,
            )
          ],
        ),
        content: IconButton(
            splashRadius: 40,
            iconSize: 90,
            onPressed: () {
              refreshExercises();
            },
            icon: Icon(
              Icons.restart_alt,
              color: interactColor,
            )),
      ),
    );
  }

  void clearScreen() {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
  }

  void refreshExercises() {
    setState(() {
      resetAllCompletedSets();
    });
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const HomeScreen(),
      ),
    );
  }

  void openDialog() {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          resetSelectedDays();
          // Custom behavior on back button press, if needed.
          // Returning true allows the pop; returning false prevents it.
          return true;
        },
        child: StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            scrollable: true,
            backgroundColor: highlightColor,
            iconPadding: const EdgeInsets.only(left: 210),
            icon: IconButton(
              iconSize: 50,
              onPressed: () {
                resetSelectedDays();
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.cancel_outlined,
              ),
            ),
            title: Text(
              'Switch Days',
              style: headingTextStyle,
            ),
            content: Column(
              children: [
                // Text(
                //     'Selected day 1${selectedDay1 == null ? '' : ': ${selectedDay1!}'}'),
                // Text(
                //     'Selected day 2${selectedDay2 == null ? '' : ': ${selectedDay2!}'}'),
                //saturday
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Transform.scale(
                    scale: 1.2,
                    child: MaterialButton(
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onPressed: () {
                        if (selectedDay1 != null && selectedDay2 != null) {
                          switcherooi(selectedDay1!, selectedDay2!);
                          resetSelectedDays();
                          Navigator.of(context).pop();
                          Navigator.pushReplacement<void, void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const HomeScreen(),
                            ),
                          );
                        } else {
                          showSnackBar(
                              'Pls select two days to switcheroo', context);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: interactColor.withBlue(200),
                            borderRadius:
                                BorderRadius.circular(roundBoxRadius)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Do the Switcherooi',
                            style: subHeadingTextStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: solidColor,
                  thickness: 3,
                ),
                theSwitchingDayButton(setState, 'monday'),
                theSwitchingDayButton(setState, 'tuesday'),
                theSwitchingDayButton(setState, 'wednesday'),
                theSwitchingDayButton(setState, 'thursday'),
                theSwitchingDayButton(setState, 'friday'),
                theSwitchingDayButton(setState, 'saturday'),
                theSwitchingDayButton(setState, 'sunday'),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void resetSelectedDays() {
    selectedDay1 = null;
    selectedDay2 = null;
  }

  Padding theSwitchingDayButton(StateSetter setState, String day) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: () {
          setState(() {
            selectDay(day);
          });
        },
        child: AnimatedContainer(
          height: 50,
          width: 180,
          decoration: BoxDecoration(
              color: selectedDay1 == day
                  ? backgroundColor
                  : selectedDay2 == day
                      ? backgroundColor
                      : interactColor,
              borderRadius: BorderRadius.circular(roundBoxRadius)),
          duration: const Duration(milliseconds: 400),
          child: Center(
            child: Text(
              day.capitalize(),
              style: headingTextStyle,
            ),
          ),
        ),
      ),
    );
  }

  void selectDay(String day) {
    if (selectedDay1 != null && day != selectedDay1) {
      if (selectedDay2 == day) {
        selectedDay2 = null;
      } else {
        selectedDay2 = day;
      }
    } else if (selectedDay1 == day) {
      selectedDay1 = null;
    } else if (day != selectedDay2) {
      selectedDay1 = day;
    } else {
      selectedDay2 = null;
    }
  }

  void switcherooi(String day1, String day2) {
    Box myBox1 = Hive.box(day1);
    Box myBox2 = Hive.box(day2);
    Box holdingBox = Hive.box('sacrificialLamb');

    holdingBox.put('exercises', myBox2.get('exercises'));
    holdingBox.put('note', myBox2.get('note'));

    myBox2.put('exercises', myBox1.get('exercises'));
    myBox2.put('note', myBox1.get('note'));

    myBox1.put('exercises', holdingBox.get('exercises'));
    myBox1.put('note', holdingBox.get('note'));

    holdingBox.clear();
  }
}
