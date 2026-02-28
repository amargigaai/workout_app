class UserProfile {
  final String uid;
  final String? email;
  final String? displayName;
  final int? age;
  final double? weightKg;
  final String fitnessLevel; // Beginner, Intermediate, Advanced
  final String fitnessGoal; // Weight Loss, Muscle Tone, General Fitness
  final bool isPremium;
  final DateTime createdAt;

  UserProfile({
    required this.uid,
    this.email,
    this.displayName,
    this.age,
    this.weightKg,
    this.fitnessLevel = 'Beginner',
    this.fitnessGoal = 'General Fitness',
    this.isPremium = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  UserProfile copyWith({
    String? uid,
    String? email,
    String? displayName,
    int? age,
    double? weightKg,
    String? fitnessLevel,
    String? fitnessGoal,
    bool? isPremium,
    DateTime? createdAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      age: age ?? this.age,
      weightKg: weightKg ?? this.weightKg,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'age': age,
      'weightKg': weightKg,
      'fitnessLevel': fitnessLevel,
      'fitnessGoal': fitnessGoal,
      'isPremium': isPremium,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] as String,
      email: map['email'] as String?,
      displayName: map['displayName'] as String?,
      age: map['age'] as int?,
      weightKg: (map['weightKg'] as num?)?.toDouble(),
      fitnessLevel: map['fitnessLevel'] as String? ?? 'Beginner',
      fitnessGoal: map['fitnessGoal'] as String? ?? 'General Fitness',
      isPremium: map['isPremium'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
