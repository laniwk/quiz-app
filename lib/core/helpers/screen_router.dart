import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/core/constants/route_names.dart';
import '/screens.dart';

class ScreenRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    final routeDestination = settings.name;
    final routeArguments = settings.arguments;

    return CupertinoPageRoute(
      builder: (context) {
        if (routeDestination == RouteNames.home) {
          return const HomeScreen();
        }
        if (routeDestination == RouteNames.categories) {
          return const CategoriesScreen();
        }
        if (routeDestination == RouteNames.questions && routeArguments is Map<String, String>) {
          final categoryId = routeArguments['categoryId']!;
          final questionSetId = routeArguments['questionSetId']!;
          return QuestionsScreen(
            categoryId: categoryId,
            questionSetId: questionSetId,
          );
        }
        if (routeDestination == RouteNames.result && routeArguments is Map<String, int>) {
          final correctAnswers = routeArguments['correctAnswers']!;
          final questionsLength = routeArguments['questionsLength']!;
          return ResultScreen(
            correctAnswers: correctAnswers,
            questionsLength: questionsLength,
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            elevation: 0,
            leading: IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.pinkAccent,
              ),
            ),
          ),
          body: const Center(
            child: Text('Page not found.'),
          ),
        );
      },
      settings: settings,
    );
  }
}
