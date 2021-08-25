import '/core/models/question_set.dart';

abstract class BaseQuestionSetRepository {
  Future<List<QuestionSet>> getQuestionSets({required String categoryId});
}