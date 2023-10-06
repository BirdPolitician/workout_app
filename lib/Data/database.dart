import 'package:hive_flutter/hive_flutter.dart';

class WorkoutDataBase {
  final String day;
  Map<String, Map<String, dynamic>> exercises = {};
  String note = '';

  WorkoutDataBase({required this.day}) : myBox = Hive.box(day);

  final Box myBox;

  // This will be what they see if they have never opened the app before
  void createInitialData() {
    exercises = {};
    note = 'Write down tips, notes or any additional info you might need!';
  }

  void loadData() {
    var exerciseData = myBox.get('exercises');
    if (exerciseData != null) {
      exercises = exerciseData.map<String, Map<String, dynamic>>((key, value) =>
          MapEntry<String, Map<String, dynamic>>(
              key as String, Map<String, dynamic>.from(value)));
    }
    var noteData = myBox.get('note');
    if (noteData != null) {
      note = noteData as String;
    }
  }

  void updateDataBase() {
    myBox.put('exercises', exercises);
    myBox.put('note', note);
  }

  double getCompletionRatio() {
    double totalRatio = 0;
    int numExercises = exercises.length;

    exercises.forEach((key, value) {
      int numberOfSets = value['numberOfSets'];
      int numberOfCompletedSets = value['numberOfCompletedSets'];

      if (numberOfSets > 0) {
        double ratio = numberOfCompletedSets / numberOfSets;
        totalRatio += ratio;
      }
    });

    if (numExercises == 0) {
      return 0.0; // Handle division by zero
    }

    return totalRatio / numExercises;
  }

  void resetCompletedSets() {
    exercises.forEach((key, value) {
      value['numberOfCompletedSets'] = 0;
    });
    updateDataBase();
  }
}
