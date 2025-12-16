import 'package:flutter/material.dart';
import 'package:leave_cal/services/leave_provider';
import 'package:leave_cal/screens/dashboard.dart';
import 'package:provider/provider.dart';

void main() {
  // Ensure Flutter is initialized before accessing SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LeaveProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Leave Calculator',
      theme: ThemeData(
        primaryColor: const Color(0xFF2E7D52),
        scaffoldBackgroundColor: const Color(
          0xFFF5F7FA,
        ), // Light grey background
        fontFamily: 'Roboto', // Or 'Poppins' if added
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
