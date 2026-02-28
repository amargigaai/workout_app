import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  bool _isMuted = false;

  bool get isMuted => _isMuted;

  void toggleMute() {
    _isMuted = !_isMuted;
  }

  /// Play a short beep for exercise transition
  Future<void> playTransitionBeep() async {
    if (_isMuted) return;
    await HapticFeedback.mediumImpact();
    // Uses system sound as fallback when no custom audio asset is present
    await _player.play(AssetSource('audio/beep.mp3')).catchError((_) {
      // Fallback: haptic only
    });
  }

  /// Play a countdown tick (3, 2, 1)
  Future<void> playCountdownTick() async {
    if (_isMuted) return;
    await HapticFeedback.lightImpact();
    await _player.play(AssetSource('audio/tick.mp3')).catchError((_) {});
  }

  /// Play workout complete fanfare
  Future<void> playComplete() async {
    if (_isMuted) return;
    await HapticFeedback.heavyImpact();
    await _player.play(AssetSource('audio/complete.mp3')).catchError((_) {});
  }

  /// Play rest start chime
  Future<void> playRestStart() async {
    if (_isMuted) return;
    await _player.play(AssetSource('audio/rest.mp3')).catchError((_) {});
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
