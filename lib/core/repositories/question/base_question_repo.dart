import '/core/models/question.dart';

abstract class BaseQuestionRepository {
  Future<List<Question>> getQuestions({
    required String categoryId,
    required String questionSetId,
  });
}
