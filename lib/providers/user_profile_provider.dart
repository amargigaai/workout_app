import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../services/firestore_service.dart';
import 'auth_provider.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final authState = ref.watch(authStateProvider);
  final user = authState.valueOrNull;
  if (user == null) return null;

  final firestore = ref.read(firestoreServiceProvider);
  return await firestore.getUserProfile(user.uid);
});

/// Notifier to manage user profile state
class UserProfileNotifier extends StateNotifier<UserProfile?> {
  final FirestoreService _firestore;

  UserProfileNotifier(this._firestore) : super(null);

  Future<void> loadProfile(String uid) async {
    state = await _firestore.getUserProfile(uid);
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _firestore.saveUserProfile(profile);
    state = profile;
  }

  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    await _firestore.updateUserProfile(uid, data);
    state = await _firestore.getUserProfile(uid);
  }
}

final userProfileNotifierProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  final firestore = ref.read(firestoreServiceProvider);
  return UserProfileNotifier(firestore);
});
