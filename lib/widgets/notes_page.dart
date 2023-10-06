// ignore_for_file: sized_box_for_whitespace, unused_local_variable

import 'package:flutter/material.dart';
import 'package:workout_app/utils/global_variables.dart';
import 'package:workout_app/widgets/text_field.dart';

class NotesPage extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  const NotesPage({Key? key, required this.controller, required this.onSubmit})
      : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: SingleChildScrollView(
        child: AlertDialog(
          backgroundColor: solidColor,
          title: Center(
            child: Text(
              'Notes',
              style: headingTextStyle,
            ),
          ),
          content: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius:
                    BorderRadius.all(Radius.circular(roundBoxRadius))),
            height: h * 0.5,
            child: MultiLineTextFieldInput(
              hintText: widget.controller.text,
              textEditingController: widget.controller,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
                onPressed: () {
                  widget.onSubmit();
                  clearScreen();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: interactColor,
                      border: Border.all(color: Colors.transparent),
                      borderRadius:
                          BorderRadius.all(Radius.circular(roundBoxRadius))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'SUBMIT',
                      style: subHeadingTextStyle,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void clearScreen() {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
  }
}
