import 'package:flutter_test/flutter_test.dart';
import 'package:military_symbols_quiz/main.dart';
import 'package:military_symbols_quiz/models/quiz_models.dart';
import 'package:military_symbols_quiz/services/quiz_data_service.dart';
import 'package:military_symbols_quiz/services/performance_service.dart';

void main() {
  group('Military Symbols Quiz Tests', () {
    
    test('Quiz data service should return available quizzes', () {
      final service = QuizDataService.instance;
      final quizzes = service.getAvailableQuizzes();
      
      expect(quizzes.isNotEmpty, true);
      expect(quizzes.length, 3);
      expect(quizzes.first.title, 'Basic Military Symbols');
    });

    test('Performance service should initialize without errors', () {
      final service = PerformanceService.instance;
      expect(() => service.initialize(), returnsNormally);
    });

    test('Military symbol model should have correct properties', () {
      const symbol = MilitarySymbol(
        id: 'test_id',
        name: 'Test Symbol',
        description: 'Test Description',
        type: MilitarySymbolType.friendly,
        symbolCode: 'TESTCODE',
        category: 'Test',
      );

      expect(symbol.id, 'test_id');
      expect(symbol.name, 'Test Symbol');
      expect(symbol.type, MilitarySymbolType.friendly);
    });

    test('Quiz result should calculate accuracy correctly', () {
      const result = QuizResult(
        quizId: 'test_quiz',
        score: 8,
        totalQuestions: 10,
        timeTaken: 300,
        answers: [true, true, false, true, true, true, false, true, true, true],
        completedAt: null,
      );

      expect(result.accuracy, 80.0);
    });

    test('Performance service should record events', () {
      final service = PerformanceService.instance;
      service.initialize();
      
      service.recordQuizStart('test_quiz');
      service.recordQuestionAnswered(0, true, 15);
      service.recordQuizEnd('test_quiz', 5, 10, 300);
      
      final data = service.getPerformanceData();
      expect(data, isNotNull);
    });

    test('Quiz data service should find symbols by ID', () {
      final service = QuizDataService.instance;
      final symbol = service.getSymbolById('infantry_friendly');
      
      expect(symbol, isNotNull);
      expect(symbol?.name, 'Friendly Infantry');
    });

    test('Quiz data service should filter symbols by type', () {
      final service = QuizDataService.instance;
      final friendlySymbols = service.getSymbolsByType(MilitarySymbolType.friendly);
      
      expect(friendlySymbols.isNotEmpty, true);
      for (var symbol in friendlySymbols) {
        expect(symbol.type, MilitarySymbolType.friendly);
      }
    });
  });

  testWidgets('App should build without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MilitarySymbolsQuizApp());
    
    expect(find.text('Military Symbols Quiz'), findsOneWidget);
    expect(find.text('Welcome to Military Symbols Quiz!'), findsOneWidget);
  });
}