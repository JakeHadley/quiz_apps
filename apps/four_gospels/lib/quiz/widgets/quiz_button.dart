import 'package:flutter/material.dart';
import 'package:four_gospels/common_widgets/common_widgets.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:four_gospels/quiz/models/models.dart';

class QuizButton extends StatelessWidget {
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
    super.key,
  });

  final bool currentQuestionAnswered;
  final void Function({
    required QuizType quizType,
    required Mode questionMode,
    required bool allNotAnswered,
  }) onNextQuestionPress;
  final Answer selectedAnswer;
  final void Function({
    required bool isCorrect,
    required QuizType quizType,
  }) onSubmit;
  final bool lastQuestion;
  final QuizType quizType;
  final bool isMulti;
  final bool isMultiOwner;
  final Mode questionMode;
  final bool allNotAnswered;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    VoidCallback onPress;
    Color? color;
    String text;

    if (!currentQuestionAnswered) {
      text = l10n.submitButton;
    } else if (!isMulti || isMultiOwner) {
      if (lastQuestion) {
        text = l10n.finishQuizButton;
      } else {
        text = l10n.nextQuestionButton;
      }
    } else {
      text = l10n.waitingForOwner;
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
