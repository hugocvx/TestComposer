// import 'package:flutter_performance_historian/flutter_performance_historian.dart'; // Mock implementation

// Mock PerformanceHistorian for now since package may not be available
class PerformanceHistorian {
  final Map<String, dynamic> _data = {};
  final List<Map<String, dynamic>> _events = [];

  void startMonitoring() {
    // Mock implementation
  }

  void stopMonitoring() {
    // Mock implementation  
  }

  void recordEvent(String eventType, Map<String, dynamic> data) {
    _events.add({
      'event_type': eventType,
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    });
  }

  Map<String, dynamic> getPerformanceData() {
    final quizEndEvents = _events.where((e) => e['event_type'] == 'quiz_end').toList();
    final questionEvents = _events.where((e) => e['event_type'] == 'question_answered').toList();

    int totalQuizzes = quizEndEvents.length;
    double avgAccuracy = 0;
    int totalQuestions = questionEvents.length;
    double avgTimePerQuestion = 0;

    if (quizEndEvents.isNotEmpty) {
      double totalAccuracy = 0;
      for (var event in quizEndEvents) {
        totalAccuracy += (event['data']?['accuracy'] ?? 0);
      }
      avgAccuracy = totalAccuracy / quizEndEvents.length;
    }

    if (questionEvents.isNotEmpty) {
      double totalTime = 0;
      for (var event in questionEvents) {
        totalTime += (event['data']?['time_to_answer_seconds'] ?? 0);
      }
      avgTimePerQuestion = totalTime / questionEvents.length;
    }

    return {
      'total_quizzes': totalQuizzes,
      'average_accuracy': avgAccuracy.round(),
      'total_questions': totalQuestions,
      'avg_time_per_question': avgTimePerQuestion.round(),
      'recent_events': _events.take(10).toList(),
    };
  }
}

class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  static PerformanceService get instance => _instance;
  PerformanceService._internal();

  PerformanceHistorian? _historian;

  void initialize() {
    _historian = PerformanceHistorian();
    _historian?.startMonitoring();
  }

  void recordQuizStart(String quizType) {
    _historian?.recordEvent('quiz_start', {'type': quizType});
  }

  void recordQuizEnd(String quizType, int score, int totalQuestions, int timeTaken) {
    _historian?.recordEvent('quiz_end', {
      'type': quizType,
      'score': score,
      'total_questions': totalQuestions,
      'time_taken_seconds': timeTaken,
      'accuracy': (score / totalQuestions * 100).round()
    });
  }

  void recordQuestionAnswered(int questionIndex, bool correct, int timeToAnswer) {
    _historian?.recordEvent('question_answered', {
      'question_index': questionIndex,
      'correct': correct,
      'time_to_answer_seconds': timeToAnswer
    });
  }

  Map<String, dynamic>? getPerformanceData() {
    return _historian?.getPerformanceData();
  }

  void dispose() {
    _historian?.stopMonitoring();
  }
}