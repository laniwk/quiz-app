class QuestionChoice {
  const QuestionChoice({
    required this.id,
    required this.name,
    required this.value,
  });
  
  final String id;
  final String name;
  final String value;
  
  QuestionChoice copyWith({
    String? id,
    String? name,
    String? value,
  }) {
    return QuestionChoice(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }

  @override
  String toString() => 'QuestionChoice(id: $id, name: $name, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionChoice && other.id == id && other.name == name && other.value == value;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ value.hashCode;
}
