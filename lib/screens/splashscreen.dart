import 'package:flutter/material.dart';
import 'package:leave_cal/screens/onboardingscreen.dart';
import 'package:leave_cal/screens/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  void _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // Default is 'false' if the key hasn't been set
    final bool hasCompletedOnboarding =
        prefs.getBool('onboarding_complete') ?? false;

    // Wait a brief moment for the splash effect
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Navigate based on the status
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => hasCompletedOnboarding
            ? const DashboardScreen()
            : const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E7D52), // Brand Green background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for your Logo/Icon
            const Icon(Icons.calendar_month, color: Colors.white, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Leave Calc',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 50),
            // Simple loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withOpacity(0.8),
              ),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
