class WorkoutSession {
  final String id;
  final String workoutId;
  final String workoutName;
  final DateTime completedAt;
  final int durationSeconds;
  final int exercisesCompleted;
  final int totalExercises;
  final double caloriesBurned;

  WorkoutSession({
    required this.id,
    required this.workoutId,
    required this.workoutName,
    required this.completedAt,
    required this.durationSeconds,
    required this.exercisesCompleted,
    required this.totalExercises,
    required this.caloriesBurned,
  });

  /// Whether the full workout was completed
  bool get isComplete => exercisesCompleted >= totalExercises;

  /// Formatted duration
  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workoutId': workoutId,
      'workoutName': workoutName,
      'completedAt': completedAt.toIso8601String(),
      'durationSeconds': durationSeconds,
      'exercisesCompleted': exercisesCompleted,
      'totalExercises': totalExercises,
      'caloriesBurned': caloriesBurned,
    };
  }

  factory WorkoutSession.fromMap(Map<String, dynamic> map) {
    return WorkoutSession(
      id: map['id'] as String,
      workoutId: map['workoutId'] as String,
      workoutName: map['workoutName'] as String? ?? '',
      completedAt: DateTime.parse(map['completedAt'] as String),
      durationSeconds: map['durationSeconds'] as int? ?? 0,
      exercisesCompleted: map['exercisesCompleted'] as int? ?? 0,
      totalExercises: map['totalExercises'] as int? ?? 0,
      caloriesBurned: (map['caloriesBurned'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Estimate calories burned using MET formula
  /// Calories = MET × weight(kg) × duration(hours)
  static double estimateCalories({
    required double metValue,
    required double weightKg,
    required int durationSeconds,
  }) {
    final hours = durationSeconds / 3600.0;
    return metValue * weightKg * hours;
  }
}
