import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'providers/settings_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/onboarding/health_connect_screen.dart';
import 'screens/onboarding/profile_setup_screen.dart';
import 'screens/onboarding/welcome_screen.dart';
import 'screens/progress/progress_screen.dart';
import 'screens/progress/workout_history_screen.dart';
import 'screens/settings/reminder_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/settings/subscription_screen.dart';
import 'screens/workouts/workout_detail_screen.dart';
import 'screens/workouts/workout_list_screen.dart';
import 'screens/workouts/workout_player_screen.dart';

class WorkoutApp extends ConsumerWidget {
  const WorkoutApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: '7-Minute Workout',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      initialRoute: AppRoutes.welcome,
      routes: {
        AppRoutes.welcome: (_) => const WelcomeScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.profileSetup: (_) => const ProfileSetupScreen(),
        AppRoutes.healthConnect: (_) => const HealthConnectScreen(),
        AppRoutes.home: (_) => const MainShell(),
        AppRoutes.workoutList: (_) => const WorkoutListScreen(),
        AppRoutes.workoutDetail: (_) => const WorkoutDetailScreen(),
        AppRoutes.workoutPlayer: (_) => const WorkoutPlayerScreen(),
        AppRoutes.workoutHistory: (_) => const WorkoutHistoryScreen(),
        AppRoutes.settings: (_) => const SettingsScreen(),
        AppRoutes.reminders: (_) => const ReminderScreen(),
        AppRoutes.subscription: (_) => const SubscriptionScreen(),
      },
    );
  }
}

/// Main shell with bottom navigation
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    WorkoutListScreen(),
    ProgressScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_up_outlined),
            selectedIcon: Icon(Icons.trending_up),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
