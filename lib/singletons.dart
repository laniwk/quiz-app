
import 'package:get_it/get_it.dart';

import 'core/repositories/category/base_category_repo.dart';
import 'core/repositories/category/category_repo.dart';
import 'core/repositories/question/base_question_repo.dart';
import 'core/repositories/question/question_repo.dart';
import 'core/repositories/question_set/base_qset_repo.dart';
import 'core/repositories/question_set/qset_repo.dart';

void initSingletons() {
  GetIt.I.registerSingleton<BaseCategoryRepository>(CategoryRepository());
  GetIt.I.registerLazySingleton<BaseQuestionSetRepository>(() => QuestionSetRepository());
  GetIt.I.registerLazySingleton<BaseQuestionRepository>(() => QuestionRepository());
}