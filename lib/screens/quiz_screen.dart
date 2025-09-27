import 'package:flutter/material.dart';
// import 'package:flutter_mil_symbol/flutter_mil_symbol.dart'; // Package not available
import '../models/quiz_models.dart';
import '../services/performance_service.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizScreen({super.key, required this.quiz});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  List<bool> _answers = [];
  int _score = 0;
  late DateTime _startTime;
  late DateTime _questionStartTime;
  bool _showAnswer = false;
  int? _selectedAnswerIndex;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _questionStartTime = DateTime.now();
    _answers = List.filled(widget.quiz.questions.length, false);
  }

  void _selectAnswer(int answerIndex) {
    if (_showAnswer) return;

    setState(() {
      _selectedAnswerIndex = answerIndex;
    });

    final question = widget.quiz.questions[_currentQuestionIndex];
    final isCorrect = answerIndex == question.correctAnswerIndex;
    final timeToAnswer = DateTime.now().difference(_questionStartTime).inSeconds;

    if (isCorrect) {
      _score++;
      _answers[_currentQuestionIndex] = true;
    }

    PerformanceService.instance.recordQuestionAnswered(
      _currentQuestionIndex,
      isCorrect,
      timeToAnswer,
    );

    // Show answer for 2 seconds before proceeding
    setState(() {
      _showAnswer = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _showAnswer = false;
        _selectedAnswerIndex = null;
        _questionStartTime = DateTime.now();
      });
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    final timeTaken = DateTime.now().difference(_startTime).inSeconds;
    
    PerformanceService.instance.recordQuizEnd(
      widget.quiz.id,
      _score,
      widget.quiz.questions.length,
      timeTaken,
    );

    final result = QuizResult(
      quizId: widget.quiz.id,
      score: _score,
      totalQuestions: widget.quiz.questions.length,
      timeTaken: timeTaken,
      answers: _answers,
      completedAt: DateTime.now(),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          quiz: widget.quiz,
          result: result,
        ),
      ),
    );
  }

  Widget _buildMilSymbol(String symbolCode) {
    // Since we might not have the actual flutter_mil_symbol package available,
    // we'll create a placeholder that shows the symbol code
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.military_tech,
            size: 40,
            color: Colors.blue,
          ),
          const SizedBox(height: 8),
          Text(
            symbolCode.substring(0, 6),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getAnswerColor(int index) {
    if (!_showAnswer) {
      return _selectedAnswerIndex == index ? Colors.blue.withOpacity(0.3) : Colors.transparent;
    }

    final question = widget.quiz.questions[_currentQuestionIndex];
    if (index == question.correctAnswerIndex) {
      return Colors.green.withOpacity(0.3);
    } else if (_selectedAnswerIndex == index && index != question.correctAnswerIndex) {
      return Colors.red.withOpacity(0.3);
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.quiz.questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / widget.quiz.questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress indicator
            Row(
              children: [
                Text(
                  'Question ${_currentQuestionIndex + 1} of ${widget.quiz.questions.length}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  'Score: $_score',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 24),

            // Military symbol display
            Center(
              child: _buildMilSymbol(question.symbol.symbolCode),
            ),
            const SizedBox(height: 24),

            // Question
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  question.question,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Answer options
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: _getAnswerColor(index),
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: () => _selectAnswer(index),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(65 + index), // A, B, C, D
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  question.options[index],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              if (_showAnswer && index == question.correctAnswerIndex)
                                const Icon(Icons.check_circle, color: Colors.green),
                              if (_showAnswer && _selectedAnswerIndex == index && index != question.correctAnswerIndex)
                                const Icon(Icons.cancel, color: Colors.red),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Show explanation when answer is revealed
            if (_showAnswer)
              Card(
                color: Colors.blue.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Explanation:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        question.explanation,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}