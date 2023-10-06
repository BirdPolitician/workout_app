import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_app/Data/database.dart';

double roundBoxRadius = 16;

Color backgroundColor = const Color(0xFF464762);
Color solidColor = const Color(0xFF1b2447);
Color interactColor = const Color(0xFF2b4e95);
Color highlightColor = const Color(0xFF282c3c);
Color textColor = const Color(0xFFe3e3dd);

TextStyle headingTextStyle = GoogleFonts.oswald(
    fontWeight: FontWeight.bold, fontSize: 30, color: textColor);
TextStyle subHeadingTextStyle = GoogleFonts.oswald(
    fontWeight: FontWeight.bold, fontSize: 20, color: textColor);
TextStyle bodyTextStyle = GoogleFonts.oswald(
    fontWeight: FontWeight.w600, fontSize: 20, color: textColor);

sizeableHeadingTextStyle<TextStyle>(fontSize) {
  fontSize = fontSize.toDouble();
  return GoogleFonts.oswald(
      fontWeight: FontWeight.bold, fontSize: fontSize, color: textColor);
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: subHeadingTextStyle,
      ),
    ),
  );
}

final Map<String, WorkoutDataBase> databases = {
  'monday': WorkoutDataBase(day: 'monday'),
  'tuesday': WorkoutDataBase(day: 'tuesday'),
  'wednesday': WorkoutDataBase(day: 'wednesday'),
  'thursday': WorkoutDataBase(day: 'thursday'),
  'friday': WorkoutDataBase(day: 'friday'),
  'saturday': WorkoutDataBase(day: 'saturday'),
  'sunday': WorkoutDataBase(day: 'sunday'),
};

void resetAllCompletedSets() {
  for (var database in databases.values) {
    database.loadData();
    database.resetCompletedSets();
  }
}
