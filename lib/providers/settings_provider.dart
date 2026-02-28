import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final ThemeMode themeMode;
  final bool soundEnabled;
  final bool remindersEnabled;
  final int reminderHour;
  final int reminderMinute;
  final List<int> reminderDays; // 1=Monday ... 7=Sunday

  SettingsState({
    this.themeMode = ThemeMode.system,
    this.soundEnabled = true,
    this.remindersEnabled = true,
    this.reminderHour = 8,
    this.reminderMinute = 0,
    this.reminderDays = const [1, 2, 3, 4, 5, 6, 7],
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    bool? soundEnabled,
    bool? remindersEnabled,
    int? reminderHour,
    int? reminderMinute,
    List<int>? reminderDays,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      reminderDays: reminderDays ?? this.reminderDays,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt('themeMode') ?? 0;
    final soundEnabled = prefs.getBool('soundEnabled') ?? true;
    final remindersEnabled = prefs.getBool('remindersEnabled') ?? true;
    final reminderHour = prefs.getInt('reminderHour') ?? 8;
    final reminderMinute = prefs.getInt('reminderMinute') ?? 0;
    final reminderDays = prefs.getStringList('reminderDays')
            ?.map((e) => int.parse(e))
            .toList() ??
        [1, 2, 3, 4, 5, 6, 7];

    state = SettingsState(
      themeMode: ThemeMode.values[themeModeIndex],
      soundEnabled: soundEnabled,
      remindersEnabled: remindersEnabled,
      reminderHour: reminderHour,
      reminderMinute: reminderMinute,
      reminderDays: reminderDays,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
  }

  Future<void> toggleSound() async {
    state = state.copyWith(soundEnabled: !state.soundEnabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', state.soundEnabled);
  }

  Future<void> setRemindersEnabled(bool enabled) async {
    state = state.copyWith(remindersEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remindersEnabled', enabled);
  }

  Future<void> setReminderTime(int hour, int minute) async {
    state = state.copyWith(reminderHour: hour, reminderMinute: minute);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminderHour', hour);
    await prefs.setInt('reminderMinute', minute);
  }

  Future<void> setReminderDays(List<int> days) async {
    state = state.copyWith(reminderDays: days);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('reminderDays', days.map((e) => e.toString()).toList());
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
