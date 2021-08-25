
import '/core/models/category.dart';

abstract class BaseCategoryRepository {
  Future<List<Category>> getCategories();
}