// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:workout_app/utils/global_variables.dart';
import 'package:workout_app/widgets/box_counter.dart';
import 'package:workout_app/widgets/text_field.dart';

class WorkoutCard extends StatefulWidget {
  final Map exercise;
  final ValueChanged<double> onWeightChanged;
  final ValueChanged<int> onRepsChanged;
  final ValueChanged<String> onNameChanged; // <-- Add this
  final ValueChanged<int> completedSetsChanged;
  final ValueChanged<bool> onDropsetChanged;
  final VoidCallback onDelete;
  const WorkoutCard(
      {Key? key,
      required this.onDropsetChanged,
      required this.completedSetsChanged,
      required this.onDelete,
      required this.exercise,
      required this.onWeightChanged,
      required this.onRepsChanged,
      required this.onNameChanged}) // <-- And this
      : super(key: key);

  @override
  State<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  double done = 0.0;
  double completionRatio = 0;
  double weight = 0;
  int reps = 0;
  final TextEditingController _weightControllerText = TextEditingController();
  final TextEditingController _repControllerText = TextEditingController();
  final TextEditingController _nameControllerText = TextEditingController();
  int numberOfSets = 0;
  int numberOfCompletedSets = 0;
  Map<String, double>? dataMap;
  @override
  void initState() {
    super.initState();
    if (widget.exercise['numberOfCompletedSets'] == null) {
      widget.exercise['numberOfCompletedSets'] = 0;
    }
    numberOfCompletedSets = widget.exercise['numberOfCompletedSets'];
    completionRatio = widget.exercise['completionRatio'];
    weight = widget.exercise['weight'].toDouble();
    reps = widget.exercise['numberOfReps'];
    numberOfSets = widget.exercise['numberOfSets'];
    _weightControllerText.text = weight.toString();
    _repControllerText.text = reps.toString();
    _weightControllerText.addListener(() {
      updateWeight();
    });
    _repControllerText.addListener(() {
      updateReps();
    });
    _nameControllerText.text = widget.exercise['exerciseName'];
    _nameControllerText.addListener(() {
      updateName();
    });
  }

  @override
  void dispose() {
    _repControllerText.removeListener(updateWeight);
    _repControllerText.dispose();
    _weightControllerText.removeListener(updateReps);
    _weightControllerText.dispose();
    _nameControllerText.removeListener(updateName);
    _nameControllerText.dispose();
    super.dispose();
  }

  double get newWeight {
    if (weight != 0) {
      return weight;
    } else {
      return 0.0;
    }
  }

  int get newReps {
    if (reps != 0) {
      return reps;
    } else {
      return 0;
    }
  }

  void updateWeight() {
    double newWeight = double.tryParse(_weightControllerText.text) ?? 0.0;
    if (newWeight != 0) {
      setState(() {
        weight = newWeight;
      });
      widget.onWeightChanged(weight);
    } else {
      setState(() {
        weight = 0.0;
      });
      widget.onWeightChanged(weight);
    }
  }

  void updateReps() {
    int newReps = int.tryParse(_repControllerText.text) ?? 0;
    if (newReps != 0) {
      setState(() {
        reps = newReps;
      });
      widget.onRepsChanged(reps);
    } else {
      setState(() {
        reps = 0;
      });
      widget.onRepsChanged(reps);
    }
  }

  void updateDropset() {
    bool newDropset = !widget.exercise['isDropset'];
    widget.onDropsetChanged(newDropset);
  }

  void updateName() {
    String newName = _nameControllerText.text;
    if (newName != '') {
      widget.onNameChanged(newName);
    }
  }

  @override
  Widget build(BuildContext context) {
    numberOfCompletedSets = widget.exercise['numberOfCompletedSets'];
    double w = MediaQuery.of(context).size.width;
    double titleSize = widget.exercise['exerciseName'].length >= 18
        ? 540 / widget.exercise['exerciseName'].length
        : 30;
    int numberOfSets = widget.exercise['numberOfSets'];
    double completionRatio = numberOfCompletedSets / numberOfSets;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
                color: highlightColor,
                border: Border.all(color: Colors.transparent),
                borderRadius:
                    BorderRadius.all(Radius.circular(roundBoxRadius))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ExpansionTile(
                  collapsedIconColor: textColor,
                  iconColor: interactColor,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, top: 4),
                        child: SizedBox(
                          height: 35,
                          width: 35,
                          child: completionRatio == 1
                              ? const Image(
                                  color: Colors.green,
                                  image: AssetImage('lib/icons/done.png'))
                              : completionRatio > 0
                                  ? const Image(
                                      color: Colors.orange,
                                      image: AssetImage(
                                          'lib/icons/in_progress.png'))
                                  : const Image(
                                      color: Colors.red,
                                      image:
                                          AssetImage('lib/icons/not_done.png')),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 0, top: 0, bottom: 0, right: 4),
                          child: TextFieldInputSecondStyle(
                            hintText: widget.exercise['exerciseName'],
                            textEditingController: _nameControllerText,
                            textInputType: TextInputType.name,
                          ),
                        ),
                      )
                    ],
                  ),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8, top: 8, bottom: 3),
                          child: InkWell(
                            onTap: updateDropset,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: interactColor,
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(roundBoxRadius))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Dropset?',
                                      style: subHeadingTextStyle,
                                    ),
                                    Transform.scale(
                                      scale: 2,
                                      child: Checkbox(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          side: MaterialStateBorderSide
                                              .resolveWith(
                                            (states) => BorderSide(
                                                width: 1.0,
                                                color: interactColor),
                                          ),
                                          activeColor: interactColor,
                                          value: widget.exercise['isDropset'],
                                          onChanged: (newBool) {
                                            updateDropset();
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // widget.exercise['isDropset']
                    //     ? Row(
                    //         children: [
                    //           Padding(
                    //             padding: const EdgeInsets.only(left: 16.0),
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(5.0),
                    //               child: Text('- Dropset',
                    //                   style: subHeadingTextStyle),
                    //             ),
                    //           ),
                    //         ],
                    //       )
                    //     : Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Text(
                                    'PR',
                                    style: subHeadingTextStyle,
                                  ),
                                ),
                                SizedBox(
                                    width: 100,
                                    height: 40,
                                    child: TextFieldInput(
                                      hintText: _weightControllerText.text,
                                      textEditingController:
                                          _weightControllerText,
                                      textInputType: TextInputType.number,
                                      thatGoodShit: true,
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Row(
                              children: [
                                Text(
                                  'Reps - ',
                                  style: subHeadingTextStyle,
                                ),
                                SizedBox(
                                    height: 40,
                                    width: 100,
                                    child: TextFieldInput(
                                      hintText: _repControllerText.text,
                                      textEditingController: _repControllerText,
                                      textInputType: TextInputType.number,
                                      thatGoodShit: true,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            BoxCounter(
                                numberOfExcersises:
                                    widget.exercise['numberOfSets'],
                                numberOfCompletedExcersises:
                                    numberOfCompletedSets,
                                onAdd: () {
                                  if (numberOfCompletedSets != numberOfSets) {
                                    setState(() {
                                      widget.completedSetsChanged(
                                          numberOfCompletedSets + 1);
                                    });
                                  }
                                },
                                onSubtract: () {
                                  if (numberOfCompletedSets != 0) {
                                    setState(() {
                                      widget.completedSetsChanged(
                                          numberOfCompletedSets - 1);
                                    });
                                  }
                                }),
                            const Expanded(
                                child: SizedBox(
                              height: 1,
                            )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 8.0, bottom: 8),
                              child: IconButton(
                                  onPressed: widget.onDelete,
                                  icon: const Icon(
                                    Icons.delete_outlined,
                                    color: Colors.white,
                                    size: 40,
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: highlightColor,
          endIndent: 10,
          indent: 10,
          thickness: 3,
        )
      ],
    );
  }
}
