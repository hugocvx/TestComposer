import '../models/quiz_models.dart';

class QuizDataService {
  static final QuizDataService _instance = QuizDataService._internal();
  factory QuizDataService() => _instance;
  static QuizDataService get instance => _instance;
  QuizDataService._internal();

  // Sample military symbols data
  static const List<MilitarySymbol> _militarySymbols = [
    MilitarySymbol(
      id: 'infantry_friendly',
      name: 'Friendly Infantry',
      description: 'Represents friendly infantry units',
      type: MilitarySymbolType.friendly,
      symbolCode: 'SFGPUCI-------',
      category: 'Infantry',
    ),
    MilitarySymbol(
      id: 'armor_hostile',
      name: 'Hostile Armor',
      description: 'Represents hostile armored units',
      type: MilitarySymbolType.hostile,
      symbolCode: 'SHGPUCA-------',
      category: 'Armor',
    ),
    MilitarySymbol(
      id: 'aviation_neutral',
      name: 'Neutral Aviation',
      description: 'Represents neutral aviation units',
      type: MilitarySymbolType.neutral,
      symbolCode: 'SNGPUCR-------',
      category: 'Aviation',
    ),
    MilitarySymbol(
      id: 'artillery_friendly',
      name: 'Friendly Artillery',
      description: 'Represents friendly artillery units',
      type: MilitarySymbolType.friendly,
      symbolCode: 'SFGPUCF-------',
      category: 'Artillery',
    ),
    MilitarySymbol(
      id: 'engineers_unknown',
      name: 'Unknown Engineers',
      description: 'Represents unknown engineer units',
      type: MilitarySymbolType.unknown,
      symbolCode: 'SUGPUCE-------',
      category: 'Engineers',
    ),
  ];

  List<Quiz> getAvailableQuizzes() {
    return [
      Quiz(
        id: 'basic_symbols',
        title: 'Basic Military Symbols',
        description: 'Test your knowledge of basic military symbols',
        timeLimit: 300, // 5 minutes
        difficulty: 'Beginner',
        questions: _generateBasicSymbolsQuestions(),
      ),
      Quiz(
        id: 'symbol_types',
        title: 'Symbol Types Recognition',
        description: 'Identify friendly, hostile, neutral, and unknown symbols',
        timeLimit: 600, // 10 minutes
        difficulty: 'Intermediate',
        questions: _generateSymbolTypesQuestions(),
      ),
      Quiz(
        id: 'advanced_symbols',
        title: 'Advanced Symbols Quiz',
        description: 'Advanced military symbols identification',
        timeLimit: 900, // 15 minutes
        difficulty: 'Advanced',
        questions: _generateAdvancedSymbolsQuestions(),
      ),
    ];
  }

  List<QuizQuestion> _generateBasicSymbolsQuestions() {
    return [
      QuizQuestion(
        id: 'q1',
        symbol: _militarySymbols[0],
        question: 'What type of unit does this symbol represent?',
        options: ['Infantry', 'Armor', 'Aviation', 'Artillery'],
        correctAnswerIndex: 0,
        explanation: 'This symbol represents an infantry unit, indicated by the crossed rifles symbol.',
      ),
      QuizQuestion(
        id: 'q2',
        symbol: _militarySymbols[1],
        question: 'What is the affiliation of this symbol?',
        options: ['Friendly', 'Hostile', 'Neutral', 'Unknown'],
        correctAnswerIndex: 1,
        explanation: 'The diamond shape indicates a hostile unit.',
      ),
      QuizQuestion(
        id: 'q3',
        symbol: _militarySymbols[3],
        question: 'What category does this symbol belong to?',
        options: ['Infantry', 'Engineers', 'Artillery', 'Aviation'],
        correctAnswerIndex: 2,
        explanation: 'The circle with dot symbol indicates artillery units.',
      ),
    ];
  }

  List<QuizQuestion> _generateSymbolTypesQuestions() {
    return [
      QuizQuestion(
        id: 'q4',
        symbol: _militarySymbols[2],
        question: 'What affiliation does this square symbol indicate?',
        options: ['Friendly', 'Hostile', 'Neutral', 'Unknown'],
        correctAnswerIndex: 2,
        explanation: 'Square symbols represent neutral affiliations.',
      ),
      QuizQuestion(
        id: 'q5',
        symbol: _militarySymbols[4],
        question: 'What type of unit is represented here?',
        options: ['Infantry', 'Armor', 'Engineers', 'Aviation'],
        correctAnswerIndex: 2,
        explanation: 'The castle/building symbol indicates engineer units.',
      ),
    ];
  }

  List<QuizQuestion> _generateAdvancedSymbolsQuestions() {
    return [
      QuizQuestion(
        id: 'q6',
        symbol: _militarySymbols[0],
        question: 'What is the complete symbol code for this friendly infantry unit?',
        options: ['SFGPUCI-------', 'SHGPUCI-------', 'SNGPUCI-------', 'SUGPUCI-------'],
        correctAnswerIndex: 0,
        explanation: 'SFGPUCI------- is the NATO APP-6 symbol code for friendly infantry.',
      ),
    ];
  }

  MilitarySymbol? getSymbolById(String id) {
    try {
      return _militarySymbols.firstWhere((symbol) => symbol.id == id);
    } catch (e) {
      return null;
    }
  }

  List<MilitarySymbol> getSymbolsByCategory(String category) {
    return _militarySymbols.where((symbol) => symbol.category == category).toList();
  }

  List<MilitarySymbol> getSymbolsByType(MilitarySymbolType type) {
    return _militarySymbols.where((symbol) => symbol.type == type).toList();
  }
}