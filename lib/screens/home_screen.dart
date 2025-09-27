import 'package:flutter/material.dart';
import '../models/quiz_models.dart';
import '../services/quiz_data_service.dart';
import '../services/performance_service.dart';
import 'quiz_screen.dart';
import 'performance_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QuizDataService _quizDataService = QuizDataService.instance;
  List<Quiz> _quizzes = [];

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  void _loadQuizzes() {
    setState(() {
      _quizzes = _quizDataService.getAvailableQuizzes();
    });
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Military Symbols Quiz'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PerformanceScreen(),
                ),
              );
            },
            tooltip: 'Performance Analytics',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Military Symbols Quiz!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Test your knowledge of military symbols and improve your tactical awareness.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              'Available Quizzes:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = _quizzes[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        quiz.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(quiz.description),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Chip(
                                label: Text(quiz.difficulty),
                                backgroundColor: _getDifficultyColor(quiz.difficulty).withOpacity(0.2),
                                labelStyle: TextStyle(
                                  color: _getDifficultyColor(quiz.difficulty),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Chip(
                                label: Text('${quiz.questions.length} questions'),
                                backgroundColor: Colors.blue.withOpacity(0.2),
                                labelStyle: const TextStyle(color: Colors.blue),
                              ),
                              const SizedBox(width: 8),
                              Chip(
                                label: Text('${quiz.timeLimit ~/ 60} min'),
                                backgroundColor: Colors.purple.withOpacity(0.2),
                                labelStyle: const TextStyle(color: Colors.purple),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        PerformanceService.instance.recordQuizStart(quiz.id);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(quiz: quiz),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}