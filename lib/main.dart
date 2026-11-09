import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/recipes/presentation/screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: FoodApp()));
}

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food App',
      home: const AppStartScreen(),
    );
  }
}

// APP START SCREEN
class AppStartScreen extends StatefulWidget {
  const AppStartScreen({super.key});

  @override
  State<AppStartScreen> createState() => _AppStartScreenState();
}

class _AppStartScreenState extends State<AppStartScreen> {
  bool _isLoading = true;
  bool _hasCompletedOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();

    final completed = prefs.getBool('onboarding_completed') ?? false;

    if (!mounted) return;

    setState(() {
      _hasCompletedOnboarding = completed;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFFDF8),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasCompletedOnboarding) {
      return const HomeScreen();
    }

    return const OnboardingScreen();
  }
}

// ONBOARDING
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {'title': 'FOOD APP', 'subtitle': 'Cook anything. Learn everything.'},
    {
      'title': 'Discover food from everywhere.',
      'subtitle':
          'Explore recipes from different cultures and learn how to make them, step by step.',
    },
    {
      'title': 'AI is coming soon.',
      'subtitle':
          'Your future AI cooking companion will help you cook, answer questions, and guide you step by step.',
    },
    {
      'title': 'Ready to cook?',
      'subtitle':
          'Discover recipes, learn new skills, and make something amazing.',
    },
  ];

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('onboarding_completed', true);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _nextPage() {
    if (_currentPage == _pages.length - 1) {
      _finishOnboarding();
    } else {
      _carouselController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              const Text(
                'FOOD APP',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const Spacer(),

              CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: _pages.length,
                options: CarouselOptions(
                  height: 300,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  final page = _pages[index];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        page['title']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        page['subtitle']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Colors.black
                          : Colors.grey.shade400,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage == _pages.length - 1
                        ? 'START COOKING'
                        : 'NEXT',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
