import 'package:flutter/material.dart';
import 'package:workout_app/utils/global_variables.dart';

class BoxCounter extends StatelessWidget {
  final int numberOfExcersises;
  final int numberOfCompletedExcersises;
  final VoidCallback onAdd;
  final VoidCallback onSubtract;

  const BoxCounter(
      {Key? key,
      required this.numberOfExcersises,
      required this.numberOfCompletedExcersises,
      required this.onAdd,
      required this.onSubtract})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double ogBoxSize = 20;
    double widthCalculator =
        numberOfExcersises <= 8 ? ogBoxSize : 160 / numberOfExcersises;
    int i = 0;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: List<Widget>.generate(numberOfExcersises, (index) {
              if (i < numberOfCompletedExcersises) {
                i++;
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(width: 3, color: textColor)),
                  height: ogBoxSize,
                  width: widthCalculator,
                );
              } else {
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 3, color: textColor)),
                  height: ogBoxSize,
                  width: widthCalculator,
                );
              }
            }),
          ),
        ),
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            if (numberOfCompletedExcersises != 0) {
              onSubtract();
            }
          },
          icon: Icon(
            Icons.remove_circle_outline,
            size: 35,
            color: textColor,
          ),
        ),
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            if (numberOfCompletedExcersises != numberOfExcersises) {
              onAdd();
            }
          },
          icon: Icon(
            Icons.add_circle_outline,
            size: 35,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
