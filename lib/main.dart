import 'package:flutter/material.dart';

import 'features/recipes/presentation/screens/home_screen.dart';

void main() {
  runApp(const FoodApp());
}

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food App',
      home: const WelcomeScreen(),
    );
  }
}

// SCREEN 1
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'FOOD APP',
      subtitle: 'Cook anything. Learn everything.',
      page: 1,
      buttonText: 'NEXT',
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DiscoverScreen()),
        );
      },
    );
  }
}

// SCREEN 2
class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Discover food from everywhere.',
      subtitle:
          'Explore recipes from different cultures and learn how to make them, step by step.',
      page: 2,
      buttonText: 'NEXT',
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AICompanionScreen()),
        );
      },
    );
  }
}

// SCREEN 3
class AICompanionScreen extends StatelessWidget {
  const AICompanionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'AI is coming soon.',
      subtitle:
          'Your future AI cooking companion will help you cook, answer questions, and guide you step by step.',
      page: 3,
      buttonText: 'NEXT',
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StartCookingScreen()),
        );
      },
    );
  }
}

// SCREEN 4
class StartCookingScreen extends StatelessWidget {
  const StartCookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Ready to cook?',
      subtitle:
          'Discover recipes, learn new skills, and make something amazing.',
      page: 4,
      buttonText: 'START COOKING',
      onNext: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      },
    );
  }
}

// REUSABLE ONBOARDING SCREEN
class AppScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final int page;
  final String buttonText;
  final VoidCallback onNext;

  const AppScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.page,
    required this.buttonText,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'FOOD APP',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 50),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 50),

              Text(
                page == 1
                    ? '●  ○  ○  ○'
                    : page == 2
                    ? '○  ●  ○  ○'
                    : page == 3
                    ? '○  ○  ●  ○'
                    : '○  ○  ○  ●',
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onNext,
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
