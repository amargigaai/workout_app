import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import '../services/audio_service.dart';

enum TimerPhase { ready, work, rest, complete }

class WorkoutTimerState {
  final TimerPhase phase;
  final int currentExerciseIndex;
  final int secondsRemaining;
  final bool isPaused;
  final Workout workout;
  final int totalElapsedSeconds;

  WorkoutTimerState({
    required this.phase,
    required this.currentExerciseIndex,
    required this.secondsRemaining,
    required this.isPaused,
    required this.workout,
    this.totalElapsedSeconds = 0,
  });

  Exercise get currentExercise => workout.exercises[currentExerciseIndex];
  bool get isLastExercise => currentExerciseIndex >= workout.exercises.length - 1;
  double get overallProgress =>
      (currentExerciseIndex + (phase == TimerPhase.rest ? 0.5 : 0)) /
      workout.exercises.length;

  WorkoutTimerState copyWith({
    TimerPhase? phase,
    int? currentExerciseIndex,
    int? secondsRemaining,
    bool? isPaused,
    Workout? workout,
    int? totalElapsedSeconds,
  }) {
    return WorkoutTimerState(
      phase: phase ?? this.phase,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isPaused: isPaused ?? this.isPaused,
      workout: workout ?? this.workout,
      totalElapsedSeconds: totalElapsedSeconds ?? this.totalElapsedSeconds,
    );
  }
}

class WorkoutTimerNotifier extends StateNotifier<WorkoutTimerState?> {
  Timer? _timer;
  final AudioService _audioService;

  WorkoutTimerNotifier(this._audioService) : super(null);

  void startWorkout(Workout workout) {
    _timer?.cancel();
    state = WorkoutTimerState(
      phase: TimerPhase.ready,
      currentExerciseIndex: 0,
      secondsRemaining: 3, // 3-second countdown before start
      isPaused: false,
      workout: workout,
    );
    _startTicking();
  }

  void _startTicking() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (state == null || state!.isPaused) return;

    final s = state!;

    if (s.secondsRemaining > 1) {
      // Countdown tick for last 3 seconds
      if (s.secondsRemaining <= 4 && s.phase != TimerPhase.ready) {
        _audioService.playCountdownTick();
      }
      state = s.copyWith(
        secondsRemaining: s.secondsRemaining - 1,
        totalElapsedSeconds: s.totalElapsedSeconds + 1,
      );
    } else {
      // Transition to next phase
      _transitionPhase();
    }
  }

  void _transitionPhase() {
    final s = state!;

    switch (s.phase) {
      case TimerPhase.ready:
        // Start first exercise
        _audioService.playTransitionBeep();
        state = s.copyWith(
          phase: TimerPhase.work,
          secondsRemaining: s.currentExercise.durationSeconds,
          totalElapsedSeconds: s.totalElapsedSeconds + 1,
        );
        break;

      case TimerPhase.work:
        if (s.isLastExercise && s.currentExercise.restSeconds == 0) {
          // Workout complete
          _audioService.playComplete();
          state = s.copyWith(
            phase: TimerPhase.complete,
            totalElapsedSeconds: s.totalElapsedSeconds + 1,
          );
          _timer?.cancel();
        } else if (s.currentExercise.restSeconds > 0) {
          // Go to rest
          _audioService.playRestStart();
          state = s.copyWith(
            phase: TimerPhase.rest,
            secondsRemaining: s.currentExercise.restSeconds,
            totalElapsedSeconds: s.totalElapsedSeconds + 1,
          );
        } else {
          // No rest, go to next exercise
          _moveToNextExercise();
        }
        break;

      case TimerPhase.rest:
        if (s.isLastExercise) {
          // Workout complete
          _audioService.playComplete();
          state = s.copyWith(
            phase: TimerPhase.complete,
            totalElapsedSeconds: s.totalElapsedSeconds + 1,
          );
          _timer?.cancel();
        } else {
          _moveToNextExercise();
        }
        break;

      case TimerPhase.complete:
        _timer?.cancel();
        break;
    }
  }

  void _moveToNextExercise() {
    final s = state!;
    final nextIndex = s.currentExerciseIndex + 1;
    _audioService.playTransitionBeep();
    state = s.copyWith(
      phase: TimerPhase.work,
      currentExerciseIndex: nextIndex,
      secondsRemaining: s.workout.exercises[nextIndex].durationSeconds,
      totalElapsedSeconds: s.totalElapsedSeconds + 1,
    );
  }

  void togglePause() {
    if (state == null) return;
    state = state!.copyWith(isPaused: !state!.isPaused);
  }

  void skipExercise() {
    if (state == null) return;
    _transitionPhase();
  }

  void stopWorkout() {
    _timer?.cancel();
    // Don't null the state so we can read final stats
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final audioServiceProvider = Provider<AudioService>((ref) => AudioService());

final workoutTimerProvider =
    StateNotifierProvider<WorkoutTimerNotifier, WorkoutTimerState?>((ref) {
  final audioService = ref.read(audioServiceProvider);
  return WorkoutTimerNotifier(audioService);
});
