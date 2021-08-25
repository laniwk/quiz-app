import 'package:cloud_firestore/cloud_firestore.dart';
import '/core/models/question_set.dart';
import '/core/repositories/question_set/base_qset_repo.dart';

class QuestionSetRepository implements BaseQuestionSetRepository {
  @override
  Future<List<QuestionSet>> getQuestionSets({required String categoryId}) async {
    final questionSetCollection = await FirebaseFirestore.instance.collection(categoryId).get();

    return questionSetCollection.docs.map((c) {
      return QuestionSet(
        id: c.id,
        questions: const [],
      );
    }).toList();
  }
}
