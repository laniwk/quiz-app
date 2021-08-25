import 'dart:developer' as dev show log;
import 'dart:io' show SocketException;

import 'package:flutter/foundation.dart' show listEquals, ValueNotifier;
import 'package:get_it/get_it.dart';

import '/core/enums/state_status.dart';
import '/core/models/category.dart';
import '/core/repositories/category/base_category_repo.dart';
import '/core/repositories/question_set/base_qset_repo.dart';

part 'categories_state.dart';

class CategoriesStateNotifier {
  CategoriesStateNotifier({
    BaseCategoryRepository? categoryRepository,
    BaseQuestionSetRepository? questionSetRepository,
  })  : _categoryRepository = categoryRepository ?? GetIt.I<BaseCategoryRepository>(),
        _questionSetRepository = questionSetRepository ?? GetIt.I<BaseQuestionSetRepository>();

  final BaseCategoryRepository _categoryRepository;
  final BaseQuestionSetRepository _questionSetRepository;
  final ValueNotifier<CategoriesState> state = ValueNotifier(CategoriesState.init());

  Future<void> loadCategories() async {
    if (state.value.isLoading) return;

    state.value = state.value.update(
      status: StateStatus.loading,
    );

    try {
      final categories = await _categoryRepository.getCategories();
      for (int i = 0; i < categories.length; i++) {
        final questionSets = await _questionSetRepository.getQuestionSets(
          categoryId: categories[i].id,
        );
        categories[i] = categories[i].copyWith(
          questionSets: questionSets,
        );
      }
      state.value = state.value.update(
        status: StateStatus.loaded,
        categories: categories,
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

  void _onException(Object e, StackTrace st) {
    if(state.value.hasError) return;
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
