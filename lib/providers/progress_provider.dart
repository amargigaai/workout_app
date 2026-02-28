import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout_session.dart';
import '../services/firestore_service.dart';
import 'user_profile_provider.dart';

class ProgressState {
  final List<WorkoutSession> sessions;
  final int currentStreak;
  final int longestStreak;
  final double totalCalories;
  final int totalWorkouts;
  final bool isLoading;

  ProgressState({
    this.sessions = const [],
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalCalories = 0,
    this.totalWorkouts = 0,
    this.isLoading = false,
  });

  ProgressState copyWith({
    List<WorkoutSession>? sessions,
    int? currentStreak,
    int? longestStreak,
    double? totalCalories,
    int? totalWorkouts,
    bool? isLoading,
  }) {
    return ProgressState(
      sessions: sessions ?? this.sessions,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalCalories: totalCalories ?? this.totalCalories,
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ProgressNotifier extends StateNotifier<ProgressState> {
  final FirestoreService _firestore;

  ProgressNotifier(this._firestore) : super(ProgressState());

  Future<void> loadSessions(String uid) async {
    state = state.copyWith(isLoading: true);
    final sessions = await _firestore.getWorkoutSessions(uid);
    final streak = _calculateStreak(sessions);
    final longest = _calculateLongestStreak(sessions);
    final totalCal = sessions.fold<double>(0, (sum, s) => sum + s.caloriesBurned);

    state = ProgressState(
      sessions: sessions,
      currentStreak: streak,
      longestStreak: longest,
      totalCalories: totalCal,
      totalWorkouts: sessions.length,
      isLoading: false,
    );
  }

  Future<void> addSession(String uid, WorkoutSession session) async {
    await _firestore.saveWorkoutSession(uid, session);
    await loadSessions(uid);
  }

  int _calculateStreak(List<WorkoutSession> sessions) {
    if (sessions.isEmpty) return 0;

    // Group sessions by date
    final dates = sessions
        .map((s) => DateTime(s.completedAt.year, s.completedAt.month, s.completedAt.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Check if there's a session today or yesterday
    if (dates.isEmpty) return 0;
    final diff = todayDate.difference(dates.first).inDays;
    if (diff > 1) return 0;

    int streak = 1;
    for (int i = 0; i < dates.length - 1; i++) {
      if (dates[i].difference(dates[i + 1]).inDays == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  int _calculateLongestStreak(List<WorkoutSession> sessions) {
    if (sessions.isEmpty) return 0;

    final dates = sessions
        .map((s) => DateTime(s.completedAt.year, s.completedAt.month, s.completedAt.day))
        .toSet()
        .toList()
      ..sort();

    int longest = 1;
    int current = 1;

    for (int i = 1; i < dates.length; i++) {
      if (dates[i].difference(dates[i - 1]).inDays == 1) {
        current++;
        if (current > longest) longest = current;
      } else {
        current = 1;
      }
    }
    return longest;
  }

  /// Get sessions for the current week (Mon-Sun)
  List<WorkoutSession> get thisWeekSessions {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeek = DateTime(monday.year, monday.month, monday.day);

    return state.sessions
        .where((s) => s.completedAt.isAfter(startOfWeek))
        .toList();
  }
}

final progressProvider =
    StateNotifierProvider<ProgressNotifier, ProgressState>((ref) {
  final firestore = ref.read(firestoreServiceProvider);
  return ProgressNotifier(firestore);
});
