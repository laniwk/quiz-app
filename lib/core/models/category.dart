
import 'package:flutter/foundation.dart';

import 'package:quiz_app/core/models/question_set.dart';

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.questionSets,
  });
  final String id;
  final String name;
  final List<QuestionSet> questionSets;

  Category copyWith({
    String? id,
    String? name,
    List<QuestionSet>? questionSets,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      questionSets: questionSets ?? this.questionSets,
    );
  }

  @override
  String toString() => 'Category(id: $id, name: $name, questionSets: $questionSets)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Category &&
      other.id == id &&
      other.name == name &&
      listEquals(other.questionSets, questionSets);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ questionSets.hashCode;
}
