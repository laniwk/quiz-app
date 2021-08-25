import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/core/constants/route_names.dart';
import '/core/helpers/screen_utils.dart';
import '/core/models/category.dart';
import '/core/models/question_set.dart';
import '/views/categories/categories_state_notifier.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> with ScreenUtils<CategoriesScreen> {
  final _categoriesStateNotifier = CategoriesStateNotifier();

  @override
  void initState() {
    super.initState();
    _categoriesStateNotifier.loadCategories();
  }

  @override
  void dispose() {
    _categoriesStateNotifier.dispose();
    super.dispose();
  }

  void _onQuestionSetTapped(String categoryId, String questionSetId) {
    Navigator.of(context).pushNamed(
      RouteNames.questions,
      arguments: {
        'categoryId': categoryId,
        'questionSetId': questionSetId,
      },
    );
  }

  AppBar get _appBar {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        onPressed: Navigator.of(context).pop,
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.pinkAccent,
        ),
      ),
      title: const Text(
        'Kategori',
        style: TextStyle(color: Colors.pinkAccent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      backgroundColor: Colors.white,
      body: ValueListenableBuilder<CategoriesState>(
        valueListenable: _categoriesStateNotifier.state,
        builder: (_, state, child) {
          if (state.isLoading) {
            return child!;
          }
          if (state.hasError) {
            showSnackBarMsg(message: state.errorMessage);
          }
          return _CategoriesExpansionPanels(
            categories: state.categories,
            onQuestionSetTapped: _onQuestionSetTapped,
          );
        },
        child: const _CategoriesLoadingWidget(),
      ),
    );
  }
}

class _CategoriesLoadingWidget extends StatelessWidget {
  const _CategoriesLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: LinearProgressIndicator(),
      ),
    );
  }
}

class _CategoriesExpansionPanels extends StatefulWidget {
  const _CategoriesExpansionPanels({
    Key? key,
    required this.categories,
    required this.onQuestionSetTapped,
  }) : super(key: key);
  final List<Category> categories;
  final void Function(String categoryId, String questionSetId) onQuestionSetTapped;

  @override
  __CategoriesExpansionPanelsState createState() => __CategoriesExpansionPanelsState();
}

class __CategoriesExpansionPanelsState extends State<_CategoriesExpansionPanels> {
  late final _isExpanded = List<bool>.filled(widget.categories.length, false);

  void _expansionCallback(int index, bool newState) {
    return setState(() {
      _isExpanded[index] = !newState;
    });
  }

  List<ExpansionPanel> get _panels {
    final List<ExpansionPanel> panels = [];
    for (int i = 0; i < widget.categories.length; i++) {
      final currentCategory = widget.categories[i];
      panels.add(
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (context, newState) {
            return ListTile(
              title: AnimatedDefaultTextStyle(
                style: !newState ? Theme.of(context).textTheme.subtitle1! : Theme.of(context).textTheme.headline6!,
                duration: kThemeAnimationDuration,
                child: Text(currentCategory.name),
              ),
            );
          },
          isExpanded: _isExpanded[i],
          body: _panelBodyOf(currentCategory.id, currentCategory.questionSets),
        ),
      );
    }
    return panels;
  }

  ListView _panelBodyOf(String categoryId, List<QuestionSet> questionSets) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
      children: questionSets.map((questionSet) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton(
            onPressed: () => widget.onQuestionSetTapped(categoryId, questionSet.id),
            style: ElevatedButton.styleFrom(
              alignment: Alignment.centerLeft,
              elevation: 0,
              minimumSize: Size(MediaQuery.of(context).size.width - 40, 50),
              shadowColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            child: Text(
              questionSet.id,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }).toList(growable: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        elevation: 0,
        expansionCallback: _expansionCallback,
        children: _panels,
      ),
    );
  }
}
