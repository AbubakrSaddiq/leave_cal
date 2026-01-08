import 'package:flutter/material.dart';
import 'package:leave_cal/screens/login_screen.dart';
import 'package:leave_cal/services/leave_provider';
import 'package:leave_cal/screens/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Ensure Flutter is initialized before accessing SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Replace with your actual Supabase credentials
  await Supabase.initialize(
    url: 'https://msxpejnaszjiyhgiqgxp.supabase.co',
    anonKey: 'sb_publishable_h-Cz89DMx0P2ljl14RBQqg_QeBMsEKb',
    // lOpSHTRt5CNFH0K2
  );

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
      home: StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          final session = Supabase.instance.client.auth.currentSession;
          if (session != null) {
            return const DashboardScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
