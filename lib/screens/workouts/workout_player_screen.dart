import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:uuid/uuid.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../config/constants.dart';
import '../../models/workout.dart';
import '../../models/workout_session.dart';
import '../../providers/auth_provider.dart';
import '../../providers/progress_provider.dart';
import '../../providers/timer_provider.dart';

class WorkoutPlayerScreen extends ConsumerStatefulWidget {
  const WorkoutPlayerScreen({super.key});

  @override
  ConsumerState<WorkoutPlayerScreen> createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends ConsumerState<WorkoutPlayerScreen> {
  bool _started = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  void _startWorkout(Workout workout) {
    ref.read(workoutTimerProvider.notifier).startWorkout(workout);
    setState(() => _started = true);
  }

  Future<void> _onWorkoutComplete(WorkoutTimerState timerState) async {
    final user = ref.read(authServiceProvider).currentUser;
    if (user == null) return;

    final session = WorkoutSession(
      id: const Uuid().v4(),
      workoutId: timerState.workout.id,
      workoutName: timerState.workout.name,
      completedAt: DateTime.now(),
      durationSeconds: timerState.totalElapsedSeconds,
      exercisesCompleted: timerState.currentExerciseIndex + 1,
      totalExercises: timerState.workout.exercises.length,
      caloriesBurned: WorkoutSession.estimateCalories(
        metValue: AppConstants.metCircuitTraining,
        weightKg: 70, // Default weight; would use user profile weight in production
        durationSeconds: timerState.totalElapsedSeconds,
      ),
    );

    await ref.read(progressProvider.notifier).addSession(user.uid, session);
  }

  @override
  Widget build(BuildContext context) {
    final workout = ModalRoute.of(context)!.settings.arguments as Workout;
    final timerState = ref.watch(workoutTimerProvider);

    // Auto-start on first build
    if (!_started) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startWorkout(workout));
    }

    if (timerState == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Handle workout complete
    if (timerState.phase == TimerPhase.complete) {
      return _buildCompleteScreen(context, timerState);
    }

    return Scaffold(
      backgroundColor: _getPhaseColor(timerState.phase, context),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => _showQuitDialog(context),
                  ),
                  Text(
                    _getPhaseLabel(timerState.phase),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${timerState.currentExerciseIndex + 1}/${timerState.workout.exercises.length}',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: timerState.overallProgress,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 4,
                ),
              ),
            ),

            const Spacer(),

            // Exercise name
            Text(
              timerState.phase == TimerPhase.ready
                  ? 'Get Ready!'
                  : timerState.phase == TimerPhase.rest
                      ? 'Rest'
                      : timerState.currentExercise.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Form tips (during work phase)
            if (timerState.phase == TimerPhase.work)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  timerState.currentExercise.formTips,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // Next exercise preview (during rest)
            if (timerState.phase == TimerPhase.rest && !timerState.isLastExercise)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Next: ${timerState.workout.exercises[timerState.currentExerciseIndex + 1].name}',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 32),

            // Countdown ring
            CircularPercentIndicator(
              radius: 100,
              lineWidth: 12,
              percent: _getTimerPercent(timerState),
              center: Text(
                '${timerState.secondsRemaining}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                ),
              ),
              progressColor: Colors.white,
              backgroundColor: Colors.white24,
              circularStrokeCap: CircularStrokeCap.round,
              animation: false,
            ),

            const Spacer(),

            // Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Skip (go back or skip forward)
                  _ControlButton(
                    icon: Icons.skip_previous,
                    label: 'Previous',
                    onPressed: timerState.currentExerciseIndex > 0
                        ? () {
                            // Simple: just skip to next transition
                          }
                        : null,
                  ),

                  // Pause / Resume
                  _ControlButton(
                    icon: timerState.isPaused ? Icons.play_arrow : Icons.pause,
                    label: timerState.isPaused ? 'Resume' : 'Pause',
                    isLarge: true,
                    onPressed: () {
                      ref.read(workoutTimerProvider.notifier).togglePause();
                    },
                  ),

                  // Skip forward
                  _ControlButton(
                    icon: Icons.skip_next,
                    label: 'Skip',
                    onPressed: () {
                      ref.read(workoutTimerProvider.notifier).skipExercise();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCompleteScreen(BuildContext context, WorkoutTimerState timerState) {
    // Save the session
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onWorkoutComplete(timerState);
    });

    final minutes = timerState.totalElapsedSeconds ~/ 60;
    final seconds = timerState.totalElapsedSeconds % 60;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 56,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Workout Complete!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Great job finishing ${timerState.workout.name}!',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _CompleteStat(
                      label: 'Duration',
                      value: '${minutes}m ${seconds}s',
                    ),
                    _CompleteStat(
                      label: 'Exercises',
                      value: '${timerState.currentExerciseIndex + 1}',
                    ),
                    _CompleteStat(
                      label: 'Calories',
                      value: '~${WorkoutSession.estimateCalories(
                        metValue: AppConstants.metCircuitTraining,
                        weightKg: 70,
                        durationSeconds: timerState.totalElapsedSeconds,
                      ).toInt()}',
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                ElevatedButton(
                  onPressed: () {
                    ref.read(workoutTimerProvider.notifier).stopWorkout();
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _getTimerPercent(WorkoutTimerState state) {
    int total;
    switch (state.phase) {
      case TimerPhase.ready:
        total = 3;
        break;
      case TimerPhase.work:
        total = state.currentExercise.durationSeconds;
        break;
      case TimerPhase.rest:
        total = state.currentExercise.restSeconds;
        break;
      case TimerPhase.complete:
        return 1.0;
    }
    return (state.secondsRemaining / total).clamp(0.0, 1.0);
  }

  Color _getPhaseColor(TimerPhase phase, BuildContext context) {
    switch (phase) {
      case TimerPhase.ready:
        return Colors.blueGrey.shade700;
      case TimerPhase.work:
        return Theme.of(context).colorScheme.primary;
      case TimerPhase.rest:
        return Colors.teal.shade600;
      case TimerPhase.complete:
        return Colors.green.shade600;
    }
  }

  String _getPhaseLabel(TimerPhase phase) {
    switch (phase) {
      case TimerPhase.ready:
        return 'GET READY';
      case TimerPhase.work:
        return 'WORK';
      case TimerPhase.rest:
        return 'REST';
      case TimerPhase.complete:
        return 'COMPLETE';
    }
  }

  void _showQuitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quit Workout?'),
        content: const Text('Your progress for this workout will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep Going'),
          ),
          TextButton(
            onPressed: () {
              ref.read(workoutTimerProvider.notifier).stopWorkout();
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Quit'),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isLarge;

  const _ControlButton({
    required this.icon,
    required this.label,
    this.onPressed,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = isLarge ? 72.0 : 56.0;
    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              foregroundColor: Colors.white,
              minimumSize: Size(size, size),
            ),
            child: Icon(icon, size: isLarge ? 36 : 28),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

class _CompleteStat extends StatelessWidget {
  final String label;
  final String value;

  const _CompleteStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
