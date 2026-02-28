import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';
import '../models/workout_session.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── User Profile ──────────────────────────────────────────

  Future<void> saveUserProfile(UserProfile profile) async {
    await _db.collection('users').doc(profile.uid).set(profile.toMap());
  }

  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserProfile.fromMap(doc.data()!);
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  // ── Workout Sessions ──────────────────────────────────────

  Future<void> saveWorkoutSession(String uid, WorkoutSession session) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .doc(session.id)
        .set(session.toMap());
  }

  Future<List<WorkoutSession>> getWorkoutSessions(String uid) async {
    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .orderBy('completedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => WorkoutSession.fromMap(doc.data()))
        .toList();
  }

  Future<List<WorkoutSession>> getRecentSessions(String uid, {int limit = 7}) async {
    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .orderBy('completedAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => WorkoutSession.fromMap(doc.data()))
        .toList();
  }

  // ── Subscription ──────────────────────────────────────────

  Future<void> updateSubscriptionStatus(String uid, bool isPremium) async {
    await _db.collection('users').doc(uid).update({'isPremium': isPremium});
  }
}
