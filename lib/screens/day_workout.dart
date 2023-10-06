import 'package:flutter/material.dart';
import 'package:workout_app/Data/database.dart';
import 'package:workout_app/utils/global_variables.dart';
import 'package:workout_app/utils/workout_model.dart';
import 'package:workout_app/widgets/notes_page.dart';
import 'package:workout_app/widgets/text_field.dart';
import 'package:workout_app/widgets/workout_card.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workout_app/screens/home_screen.dart';

class DayWorkout extends StatefulWidget {
  final String day;

  const DayWorkout({Key? key, required this.day}) : super(key: key);

  @override
  State<DayWorkout> createState() => _DayWorkoutState();
}

class _DayWorkoutState extends State<DayWorkout> {
  final TextEditingController _exerciseNameController = TextEditingController();
  final TextEditingController _numberOfRepsController = TextEditingController();
  final TextEditingController _numberOfSetsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  late final Box myBox;
  late WorkoutDataBase wdb;

  double completionRatio = 0;
  Map<String, double>? dataMap;
  bool isChecked = false;
  double done = 0.0;

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
    _notesController.text = wdb.note;
  }

  @override
  void dispose() {
    _exerciseNameController.dispose();
    _numberOfRepsController.dispose();
    _notesController.dispose();
    _numberOfSetsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void clearScreen() {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
    _exerciseNameController.clear();
    _numberOfRepsController.clear();
    _numberOfSetsController.clear();
    _weightController.clear();
    isChecked = false;
  }

  void addStrengthWorkout(
      exerciseName, numberOfReps, numberOfSets, weight, isDropset) {
    setState(() {
      wdb.exercises[_exerciseNameController.text] = workoutModel(
          exerciseName: exerciseName,
          numberOfReps: numberOfReps,
          numberOfSets: numberOfSets,
          weight: weight,
          isDropset: isDropset);
    });
    wdb.updateDataBase();
    completionRatio = wdb.getCompletionRatio();
  }

  void deleteExercise(String exerciseKey) {
    setState(() {
      wdb.exercises.remove(exerciseKey);
      wdb.updateDataBase();
    });
    completionRatio = wdb.getCompletionRatio();
  }

  void onSubmit() {
    setState(() {
      wdb.note = _notesController.text;
    });
    wdb.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    done = completionRatio;
    dataMap = {'done': done, 'notDone': 1 - done};
    double w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const HomeScreen(),
          ),
        );
        return false; // return false to prevent the navigator from "popping"
      },
      child: Scaffold(
        floatingActionButton: Container(
          decoration: BoxDecoration(
            color: solidColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
              iconSize: 50,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => NotesPage(
                          controller: _notesController,
                          onSubmit: onSubmit,
                        ));
              },
              icon: Icon(
                Icons.menu,
                color: interactColor,
              )),
        ),
        body: Column(
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
              child: SafeArea(
                child:
                    //AppBar Content
                    Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Title
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pushReplacement<void, void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const HomeScreen(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: interactColor,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.day[0].toUpperCase() +
                                widget.day.substring(1),
                            style: headingTextStyle,
                          ),
                        ),
                      ],
                    ),
                    //Pie Chart
                    dataMap == null
                        ? CircleAvatar(
                            radius: 35,
                            backgroundColor: textColor,
                          )
                        : InkWell(
                            // onTap: () => setState(() {
                            //   wdb.resetCompletedSets();
                            // }),
                            // onTap: () => print(wdb.exercises),
                            // onTap: () {
                            //   setState(() {
                            //     myBox.clear();
                            //   });
                            // },
                            child: PieChart(
                              chartRadius: 90,
                              colorList: const [
                                Colors.greenAccent,
                                Colors.redAccent
                              ],
                              chartValuesOptions: const ChartValuesOptions(
                                  showChartValues: false),
                              dataMap: dataMap!,
                              legendOptions:
                                  const LegendOptions(showLegends: false),
                            ),
                          ),
                    //Edit Workout
                    TextButton(
                      onPressed: () {
                        openDialog();
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.edit,
                            size: 80,
                            color: interactColor,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            //WorkoutCards
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...wdb.exercises.entries
                        .map((entry) => WorkoutCard(
                              key: ValueKey(entry
                                  .key), // Unique key based on the exercise's name.
                              completedSetsChanged: (sets) {
                                setState(() {
                                  wdb.exercises.update(entry.key,
                                      (existingExercise) {
                                    existingExercise['numberOfCompletedSets'] =
                                        sets;
                                    return existingExercise;
                                  });
                                  wdb.updateDataBase();
                                  setState(() {
                                    completionRatio = wdb.getCompletionRatio();
                                  });
                                });
                              },
                              onDropsetChanged: (state) {
                                setState(() {
                                  wdb.exercises.update(entry.key,
                                      (existingExercise) {
                                    existingExercise['isDropset'] = state;
                                    return existingExercise;
                                  });
                                  wdb.updateDataBase();
                                  setState(() {
                                    completionRatio = wdb.getCompletionRatio();
                                  });
                                });
                              },
                              onWeightChanged: (weight) {
                                setState(() {
                                  wdb.exercises.update(entry.key,
                                      (existingExercise) {
                                    existingExercise['weight'] = weight;
                                    return existingExercise;
                                  });
                                  wdb.updateDataBase();
                                });
                              },
                              onRepsChanged: (reps) {
                                setState(() {
                                  wdb.exercises.update(entry.key,
                                      (existingExercise) {
                                    existingExercise['numberOfReps'] = reps;
                                    return existingExercise;
                                  });
                                  wdb.updateDataBase();
                                });
                              },
                              onNameChanged: (newName) {
                                setState(() {
                                  wdb.exercises.update(entry.key,
                                      (existingExercise) {
                                    existingExercise['exerciseName'] = newName;
                                    return existingExercise;
                                  });
                                  wdb.updateDataBase();
                                });
                              },
                              onDelete: () {
                                setState(() {
                                  delete(entry.key);
                                });
                              },
                              exercise: entry.value,
                            ))
                        .toList(),
                    const SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void delete(String exerciseKey) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: highlightColor,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You sure bro?',
              style: headingTextStyle,
            ),
            const Expanded(child: SizedBox()),
            IconButton(
              iconSize: 30,
              onPressed: cancel,
              icon: const Icon(
                Icons.cancel,
              ),
              color: textColor,
            )
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(interactColor)),
              onPressed: () {
                deleteExercise(exerciseKey);
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.delete),
              label: Column(
                children: [
                  Text(
                    'Delete Exercise?',
                    style: bodyTextStyle,
                  ),
                  Text(
                    '- $exerciseKey -',
                    style: subHeadingTextStyle,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        // Added StatefulBuilder
        builder: (context, setState) => SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: highlightColor,
            iconPadding: const EdgeInsets.only(left: 210),
            icon: IconButton(
              iconSize: 50,
              onPressed: cancel,
              icon: const Icon(
                Icons.cancel_outlined,
              ),
            ),
            title: Text(
              'NEW EXERCISE LES GO!',
              style: subHeadingTextStyle,
            ),
            content: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: interactColor, width: 3),
                  borderRadius:
                      BorderRadius.all(Radius.circular(roundBoxRadius))),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFieldInput(
                      textEditingController: _exerciseNameController,
                      hintText: 'Name of the exercise',
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldInput(
                      textEditingController: _numberOfRepsController,
                      hintText: 'Reps',
                      textInputType: TextInputType.number,
                      thatGoodShit: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldInput(
                      textEditingController: _numberOfSetsController,
                      hintText: 'Sets',
                      textInputType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldInput(
                      textEditingController: _weightController,
                      hintText: 'PR (KG)',
                      textInputType: TextInputType.number,
                      thatGoodShit: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 4,
                            color: interactColor,
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(roundBoxRadius))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Dropset?',
                              style: headingTextStyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Transform.scale(
                                scale: 1.7,
                                child: Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: MaterialStateBorderSide.resolveWith(
                                      (states) => BorderSide(
                                          width: 1.0, color: interactColor),
                                    ),
                                    checkColor: textColor,
                                    value: isChecked,
                                    activeColor: interactColor,
                                    onChanged: (value) {
                                      setState(() {
                                        isChecked
                                            ? isChecked = false
                                            : isChecked = true;
                                      });
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              const Expanded(
                  child: SizedBox(
                height: 1,
              )),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(interactColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(roundBoxRadius),
                    ),
                  ),
                ),
                onPressed: () {
                  submit();
                },
                child: Text(
                  'ADD',
                  style: headingTextStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void cancel() {
    clearScreen();
  }

  void submit() {
    if (_exerciseNameController.text.isNotEmpty) {
      _numberOfRepsController.text.trim();
      _numberOfSetsController.text.trim();
      int? numberOfSets = int.tryParse(_numberOfSetsController.text);
      if (_numberOfRepsController.text.isNotEmpty &&
          _numberOfSetsController.text.isNotEmpty &&
          int.tryParse(_numberOfRepsController.text) != null &&
          int.tryParse(_numberOfRepsController.text)! > 0 &&
          numberOfSets != null &&
          numberOfSets > 0) {
        if (int.parse(_numberOfSetsController.text) <= 30) {
          addStrengthWorkout(
              _exerciseNameController.text,
              int.parse(_numberOfRepsController.text),
              numberOfSets,
              double.parse(_weightController.text),
              isChecked);
          clearScreen();
        } else {
          FocusManager.instance.primaryFocus?.unfocus();
          showSnackBar(
              'Please have less than 30 sets -For Ashton, nice try bitch',
              context);
        }
      } else {
        FocusManager.instance.primaryFocus?.unfocus();
        showSnackBar(
            'Pls make sure the sets/reps are whole numbers! -For Ashton, nice try bitch',
            context);
      }
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
      showSnackBar('Pls Give this Exercise a name! -For Ashton, nice try bitch',
          context);
    }
  }
}
