import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import '../../services/notification_service.dart';

class ReminderScreen extends ConsumerWidget {
  const ReminderScreen({super.key});

  static const _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reminder Schedule')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time picker
            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Reminder Time'),
                trailing: Text(
                  '${settings.reminderHour.toString().padLeft(2, '0')}:${settings.reminderMinute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: settings.reminderHour,
                      minute: settings.reminderMinute,
                    ),
                  );
                  if (time != null) {
                    ref.read(settingsProvider.notifier).setReminderTime(
                          time.hour,
                          time.minute,
                        );
                  }
                },
              ),
            ),
            const SizedBox(height: 24),

            // Day selector
            Text(
              'Reminder Days',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: List.generate(7, (index) {
                final day = index + 1; // 1=Monday
                final isSelected = settings.reminderDays.contains(day);
                return FilterChip(
                  label: Text(_dayNames[index]),
                  selected: isSelected,
                  onSelected: (_) {
                    final days = List<int>.from(settings.reminderDays);
                    if (isSelected) {
                      days.remove(day);
                    } else {
                      days.add(day);
                    }
                    days.sort();
                    ref.read(settingsProvider.notifier).setReminderDays(days);
                  },
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                );
              }),
            ),
            const SizedBox(height: 32),

            // Save button
            ElevatedButton(
              onPressed: () async {
                final notificationService = NotificationService();
                await notificationService.initialize();
                await notificationService.requestPermissions();
                await notificationService.scheduleDailyReminder(
                  hour: settings.reminderHour,
                  minute: settings.reminderMinute,
                  weekdays: settings.reminderDays,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reminders updated!')),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Reminders'),
            ),
          ],
        ),
      ),
    );
  }
}
