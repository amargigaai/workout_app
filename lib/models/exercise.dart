class Exercise {
  final String id;
  final String name;
  final String description;
  final String formTips;
  final int durationSeconds;
  final int restSeconds;
  final String? imageAsset;
  final String? animationAsset;
  final String targetMuscles;
  final IconType iconType;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    this.formTips = '',
    this.durationSeconds = 30,
    this.restSeconds = 10,
    this.imageAsset,
    this.animationAsset,
    this.targetMuscles = '',
    this.iconType = IconType.exercise,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'formTips': formTips,
      'durationSeconds': durationSeconds,
      'restSeconds': restSeconds,
      'imageAsset': imageAsset,
      'animationAsset': animationAsset,
      'targetMuscles': targetMuscles,
      'iconType': iconType.name,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      formTips: map['formTips'] as String? ?? '',
      durationSeconds: map['durationSeconds'] as int? ?? 30,
      restSeconds: map['restSeconds'] as int? ?? 10,
      imageAsset: map['imageAsset'] as String?,
      animationAsset: map['animationAsset'] as String?,
      targetMuscles: map['targetMuscles'] as String? ?? '',
      iconType: IconType.values.firstWhere(
        (e) => e.name == (map['iconType'] as String? ?? 'exercise'),
        orElse: () => IconType.exercise,
      ),
    );
  }

  /// Total time including rest
  int get totalTime => durationSeconds + restSeconds;
}

enum IconType {
  exercise,
  cardio,
  strength,
  flexibility,
  balance,
}
