import 'package:flutter/material.dart';
import 'package:leave_cal/screens/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';

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
    final bool hasCompletedOnboarding = prefs.getBool('onboarding_complete') ?? false;

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
    const logo = "lib/assets/logo/app-logo.png";

    return Scaffold(
      backgroundColor: Colors.white, // Brand Green background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for your Logo/Icon
          
            Image.asset("lib/assets/logo/app-logo.png", width: 220, height: 220, fit: BoxFit.contain,),
            const SizedBox(height: 20),
            
            const SizedBox(height: 50),
            // Simple loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.8)),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}