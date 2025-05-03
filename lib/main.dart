import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://cbtjaowquithswiieksz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNidGphb3dxdWl0aHN3aWlla3N6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDYyNTA2MDQsImV4cCI6MjA2MTgyNjYwNH0.Ddkf6vsO-PRfw7JGFk4uenFt2VzNJEiCzUehEDMR9jk',
  );
  runApp(MyApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreen(), 
    );
  }
}