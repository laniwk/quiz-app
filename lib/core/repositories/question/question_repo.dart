import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/core/models/question_choice.dart';

import '/core/models/question.dart';
import 'base_question_repo.dart';

class QuestionRepository implements BaseQuestionRepository {
  @override
  Future<List<Question>> getQuestions({
    required String categoryId,
    required String questionSetId,
  }) async {
    final questionSet = await FirebaseFirestore.instance.collection('MAGO/$categoryId/$questionSetId').get();
    return questionSet.docs.map((c) {
      final data = c.data();
      final text = data['QUESTION'] as String;
      final explanation = data['EXPLAIN'] as String;
      final answer = data['ANSWER'] as String;

      final List<QuestionChoice> choices = [];
      int count = 0;
      data.forEach((name, value) {
        if (name != 'ANSWER' && name != 'EXPLAIN' && name != 'QUESTION') {
          choices.add(QuestionChoice(
            id: (++count).toString(),
            name: name,
            value: value as String,
          ));
        }
      });

      return Question(
        text: text,
        explanation: explanation,
        answer: answer,
        choices: choices,
      );
    }).toList();
  }
}
