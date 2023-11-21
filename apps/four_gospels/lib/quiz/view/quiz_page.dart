import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:four_gospels/app/auto_router.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:four_gospels/quiz/models/mode.dart';
import 'package:four_gospels/quiz/models/quiz_type.dart';
import 'package:quiz_core/blocs/blocs.dart';
import 'package:quiz_core/models/models.dart';
import 'package:quiz_core/quiz_widgets/quiz_wrapper.dart';

@RoutePage()
class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  void _exitAction(BuildContext context) {
    context.read<QuizBloc>().add(QuizFinished());
    context.read<MultiPlayerBloc>().add(MultiPlayerReset());
    context.read<TimerBloc>().add(TimerReset());
    context.router.replaceAll([const HomeRoute()]);
  }

  void navigateToEndGame(BuildContext context, QuizType quizType) {
    context.router.replaceAll([EndGameRoute(quizType: quizType)]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return QuizWrapper(
      getTypeString: (QuizType type) => getTypeString(type, l10n),
      getModeString: (Mode mode) => getModeString(mode, l10n),
      captionText: l10n.quitDialogCaption,
      quitText: l10n.quitDialogQuit,
      cancelText: l10n.quitDialogCancel,
      feedbackPromptText: l10n.feedbackPrompt,
      continueText: l10n.continueButton,
      deviceInfoText: l10n.deviceInfo,
      feedbackText: l10n.feedback,
      nextQuestionPromptText: l10n.nextQuestionPrompt,
      submitText: l10n.submitButton,
      finishQuizText: l10n.finishQuizButton,
      nextQuestionText: l10n.nextQuestionButton,
      waitingForOwnerText: l10n.waitingForOwner,
      quizSubtitleText: l10n.quizSubtitleQuestion,
      quizSubtitleOfText: l10n.quizSubtitleOf,
      endGameInfoText: l10n.endGameInfoScore,
      localeNameText: l10n.localeName,
      exitAction: () => _exitAction(context),
      navigateToEndGame: (QuizType quizType) =>
          navigateToEndGame(context, quizType),
    );
  }
}
