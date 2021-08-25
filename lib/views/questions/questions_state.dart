part of 'questions_state_notifier.dart';

class QuestionsState {
  const QuestionsState({
    required this.status,
    required this.questions,
    required this.userAnswers,
    required this.correctAnswers,
    this.errorMessage,
  });

  final StateStatus status;
  final List<Question> questions;
  final List<String> userAnswers;
  final String? errorMessage;
  final int correctAnswers;

  bool get isLoading => status == StateStatus.loading;
  bool get hasError => status == StateStatus.error;
  bool get hasCompletedQuestions => correctAnswers > -1;

  factory QuestionsState.init() {
    return const QuestionsState(
      status: StateStatus.init,
      questions: [],
      userAnswers: [],
      correctAnswers: -1,
    );
  }

  QuestionsState update({
    StateStatus? status,
    List<Question>? questions,
    List<String>? userAnswers,
    String? errorMessage,
    int? correctAnswers,
  }) {
    return QuestionsState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      userAnswers: userAnswers ?? this.userAnswers,
      errorMessage: errorMessage ?? this.errorMessage,
      correctAnswers: correctAnswers ?? this.correctAnswers,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionsState &&
        other.status == status &&
        listEquals(other.questions, questions) &&
        listEquals(other.userAnswers, userAnswers) &&
        other.errorMessage == errorMessage &&
        other.correctAnswers == correctAnswers;
  }

  @override
  int get hashCode {
    return status.hashCode ^ questions.hashCode ^ userAnswers.hashCode ^ errorMessage.hashCode ^ correctAnswers.hashCode;
  }
}
