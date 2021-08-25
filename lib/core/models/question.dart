import 'package:flutter/foundation.dart' show listEquals;
import 'question_choice.dart';

class Question {
  const Question({
    required this.text,
    required this.explanation,
    required this.answer,
    required this.choices,
  });

  /// question image url
  final String text;
  /// explanation image url
  final String explanation;
  /// answer in "1" -> "4"
  final String answer;
  /// a, b, c, d,
  /// can be either a text, or a url
  final List<QuestionChoice> choices;

  Question copyWith({
    String? text,
    String? explanation,
    String? answer,
    List<QuestionChoice>? choices,
  }) {
    return Question(
      text: text ?? this.text,
      explanation: explanation ?? this.explanation,
      answer: answer ?? this.answer,
      choices: choices ?? this.choices,
    );
  }

  @override
  String toString() {
    return 'Question(text: $text, explanation: $explanation, answer: $answer, choices: $choices)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Question &&
      other.text == text &&
      other.explanation == explanation &&
      other.answer == answer &&
      listEquals(other.choices, choices);
  }

  @override
  int get hashCode {
    return text.hashCode ^
      explanation.hashCode ^
      answer.hashCode ^
      choices.hashCode;
  }
}
