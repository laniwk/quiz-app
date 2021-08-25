import 'dart:developer' as dev show log;
import 'dart:io' show SocketException;

import 'package:flutter/foundation.dart' show listEquals, ValueNotifier;
import 'package:get_it/get_it.dart';

import '/core/enums/state_status.dart';
import '/core/models/question.dart';
import '/core/repositories/question/base_question_repo.dart';

part 'questions_state.dart';

class QuestionsStateNotifier {
  QuestionsStateNotifier({
    BaseQuestionRepository? questionRepository,
  }) : _questionRepository = questionRepository ?? GetIt.I<BaseQuestionRepository>();

  final BaseQuestionRepository _questionRepository;
  final ValueNotifier<QuestionsState> state = ValueNotifier(QuestionsState.init());

  Future<void> loadQuestions({
    required final String categoryId,
    required final String questionSetId,
  }) async {
    if (state.value.isLoading) return;

    state.value = state.value.update(
      status: StateStatus.loading,
    );

    try {
      final questions = await _questionRepository.getQuestions(
        categoryId: categoryId,
        questionSetId: questionSetId,
      );
      state.value = state.value.update(
        status: StateStatus.loaded,
        questions: questions,
        userAnswers: List<String>.filled(questions.length, ''),
      );
    } on SocketException {
      state.value = state.value.update(
        status: StateStatus.error,
        errorMessage: 'Tidak ada koneksi. Mohon periksa koneksi Anda.',
      );
    } on Exception catch (e, st) {
      _onException(e, st);
    }
  }

  void answer(final int index, final String answer) {
    final changedUserAnswers = state.value.userAnswers.toList(growable: false);
    changedUserAnswers[index] = answer;/* (answer.codeUnitAt(0) - 64).toString(); */

    state.value = state.value.update(
      userAnswers: changedUserAnswers,
    );
  }

  void countCorrectAnswers() {
    int correctAnswers = 0;
    final questionsLength = state.value.questions.length;
    for(int i = 0; i < questionsLength; i++) {
      if(state.value.userAnswers[i] == state.value.questions[i].answer) {
        correctAnswers++;
      }
    }
    state.value = state.value.update(
      correctAnswers: correctAnswers,
    );
  }

  void _onException(final Object e, final StackTrace st) {
    if (state.value.hasError) return;
    state.value = state.value.update(
      status: StateStatus.error,
      errorMessage: 'Oops terjadi kesalahan. Mohon ulangi kembali.',
    );
    dev.log(e.toString());
    dev.log(st.toString());
  }

  void dispose() {
    state.dispose();
  }
}
