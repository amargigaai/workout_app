import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exercise.dart';
import '../models/workout.dart';

// ── Seed Data ────────────────────────────────────────────────

final List<Workout> _seedWorkouts = [
  // 7-Minute Classic
  Workout(
    id: 'classic_7min',
    name: '7-Minute Classic',
    description: 'The original scientifically-backed 7-minute high-intensity circuit training workout.',
    category: 'Cardio',
    difficulty: 'Intermediate',
    exercises: [
      Exercise(id: 'e1', name: 'Jumping Jacks', description: 'Full body cardio warmup.', formTips: 'Land softly on the balls of your feet. Keep arms fully extended.', targetMuscles: 'Full Body', iconType: IconType.cardio),
      Exercise(id: 'e2', name: 'Wall Sit', description: 'Isometric lower body hold.', formTips: 'Keep back flat against the wall. Knees at 90 degrees.', targetMuscles: 'Quadriceps, Glutes', iconType: IconType.strength),
      Exercise(id: 'e3', name: 'Push-Ups', description: 'Upper body pressing movement.', formTips: 'Keep core tight. Lower chest to the floor. Full range of motion.', targetMuscles: 'Chest, Triceps, Shoulders', iconType: IconType.strength),
      Exercise(id: 'e4', name: 'Abdominal Crunches', description: 'Core strengthening exercise.', formTips: 'Don\'t pull on your neck. Exhale as you crunch up.', targetMuscles: 'Abdominals', iconType: IconType.strength),
      Exercise(id: 'e5', name: 'Step-Up onto Chair', description: 'Single-leg lower body exercise.', formTips: 'Use a sturdy chair. Drive through your heel. Alternate legs.', targetMuscles: 'Quadriceps, Glutes', iconType: IconType.strength),
      Exercise(id: 'e6', name: 'Squats', description: 'Fundamental lower body movement.', formTips: 'Keep chest up. Push knees out over toes. Go as low as comfortable.', targetMuscles: 'Quadriceps, Glutes, Hamstrings', iconType: IconType.strength),
      Exercise(id: 'e7', name: 'Tricep Dips on Chair', description: 'Tricep isolation using bodyweight.', formTips: 'Keep elbows pointing back. Lower until upper arms are parallel to floor.', targetMuscles: 'Triceps', iconType: IconType.strength),
      Exercise(id: 'e8', name: 'Plank', description: 'Core stabilization hold.', formTips: 'Maintain a straight line from head to heels. Don\'t let hips sag.', targetMuscles: 'Core', iconType: IconType.strength),
      Exercise(id: 'e9', name: 'High Knees Running', description: 'Cardio with core engagement.', formTips: 'Drive knees to hip height. Pump arms. Stay on balls of feet.', targetMuscles: 'Full Body', iconType: IconType.cardio),
      Exercise(id: 'e10', name: 'Lunges', description: 'Unilateral lower body movement.', formTips: 'Keep front knee over ankle. Step far enough forward. Alternate legs.', targetMuscles: 'Quadriceps, Glutes', iconType: IconType.strength),
      Exercise(id: 'e11', name: 'Push-Up with Rotation', description: 'Push-up with rotational core work.', formTips: 'Rotate fully to the side at the top. Keep hips stable.', targetMuscles: 'Chest, Core, Shoulders', iconType: IconType.strength),
      Exercise(id: 'e12', name: 'Side Plank', description: 'Lateral core stabilization.', formTips: 'Stack feet or stagger them. Keep hips lifted. Hold each side 15s.', targetMuscles: 'Obliques, Core', iconType: IconType.strength),
    ],
  ),

  // Beginner
  Workout(
    id: 'beginner_easy',
    name: 'Beginner Basics',
    description: 'A gentle introduction to bodyweight training. Perfect for fitness newcomers.',
    category: 'Strength',
    difficulty: 'Beginner',
    exercises: [
      Exercise(id: 'b1', name: 'Marching in Place', description: 'Low-impact cardio warmup.', formTips: 'Lift knees to a comfortable height. Swing arms naturally.', durationSeconds: 30, restSeconds: 15, targetMuscles: 'Full Body', iconType: IconType.cardio),
      Exercise(id: 'b2', name: 'Wall Push-Ups', description: 'Beginner-friendly push-up variation.', formTips: 'Place hands shoulder-width on wall. Keep body straight.', durationSeconds: 30, restSeconds: 15, targetMuscles: 'Chest, Arms', iconType: IconType.strength),
      Exercise(id: 'b3', name: 'Seated Knee Lifts', description: 'Core exercise from a seated position.', formTips: 'Sit tall. Lift one knee at a time. Engage your core.', durationSeconds: 30, restSeconds: 15, targetMuscles: 'Core', iconType: IconType.strength),
      Exercise(id: 'b4', name: 'Standing Calf Raises', description: 'Lower leg strengthening.', formTips: 'Rise up on your toes slowly. Hold briefly at the top.', durationSeconds: 30, restSeconds: 15, targetMuscles: 'Calves', iconType: IconType.strength),
      Exercise(id: 'b5', name: 'Half Squats', description: 'Partial range squat for beginners.', formTips: 'Only go halfway down. Keep weight in heels.', durationSeconds: 30, restSeconds: 15, targetMuscles: 'Quadriceps, Glutes', iconType: IconType.strength),
      Exercise(id: 'b6', name: 'Standing Side Leg Raises', description: 'Hip abductor strengthening.', formTips: 'Hold onto a chair for balance. Keep leg straight.', durationSeconds: 30, restSeconds: 15, targetMuscles: 'Hip Abductors', iconType: IconType.strength),
      Exercise(id: 'b7', name: 'Modified Plank (Knees)', description: 'Core hold from knees.', formTips: 'Keep a straight line from head to knees. Engage core.', durationSeconds: 20, restSeconds: 15, targetMuscles: 'Core', iconType: IconType.strength),
      Exercise(id: 'b8', name: 'Standing Arm Circles', description: 'Shoulder mobility and warmup.', formTips: 'Start with small circles, gradually increase. Both directions.', durationSeconds: 30, restSeconds: 15, targetMuscles: 'Shoulders', iconType: IconType.flexibility),
      Exercise(id: 'b9', name: 'Glute Bridges', description: 'Glute and hamstring activation.', formTips: 'Press through heels. Squeeze glutes at the top.', durationSeconds: 30, restSeconds: 15, targetMuscles: 'Glutes, Hamstrings', iconType: IconType.strength),
      Exercise(id: 'b10', name: 'Bird Dogs', description: 'Core stability and balance.', formTips: 'Extend opposite arm and leg. Keep core tight and back flat.', durationSeconds: 30, restSeconds: 15, targetMuscles: 'Core, Back', iconType: IconType.balance),
      Exercise(id: 'b11', name: 'Standing Toe Touches', description: 'Hamstring flexibility.', formTips: 'Bend from hips. Don\'t bounce. Go as far as comfortable.', durationSeconds: 30, restSeconds: 15, targetMuscles: 'Hamstrings', iconType: IconType.flexibility),
      Exercise(id: 'b12', name: 'Deep Breathing', description: 'Cooldown and recovery.', formTips: 'Breathe in for 4 counts, hold 4, out for 4. Relax.', durationSeconds: 30, restSeconds: 0, targetMuscles: 'Full Body', iconType: IconType.flexibility),
    ],
  ),

  // Advanced
  Workout(
    id: 'advanced_hiit',
    name: 'Advanced HIIT Blast',
    description: 'High-intensity interval training for experienced athletes. Push your limits!',
    category: 'Cardio',
    difficulty: 'Advanced',
    isPremium: true,
    exercises: [
      Exercise(id: 'a1', name: 'Burpees', description: 'Full body explosive movement.', formTips: 'Chest to floor on the push-up. Jump explosively.', durationSeconds: 40, restSeconds: 10, targetMuscles: 'Full Body', iconType: IconType.cardio),
      Exercise(id: 'a2', name: 'Pistol Squats (Alternating)', description: 'Single-leg squat.', formTips: 'Extend free leg forward. Use a wall for balance if needed.', durationSeconds: 40, restSeconds: 10, targetMuscles: 'Quadriceps, Glutes', iconType: IconType.strength),
      Exercise(id: 'a3', name: 'Diamond Push-Ups', description: 'Tricep-focused push-up.', formTips: 'Hands close together forming a diamond. Elbows tight to body.', durationSeconds: 40, restSeconds: 10, targetMuscles: 'Triceps, Chest', iconType: IconType.strength),
      Exercise(id: 'a4', name: 'V-Ups', description: 'Advanced core exercise.', formTips: 'Touch toes at the top. Keep legs and arms straight.', durationSeconds: 40, restSeconds: 10, targetMuscles: 'Abdominals', iconType: IconType.strength),
      Exercise(id: 'a5', name: 'Box Jumps', description: 'Explosive plyometric power.', formTips: 'Land softly with bent knees. Step down, don\'t jump.', durationSeconds: 40, restSeconds: 10, targetMuscles: 'Legs, Glutes', iconType: IconType.cardio),
      Exercise(id: 'a6', name: 'Handstand Push-Ups (Wall)', description: 'Advanced shoulder pressing.', formTips: 'Kick up against a wall. Lower head to floor slowly.', durationSeconds: 40, restSeconds: 10, targetMuscles: 'Shoulders, Triceps', iconType: IconType.strength),
      Exercise(id: 'a7', name: 'Jump Lunges', description: 'Explosive alternating lunges.', formTips: 'Switch legs mid-air. Land softly with control.', durationSeconds: 40, restSeconds: 10, targetMuscles: 'Quadriceps, Glutes', iconType: IconType.cardio),
      Exercise(id: 'a8', name: 'Planche Lean', description: 'Advanced core and shoulder hold.', formTips: 'Lean forward with straight arms. Hold the position.', durationSeconds: 30, restSeconds: 10, targetMuscles: 'Shoulders, Core', iconType: IconType.strength),
      Exercise(id: 'a9', name: 'Mountain Climbers (Fast)', description: 'High-speed core cardio.', formTips: 'Keep hips low. Drive knees to chest rapidly.', durationSeconds: 40, restSeconds: 10, targetMuscles: 'Core, Full Body', iconType: IconType.cardio),
      Exercise(id: 'a10', name: 'Clapping Push-Ups', description: 'Explosive upper body power.', formTips: 'Push off hard enough to clap. Land with soft elbows.', durationSeconds: 30, restSeconds: 10, targetMuscles: 'Chest, Triceps', iconType: IconType.strength),
      Exercise(id: 'a11', name: 'Dragon Flags', description: 'Elite core exercise.', formTips: 'Keep body straight. Lower slowly with control.', durationSeconds: 30, restSeconds: 10, targetMuscles: 'Core', iconType: IconType.strength),
      Exercise(id: 'a12', name: 'Tuck Jumps', description: 'Maximum explosive power.', formTips: 'Bring knees to chest at peak. Land with bent knees.', durationSeconds: 40, restSeconds: 0, targetMuscles: 'Full Body', iconType: IconType.cardio),
    ],
  ),

  // Flexibility & Stretch
  Workout(
    id: 'flexibility_stretch',
    name: 'Flexibility Flow',
    description: 'Gentle stretching routine to improve flexibility and reduce tension.',
    category: 'Flexibility',
    difficulty: 'Beginner',
    exercises: [
      Exercise(id: 'f1', name: 'Neck Rolls', description: 'Gentle neck mobility.', formTips: 'Move slowly. Don\'t force the range of motion.', durationSeconds: 30, restSeconds: 5, targetMuscles: 'Neck', iconType: IconType.flexibility),
      Exercise(id: 'f2', name: 'Shoulder Rolls', description: 'Shoulder joint mobility.', formTips: 'Large circles forward and backward.', durationSeconds: 30, restSeconds: 5, targetMuscles: 'Shoulders', iconType: IconType.flexibility),
      Exercise(id: 'f3', name: 'Cat-Cow Stretch', description: 'Spinal mobility.', formTips: 'Alternate between arching and rounding your back.', durationSeconds: 30, restSeconds: 5, targetMuscles: 'Spine', iconType: IconType.flexibility),
      Exercise(id: 'f4', name: 'Forward Fold', description: 'Hamstring and lower back stretch.', formTips: 'Bend from hips. Let gravity do the work. Bend knees slightly.', durationSeconds: 30, restSeconds: 5, targetMuscles: 'Hamstrings, Back', iconType: IconType.flexibility),
      Exercise(id: 'f5', name: 'Quad Stretch', description: 'Front thigh stretch.', formTips: 'Pull heel toward glute. Keep knees together. Use wall for balance.', durationSeconds: 30, restSeconds: 5, targetMuscles: 'Quadriceps', iconType: IconType.flexibility),
      Exercise(id: 'f6', name: 'Pigeon Pose', description: 'Deep hip opener.', formTips: 'Keep hips square. Don\'t force. Breathe deeply.', durationSeconds: 40, restSeconds: 5, targetMuscles: 'Hips, Glutes', iconType: IconType.flexibility),
      Exercise(id: 'f7', name: 'Seated Spinal Twist', description: 'Rotational spine stretch.', formTips: 'Sit tall. Twist from the core, not shoulders. Both sides.', durationSeconds: 30, restSeconds: 5, targetMuscles: 'Spine, Obliques', iconType: IconType.flexibility),
      Exercise(id: 'f8', name: 'Butterfly Stretch', description: 'Inner thigh and hip stretch.', formTips: 'Press knees toward floor gently. Sit tall.', durationSeconds: 30, restSeconds: 5, targetMuscles: 'Hip Adductors', iconType: IconType.flexibility),
      Exercise(id: 'f9', name: 'Cobra Stretch', description: 'Front body opener.', formTips: 'Keep hips on the floor. Lift chest gently.', durationSeconds: 30, restSeconds: 5, targetMuscles: 'Chest, Abs, Spine', iconType: IconType.flexibility),
      Exercise(id: 'f10', name: 'Child\'s Pose', description: 'Full body relaxation stretch.', formTips: 'Reach arms forward. Sink hips back. Breathe deeply.', durationSeconds: 40, restSeconds: 5, targetMuscles: 'Back, Shoulders, Hips', iconType: IconType.flexibility),
      Exercise(id: 'f11', name: 'Figure-Four Stretch', description: 'Glute and piriformis stretch.', formTips: 'Cross ankle over opposite knee. Pull gently.', durationSeconds: 30, restSeconds: 5, targetMuscles: 'Glutes, Hips', iconType: IconType.flexibility),
      Exercise(id: 'f12', name: 'Savasana (Corpse Pose)', description: 'Final relaxation.', formTips: 'Lie flat. Close eyes. Focus on breathing. Let go of tension.', durationSeconds: 60, restSeconds: 0, targetMuscles: 'Full Body', iconType: IconType.flexibility),
    ],
  ),
];

// ── Providers ────────────────────────────────────────────────

final workoutListProvider = Provider<List<Workout>>((ref) => _seedWorkouts);

final workoutByCategoryProvider = Provider.family<List<Workout>, String>((ref, category) {
  final workouts = ref.watch(workoutListProvider);
  if (category == 'All') return workouts;
  return workouts.where((w) => w.category == category).toList();
});

final workoutByIdProvider = Provider.family<Workout?, String>((ref, id) {
  final workouts = ref.watch(workoutListProvider);
  try {
    return workouts.firstWhere((w) => w.id == id);
  } catch (_) {
    return null;
  }
});

final selectedCategoryProvider = StateProvider<String>((ref) => 'All');
