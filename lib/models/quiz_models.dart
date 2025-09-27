enum MilitarySymbolType {
  friendly,
  hostile,
  neutral,
  unknown,
}

class MilitarySymbol {
  final String id;
  final String name;
  final String description;
  final MilitarySymbolType type;
  final String symbolCode;
  final String category; // infantry, armor, aviation, etc.
  
  const MilitarySymbol({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.symbolCode,
    required this.category,
  });
}

class QuizQuestion {
  final String id;
  final MilitarySymbol symbol;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  const QuizQuestion({
    required this.id,
    required this.symbol,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}

class Quiz {
  final String id;
  final String title;
  final String description;
  final List<QuizQuestion> questions;
  final int timeLimit; // in seconds
  final String difficulty;

  const Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.timeLimit,
    required this.difficulty,
  });
}

class QuizResult {
  final String quizId;
  final int score;
  final int totalQuestions;
  final int timeTaken;
  final List<bool> answers;
  final DateTime completedAt;

  const QuizResult({
    required this.quizId,
    required this.score,
    required this.totalQuestions,
    required this.timeTaken,
    required this.answers,
    required this.completedAt,
  });

  double get accuracy => (score / totalQuestions) * 100;
}