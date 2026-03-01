import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/routes.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),

              // Appearance
              _SectionHeader(title: 'Appearance'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.brightness_6),
                      title: const Text('Theme'),
                      trailing: DropdownButton<ThemeMode>(
                        value: settings.themeMode,
                        underline: const SizedBox(),
                        onChanged: (mode) {
                          if (mode != null) {
                            ref.read(settingsProvider.notifier).setThemeMode(mode);
                          }
                        },
                        items: const [
                          DropdownMenuItem(
                            value: ThemeMode.system,
                            child: Text('System'),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.light,
                            child: Text('Light'),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Text('Dark'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Workout
              _SectionHeader(title: 'Workout'),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.volume_up),
                      title: const Text('Sound Effects'),
                      subtitle: const Text('Beeps and voice cues during workout'),
                      value: settings.soundEnabled,
                      onChanged: (_) {
                        ref.read(settingsProvider.notifier).toggleSound();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Notifications
              _SectionHeader(title: 'Notifications'),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications),
                      title: const Text('Workout Reminders'),
                      subtitle: const Text('Daily reminder to exercise'),
                      value: settings.remindersEnabled,
                      onChanged: (value) {
                        ref.read(settingsProvider.notifier).setRemindersEnabled(value);
                      },
                    ),
                    if (settings.remindersEnabled)
                      ListTile(
                        leading: const Icon(Icons.schedule),
                        title: const Text('Reminder Schedule'),
                        subtitle: Text(
                          '${settings.reminderHour.toString().padLeft(2, '0')}:${settings.reminderMinute.toString().padLeft(2, '0')}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.reminders),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Premium
              _SectionHeader(title: 'Premium'),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.star, color: Colors.amber),
                  title: const Text('Upgrade to Premium'),
                  subtitle: const Text('Remove ads, unlock advanced workouts'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.subscription),
                ),
              ),
              const SizedBox(height: 16),

              // App info
              Center(
                child: Text(
                  '7-Minute Workout v1.0.0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
