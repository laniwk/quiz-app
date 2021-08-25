part of 'categories_state_notifier.dart';

class CategoriesState {
  const CategoriesState({
    required this.status,
    required this.categories,
    this.errorMessage,
  });

  final StateStatus status;
  final List<Category> categories;
  final String? errorMessage;

  bool get isLoading => status == StateStatus.loading;
  bool get hasError => status == StateStatus.error;
  
  factory CategoriesState.init() {
    return const CategoriesState(
      status: StateStatus.init,
      categories: [],
    );
  }

  CategoriesState update({
    StateStatus? status,
    List<Category>? categories,
    String? errorMessage,
  }) {
    return CategoriesState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoriesState &&
        other.status == status &&
        listEquals(other.categories, categories) &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => status.hashCode ^ categories.hashCode ^ errorMessage.hashCode;
}
