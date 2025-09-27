import 'package:flutter/material.dart';
// import 'package:flutter_performance_historian/flutter_performance_historian.dart'; // Mock implementation
import 'screens/home_screen.dart';
import 'services/performance_service.dart';

void main() {
  // Initialize performance monitoring
  PerformanceService.instance.initialize();
  
  runApp(const MilitarySymbolsQuizApp());
}

class MilitarySymbolsQuizApp extends StatelessWidget {
  const MilitarySymbolsQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Military Symbols Quiz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}