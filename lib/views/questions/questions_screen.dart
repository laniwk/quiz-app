import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '/core/constants/route_names.dart';
import '/core/helpers/screen_utils.dart';
import '/core/models/question.dart';
import 'questions_state_notifier.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({
    Key? key,
    required this.categoryId,
    required this.questionSetId,
  }) : super(key: key);

  final String categoryId;
  final String questionSetId;

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> with ScreenUtils<QuestionsScreen> {
  static const _timerDuration = Duration(seconds: 180);
  final _questionsStateNotifier = QuestionsStateNotifier();
  final _questionTilePageController = PageController();
  final _questionTileIndex = ValueNotifier(_QuestionTileIndexState.init());
  final _timerState = ValueNotifier(_timerDuration);
  late Timer _timer;

  List<Question> get _questions => _questionsStateNotifier.state.value.questions;
  List<String> get _userAnswers => _questionsStateNotifier.state.value.userAnswers;

  @override
  void initState() {
    super.initState();
    _questionsStateNotifier.loadQuestions(
      categoryId: widget.categoryId,
      questionSetId: widget.questionSetId,
    );
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        _timerState.value -= const Duration(seconds: 1);
        if (_timerState.value == Duration.zero) {
          _onDurationTimeout();
        }
      },
    );
    _questionsStateNotifier.state.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _questionsStateNotifier.dispose();
    _questionTilePageController.dispose();
    _questionTileIndex.dispose();
    _timerState.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _onPreviousTapped() {
    if (_questionTileIndex.value.currentIndex == 0) {
      return;
    }
    _questionTilePageController.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  void _onNextTapped() {
    final currentIndex = _questionTileIndex.value.currentIndex;
    if (currentIndex == _questions.length - 1) {
      return;
    }
    _questionTilePageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    );
    if (!_timer.isActive && _userAnswers[currentIndex + 1].isEmpty) {
      _resetDuration();
    }
  }

  void _resetDuration() {
    _timerState.value = _timerDuration;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        _timerState.value -= const Duration(seconds: 1);
        if (_timerState.value == Duration.zero) {
          _onDurationTimeout();
        }
      },
    );
  }

  void _onStateChanged() {
    if (_questionsStateNotifier.state.value.hasError) {
      showSnackBarMsg(message: _questionsStateNotifier.state.value.errorMessage);
      return;
    }
    if (_questions.isNotEmpty) {
      if (_questionTileIndex.value == _QuestionTileIndexState.init()) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          _questionTileIndex.value = const _QuestionTileIndexState(
            maxIndex: 0,
            currentIndex: 0,
          );
        });
      } else {
        if (_questionTileIndex.value.maxIndex < _questions.length - 1) {
          final maxIndex = _userAnswers.where((answer) => answer.isNotEmpty).length;
          _questionTileIndex.value = _questionTileIndex.value.copyWith(
            maxIndex: maxIndex,
          );
        } else if (!_questionsStateNotifier.state.value.hasCompletedQuestions) {
          _questionsStateNotifier.countCorrectAnswers();
        }
      }
    }
  }

  void _onDurationTimeout() {
    _questionsStateNotifier.answer(_questionTileIndex.value.maxIndex, 'X');
    _timer.cancel();
  }

  void _onAnswerTapped(int index, String answer) {
    if (_questionsStateNotifier.state.value.hasCompletedQuestions) {
      return;
    }
    _questionsStateNotifier.answer(index, answer);
    _timer.cancel();
  }

  void _onSeeResult() {
    final correctAnswers = _questionsStateNotifier.state.value.correctAnswers;
    final questionsLength = _questions.length;
    Navigator.of(context).pushNamed(
      RouteNames.result,
      arguments: {
        'correctAnswers': correctAnswers,
        'questionsLength': questionsLength,
      },
    );
  }

  Widget get _appBarSeeResultButton {
    final seeResultButton = TextButton(
      key: const ValueKey(true),
      onPressed: _onSeeResult,
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      child: const Text('LIHAT HASIL'),
    );
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: ValueListenableBuilder<QuestionsState>(
        valueListenable: _questionsStateNotifier.state,
        builder: (context, currentState, child) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (animatedChild, animation) {
              return FadeTransition(
                opacity: animation,
                child: animatedChild,
              );
            },
            child: currentState.hasCompletedQuestions ? seeResultButton : child!,
          );
        },
        child: const SizedBox(key: ValueKey(false)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
          title: ValueListenableBuilder<Duration>(
            valueListenable: _timerState,
            builder: (context, currentDuration, child) {
              if (currentDuration == Duration.zero) {
                return const Text(
                  'Waktu Habis',
                  style: TextStyle(color: Colors.pinkAccent),
                );
              }
              final currentMinute = currentDuration.inMinutes.remainder(60);
              final currentSecond = currentDuration.inSeconds.remainder(60).toString().padLeft(2, '0');

              return Text(
                '$currentMinute:$currentSecond',
                style: const TextStyle(color: Colors.pinkAccent),
              );
            },
          ),
          actions: [
            _appBarSeeResultButton,
          ],
        ),
        backgroundColor: Colors.white,
        body: ValueListenableBuilder<QuestionsState>(
          valueListenable: _questionsStateNotifier.state,
          builder: (context, state, child) {
            if (state.isLoading) {
              return child!;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: PageView.builder(
                controller: _questionTilePageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  _questionTileIndex.value = _questionTileIndex.value.copyWith(
                    currentIndex: index,
                  );
                },
                itemBuilder: (context, index) {
                  final currentQuestion = state.questions[index];
                  return _QuestionTile(
                    question: currentQuestion,
                    currentAnswer: state.userAnswers[index],
                    onAnswerTapped: (answer) => _onAnswerTapped(index, answer),
                  );
                },
                itemCount: state.questions.length,
              ),
            );
          },
          child: const _QuestionsLoadingWidget(),
        ),
        bottomSheet: ValueListenableBuilder<_QuestionTileIndexState>(
          valueListenable: _questionTileIndex,
          builder: (context, currentIndexState, child) {
            if (_questions.isEmpty) {
              return child!;
            }
            final currentIndex = currentIndexState.currentIndex;
            return _QuestionTileNavigator(
              currentIndex: currentIndex,
              onPreviousTapped: currentIndex != 0 ? _onPreviousTapped : null,
              onNextTapped:
                  currentIndexState.maxIndex > currentIndex && currentIndex < _questions.length - 1 ? _onNextTapped : null,
            );
          },
          child: const SizedBox(),
        ),
      ),
    );
  }
}

class _QuestionTileIndexState {
  const _QuestionTileIndexState({
    required this.maxIndex,
    required this.currentIndex,
  });

  final int maxIndex;
  final int currentIndex;

  factory _QuestionTileIndexState.init() {
    return const _QuestionTileIndexState(
      maxIndex: 0,
      currentIndex: -1,
    );
  }

  _QuestionTileIndexState copyWith({
    int? maxIndex,
    int? currentIndex,
  }) {
    return _QuestionTileIndexState(
      maxIndex: maxIndex ?? this.maxIndex,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _QuestionTileIndexState && other.maxIndex == maxIndex && other.currentIndex == currentIndex;
  }

  @override
  int get hashCode => maxIndex.hashCode ^ currentIndex.hashCode;
}

class _QuestionTileNavigator extends StatelessWidget {
  const _QuestionTileNavigator({
    Key? key,
    required this.currentIndex,
    required this.onPreviousTapped,
    required this.onNextTapped,
  }) : super(key: key);

  final int currentIndex;
  final VoidCallback? onPreviousTapped;
  final VoidCallback? onNextTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // previous button
          ElevatedButton(
            onPressed: onPreviousTapped,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            child: const Icon(Icons.arrow_back),
          ),
          // current page index
          Text(
            (currentIndex + 1).toString(),
            style: const TextStyle(
              color: Colors.pinkAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // next button
          ElevatedButton(
            onPressed: onNextTapped,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}

class _QuestionsLoadingWidget extends StatelessWidget {
  const _QuestionsLoadingWidget({Key? key}) : super(key: key);

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

class _QuestionTile extends StatelessWidget {
  const _QuestionTile({
    Key? key,
    required this.question,
    required this.currentAnswer,
    required this.onAnswerTapped,
  }) : super(key: key);

  final Question question;
  final String currentAnswer;
  final void Function(String answerId) onAnswerTapped;

  List<Widget> get _choicesCheckboxTile {
    final List<Widget> choices = [];
    for (int i = 0; i < question.choices.length; i++) {
      final currentChoice = question.choices[i];
      final isChoiceUrl = currentChoice.value.length > 4 && currentChoice.value.substring(0, 4) == 'http';
      final Widget title;
      if (isChoiceUrl) {
        title = Row(
          children: [
            Text(
              '${currentChoice.name}. ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            CachedNetworkImage(imageUrl: currentChoice.value),
          ],
        );
      } else {
        title = Text(
          '${currentChoice.name}. ${currentChoice.value}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      }
      final Widget trailing;
      if (currentAnswer.isNotEmpty &&
          (currentAnswer == 'X' || currentAnswer == currentChoice.id) &&
          currentChoice.id != question.answer) {
        trailing = const Icon(
          Icons.close,
          color: Colors.red,
        );
      } else if (currentAnswer.isNotEmpty && currentChoice.id == question.answer) {
        trailing = Icon(
          Icons.done,
          color: Colors.greenAccent[400],
        );
      } else {
        trailing = const SizedBox(width: 24);
      }
      final choiceTile = ListTile(
        title: title,
        trailing: trailing,
        onTap: currentAnswer.isEmpty ? () => onAnswerTapped(currentChoice.id) : null,
      );
      choices.add(choiceTile);
    }
    return choices;
  }

  List<Widget> get _explanationImage {
    return [
      const Divider(color: Colors.grey),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Pembahasan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CachedNetworkImage(
          alignment: Alignment.centerLeft,
          imageUrl: question.explanation,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Pertanyaan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CachedNetworkImage(
              alignment: Alignment.centerLeft,
              imageUrl: question.text,
            ),
          ),
          ..._choicesCheckboxTile,
          if (currentAnswer.isNotEmpty) ..._explanationImage,
        ],
      ),
    );
  }
}
