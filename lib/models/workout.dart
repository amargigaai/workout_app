import 'exercise.dart';

class Workout {
  final String id;
  final String name;
  final String description;
  final String category; // Strength, Cardio, Flexibility
  final String difficulty; // Beginner, Intermediate, Advanced
  final List<Exercise> exercises;
  final bool isPremium;
  final String? imageAsset;

  Workout({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.difficulty = 'Beginner',
    required this.exercises,
    this.isPremium = false,
    this.imageAsset,
  });

  /// Total workout duration in seconds
  int get totalDurationSeconds {
    return exercises.fold(0, (sum, e) => sum + e.durationSeconds + e.restSeconds);
  }

  /// Total workout duration formatted as "Xm Ys"
  String get formattedDuration {
    final minutes = totalDurationSeconds ~/ 60;
    final seconds = totalDurationSeconds % 60;
    if (seconds == 0) return '${minutes}m';
    return '${minutes}m ${seconds}s';
  }

  /// Number of exercises
  int get exerciseCount => exercises.length;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'exercises': exercises.map((e) => e.toMap()).toList(),
      'isPremium': isPremium,
      'imageAsset': imageAsset,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      category: map['category'] as String? ?? 'Strength',
      difficulty: map['difficulty'] as String? ?? 'Beginner',
      exercises: (map['exercises'] as List<dynamic>?)
              ?.map((e) => Exercise.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      isPremium: map['isPremium'] as bool? ?? false,
      imageAsset: map['imageAsset'] as String?,
    );
  }
}
