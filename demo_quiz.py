#!/usr/bin/env python3

# Simple demonstration of the Military Symbols Quiz logic
# This Python script demonstrates the core functionality of the Flutter app

import random
import time
from datetime import datetime
from enum import Enum

class MilitarySymbolType(Enum):
    FRIENDLY = "friendly"
    HOSTILE = "hostile"
    NEUTRAL = "neutral"
    UNKNOWN = "unknown"

class MilitarySymbol:
    def __init__(self, id, name, description, type, symbol_code, category):
        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.symbol_code = symbol_code
        self.category = category

class QuizQuestion:
    def __init__(self, id, symbol, question, options, correct_answer_index, explanation):
        self.id = id
        self.symbol = symbol
        self.question = question
        self.options = options
        self.correct_answer_index = correct_answer_index
        self.explanation = explanation

# Sample data
military_symbols = [
    MilitarySymbol(
        "infantry_friendly",
        "Friendly Infantry",
        "Represents friendly infantry units",
        MilitarySymbolType.FRIENDLY,
        "SFGPUCI-------",
        "Infantry"
    ),
    MilitarySymbol(
        "armor_hostile",
        "Hostile Armor",
        "Represents hostile armored units",
        MilitarySymbolType.HOSTILE,
        "SHGPUCA-------",
        "Armor"
    ),
    MilitarySymbol(
        "aviation_neutral",
        "Neutral Aviation",
        "Represents neutral aviation units",
        MilitarySymbolType.NEUTRAL,
        "SNGPUCR-------",
        "Aviation"
    )
]

sample_questions = [
    QuizQuestion(
        "q1",
        military_symbols[0],
        "What type of unit does this symbol represent?",
        ["Infantry", "Armor", "Aviation", "Artillery"],
        0,
        "This symbol represents an infantry unit, indicated by the crossed rifles symbol."
    ),
    QuizQuestion(
        "q2",
        military_symbols[1],
        "What is the affiliation of this symbol?",
        ["Friendly", "Hostile", "Neutral", "Unknown"],
        1,
        "The diamond shape indicates a hostile unit."
    ),
    QuizQuestion(
        "q3",
        military_symbols[2],
        "What affiliation does this square symbol indicate?",
        ["Friendly", "Hostile", "Neutral", "Unknown"],
        2,
        "Square symbols represent neutral affiliations."
    )
]

def main():
    print("=== Military Symbols Quiz Demo ===\n")
    print("This demonstrates the core functionality of the Flutter app.\n")
    
    print("Available Military Symbols:")
    for i, symbol in enumerate(military_symbols):
        print(f"{i + 1}. {symbol.name} ({symbol.category})")
        print(f"   Type: {symbol.type.value}")
        print(f"   Code: {symbol.symbol_code}")
        print(f"   Description: {symbol.description}\n")

    print("Starting Sample Quiz...\n")
    run_sample_quiz()

def run_sample_quiz():
    score = 0
    answers = []
    start_time = time.time()
    
    for i, question in enumerate(sample_questions):
        print(f"--- Question {i + 1} ---")
        print(f"Symbol: {question.symbol.name}")
        print(f"Code: {question.symbol.symbol_code}")
        print(f"\nQuestion: {question.question}\n")
        
        for j, option in enumerate(question.options):
            print(f"{chr(65 + j)}. {option}")
        
        # Simulate automatic answer (in real app, user would select)
        user_answer = random.randint(0, len(question.options) - 1)
        is_correct = user_answer == question.correct_answer_index
        
        if is_correct:
            score += 1
            answers.append(True)
            print(f"\n✓ Correct! You selected: {question.options[user_answer]}")
        else:
            answers.append(False)
            print(f"\n✗ Incorrect. You selected: {question.options[user_answer]}")
            print(f"Correct answer: {question.options[question.correct_answer_index]}")
        
        print(f"Explanation: {question.explanation}\n")
        
        # Simulate delay between questions
        time.sleep(0.5)
    
    end_time = time.time()
    time_taken = int(end_time - start_time)
    show_results(score, len(sample_questions), answers, time_taken)

def show_results(score, total_questions, answers, time_taken):
    print("=== Quiz Results ===")
    accuracy = round((score / total_questions) * 100)
    
    print(f"Score: {score} / {total_questions}")
    print(f"Accuracy: {accuracy}%")
    print(f"Time taken: {time_taken} seconds")
    print(f"Performance: {get_performance_message(accuracy)}")
    
    print("\nDetailed Results:")
    for i, answer in enumerate(answers):
        result = "✓" if answer else "✗"
        print(f"Question {i + 1}: {result}")
    
    print("\nIn the Flutter app, this data would be:")
    print("- Stored for performance tracking")
    print("- Displayed with visual charts and graphs")
    print("- Used to recommend areas for improvement")
    print("- Tracked over time to show progress")

def get_performance_message(accuracy):
    if accuracy >= 90:
        return "Outstanding! You have excellent knowledge of military symbols."
    elif accuracy >= 80:
        return "Great job! You have a solid understanding of military symbols."
    elif accuracy >= 70:
        return "Good work! Keep practicing to improve your recognition skills."
    elif accuracy >= 60:
        return "Not bad! You might want to review the basics."
    else:
        return "Keep studying! Military symbols take practice to master."

if __name__ == "__main__":
    main()