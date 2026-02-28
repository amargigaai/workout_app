class AppConstants {
  AppConstants._();

  static const String appName = '7-Minute Workout';
  static const String appVersion = '1.0.0';

  // Default workout timing (in seconds)
  static const int defaultWorkDuration = 30;
  static const int defaultRestDuration = 10;
  static const int defaultExerciseCount = 12;

  // Calorie estimation: MET value for circuit training
  static const double metCircuitTraining = 8.0;

  // Streak
  static const int streakResetHours = 48;

  // Notifications
  static const int defaultReminderHour = 8;
  static const int defaultReminderMinute = 0;

  // Monetization
  static const String monthlySubscriptionId = 'premium_monthly';
  static const String annualSubscriptionId = 'premium_annual';
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111'; // Test ad

  // Fitness levels
  static const List<String> fitnessLevels = ['Beginner', 'Intermediate', 'Advanced'];

  // Fitness goals
  static const List<String> fitnessGoals = ['Weight Loss', 'Muscle Tone', 'General Fitness'];

  // Workout categories
  static const List<String> workoutCategories = ['Strength', 'Cardio', 'Flexibility', 'All'];

  // Motivational messages
  static const List<String> motivationalMessages = [
    'Every workout counts! Keep going! 💪',
    'You\'re stronger than you think!',
    'Just 7 minutes can change your day!',
    'Consistency beats perfection.',
    'Your future self will thank you!',
    'Small steps lead to big results.',
    'Don\'t stop when you\'re tired. Stop when you\'re done!',
    'Progress, not perfection.',
  ];
}
