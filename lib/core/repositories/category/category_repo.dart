import 'package:cloud_firestore/cloud_firestore.dart';

import '/core/models/category.dart';
import 'base_category_repo.dart';

class CategoryRepository implements BaseCategoryRepository {
  @override
  Future<List<Category>> getCategories() async {
    final categoryDoc = await FirebaseFirestore.instance.collection('MAGO').get();
    return categoryDoc.docs.where((c) => c.id != 'Categories' && c.id != 'CAT4').map((c) {
      final id = c.id;
      final name = c.data()['NAME'] as String;
      return Category(
        id: id,
        name: name,
        questionSets: const [],
      );
    }).toList();
  }
}
