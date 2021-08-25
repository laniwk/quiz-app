import 'package:flutter/foundation.dart' show listEquals;

import 'question.dart';

class QuestionSet {
  const QuestionSet({
    required this.id,
    // required this.name,
    required this.questions,
  });
  final String id;
  // final String name;
  final List<Question> questions;

  QuestionSet copyWith({
    String? id,
    // String? name,
    List<Question>? questions,
  }) {
    return QuestionSet(
      id: id ?? this.id,
      // name: name ?? this.name,
      questions: questions ?? this.questions,
    );
  }

  @override
  String toString() => 'QuestionSet(id: $id, questions: $questions)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is QuestionSet &&
      other.id == id &&
      // other.name == name &&
      listEquals(other.questions, questions);
  }

  @override
  int get hashCode => id.hashCode /* ^ name.hashCode */ ^ questions.hashCode;
}
