import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:four_gospels/quiz/helpers/points_helper.dart';
import 'package:four_gospels/quiz/models/models.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    required this.answer,
    required this.currentQuestionAnswered,
    required this.onPress,
    required this.selectedAnswer,
    required this.quizType,
    required this.questionMode,
    super.key,
  });

  final Answer answer;
  final bool currentQuestionAnswered;
  final void Function({
    required Answer answer,
    required QuizType quizType,
    required Mode questionMode,
  }) onPress;
  final Answer selectedAnswer;
  final QuizType quizType;
  final Mode questionMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    var color =
        selectedAnswer == answer ? theme.disabledColor : theme.cardColor;
    var textTheme = theme.textTheme.bodyLarge;
    var shouldShowBadge = false;
    var badgeColor = theme.primaryColor;
    var badgeText = '+${getPoints(questionMode, quizType)}';

    if (currentQuestionAnswered) {
      if (answer.isCorrect) {
        color = theme.colorScheme.primary;
        textTheme = textTheme?.copyWith(color: theme.cardColor);
        if (answer == selectedAnswer) {
          shouldShowBadge = true;
        }
      } else if (selectedAnswer.key == answer.key) {
        shouldShowBadge = true;
        color = theme.colorScheme.error;
        textTheme = textTheme?.copyWith(color: theme.cardColor);
        badgeColor = theme.primaryColorLight;
        badgeText = '-1';
      }
    }

    VoidCallback onTap;
    if (currentQuestionAnswered) {
      onTap = () {};
    } else {
      onTap = () => onPress(
            answer: answer,
            quizType: quizType,
            questionMode: questionMode,
          );
    }

    return GestureDetector(
      onTap: onTap,
      child: badges.Badge(
        badgeContent: Text(
          badgeText,
          style: theme.textTheme.titleMedium
              ?.merge(TextStyle(color: theme.cardColor)),
        ),
        badgeStyle: badges.BadgeStyle(
          padding: const EdgeInsets.all(12),
          badgeColor: badgeColor,
          borderSide: BorderSide(
            color: theme.primaryColorLight,
          ),
        ),
        showBadge: shouldShowBadge,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            child: AnimatedContainer(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 16,
              ),
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: theme.dividerColor),
              ),
              duration: const Duration(milliseconds: 400),
              child: Text(
                answer.text,
                style: textTheme,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
