import 'package:flutter/material.dart';
import '../../config/routes.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _pages = const [
    _WelcomePage(
      icon: Icons.fitness_center,
      title: 'Quick & Effective',
      subtitle: 'Just 7 minutes a day for a full-body workout. Science-backed exercises to boost your fitness.',
    ),
    _WelcomePage(
      icon: Icons.timer,
      title: 'Guided Timer',
      subtitle: 'Follow along with voice cues, animated exercises, and smart rest periods.',
    ),
    _WelcomePage(
      icon: Icons.trending_up,
      title: 'Track Progress',
      subtitle: 'Monitor your streaks, calories burned, and workout history to stay motivated.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => _pages[index],
              ),
            ),

            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? theme.colorScheme.primary
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, AppRoutes.home),
                    child: const Text('Get Started'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _WelcomePage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 56, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
