import 'package:flutter/material.dart';
import 'package:quiz_core/common_widgets/action_button.dart';
import 'package:quiz_core/models/models.dart';

///
class QuizButton extends StatelessWidget {
  ///
  const QuizButton({
    required this.currentQuestionAnswered,
    required this.onNextQuestionPress,
    required this.selectedAnswer,
    required this.onSubmit,
    required this.lastQuestion,
    required this.quizType,
    required this.isMulti,
    required this.isMultiOwner,
    required this.questionMode,
    required this.allNotAnswered,
    required this.submitText,
    required this.finishQuizText,
    required this.nextQuestionText,
    required this.waitingForOwnerText,
    super.key,
  });

  ///
  final bool currentQuestionAnswered;

  ///
  final void Function({
    required QuizType quizType,
    required Mode questionMode,
    required bool allNotAnswered,
  }) onNextQuestionPress;

  ///
  final Answer selectedAnswer;

  ///
  final void Function({
    required bool isCorrect,
    required QuizType quizType,
  }) onSubmit;

  ///
  final bool lastQuestion;

  ///
  final QuizType quizType;

  ///
  final bool isMulti;

  ///
  final bool isMultiOwner;

  ///
  final Mode questionMode;

  ///
  final bool allNotAnswered;

  ///
  final String submitText;

  ///
  final String finishQuizText;

  ///
  final String nextQuestionText;

  ///
  final String waitingForOwnerText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    VoidCallback onPress;
    Color? color;
    String text;

    if (!currentQuestionAnswered) {
      text = submitText;
    } else if (!isMulti || isMultiOwner) {
      if (lastQuestion) {
        text = finishQuizText;
      } else {
        text = nextQuestionText;
      }
    } else {
      text = waitingForOwnerText;
    }

    if (!currentQuestionAnswered) {
      // if not submitted
      if (selectedAnswer.isEmpty()) {
        onPress = () {};
      } else {
        onPress = () => onSubmit(
              isCorrect: selectedAnswer.isCorrect,
              quizType: quizType,
            );
      }
      color = theme.colorScheme.primaryContainer;
    } else if (!isMulti || isMultiOwner) {
      // if submitted and not multiplayer
      // or if submitted and is multiplayer and is the owner
      onPress = () => onNextQuestionPress(
            quizType: quizType,
            questionMode: questionMode,
            allNotAnswered: allNotAnswered,
          );
    } else {
      onPress = () {};
      color = theme.disabledColor;
    }

    return AnimatedOpacity(
      opacity: selectedAnswer.isEmpty() ? 0 : 1,
      duration:
          selectedAnswer.isEmpty() ? Duration.zero : const Duration(seconds: 1),
      child: ActionButton(
        isLoading: false,
        onPress: onPress,
        text: text,
        color: color,
      ),
    );
  }
}
