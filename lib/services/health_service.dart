import 'package:health/health.dart';

class HealthService {
  final Health _health = Health();
  bool _isAuthorized = false;

  bool get isAuthorized => _isAuthorized;

  /// Request authorization to read/write health data
  Future<bool> requestAuthorization() async {
    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.WORKOUT,
    ];

    final permissions = [
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
    ];

    try {
      _isAuthorized = await _health.requestAuthorization(
        types,
        permissions: permissions,
      );
      return _isAuthorized;
    } catch (e) {
      _isAuthorized = false;
      return false;
    }
  }

  /// Write a workout session to health platform
  Future<bool> writeWorkout({
    required DateTime start,
    required DateTime end,
    required double caloriesBurned,
  }) async {
    if (!_isAuthorized) return false;

    try {
      final success = await _health.writeWorkoutData(
        activityType: HealthWorkoutActivityType.HIGH_INTENSITY_INTERVAL_TRAINING,
        start: start,
        end: end,
        totalEnergyBurned: caloriesBurned.round(),
        totalEnergyBurnedUnit: HealthDataUnit.KILOCALORIE,
      );
      return success;
    } catch (e) {
      return false;
    }
  }

  /// Get today's step count
  Future<int> getTodaySteps() async {
    if (!_isAuthorized) return 0;

    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);
      final steps = await _health.getTotalStepsInInterval(midnight, now);
      return steps ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
