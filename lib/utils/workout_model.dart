workoutModel(
    {required String exerciseName,
    required int numberOfReps,
    required int numberOfSets,
    required double weight,
    required bool isDropset}) {
  return <String, dynamic>{
    'exerciseName': exerciseName,
    'numberOfReps': numberOfReps,
    'numberOfSets': numberOfSets,
    'weight': weight,
    'completionRatio': 0.0,
    'isDropset': isDropset,
    'numberOfCompletedSets': 0,
  };
}
