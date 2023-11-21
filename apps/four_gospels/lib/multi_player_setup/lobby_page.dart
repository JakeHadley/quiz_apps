import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:four_gospels/app/auto_router.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:four_gospels/quiz/models/mode.dart';
import 'package:quiz_core/models/mode.dart';
import 'package:quiz_core/multi_widgets/lobby_wrapper.dart';

@RoutePage()
class LobbyPage extends StatelessWidget {
  const LobbyPage({super.key});

  void pop(BuildContext context) {
    context.router.pop();
  }

  void navigateToQuiz(BuildContext context) {
    context.router.replaceAll([const QuizRoute()]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LobbyWrapper(
      title: l10n.lobbyAppBar,
      pop: () => pop(context),
      navigateToQuiz: () => navigateToQuiz(context),
      getModeString: (Mode mode) => getModeString(mode, l10n),
      numQuestionsText: l10n.numQuestions,
      timerText: l10n.timer,
      confirmText: l10n.confirmSettingsDifficulty,
      languageText: l10n.quizLanguage,
      startButtonText: l10n.startButton,
      codeText: l10n.code,
      shareText: l10n.share,
      ownerText: l10n.owner,
      waitingForGameText: l10n.waitingForGameFinish,
      waitingForOwnerText: l10n.waitingForOwnerStart,
      roomDeletedText: l10n.roomDeleted,
      goBackText: l10n.goBackButton,
      confirmQuestionsText: l10n.confirmSettingsNumberQuestions,
      confirmDifficultyText: l10n.confirmSettingsDifficulty,
    );
  }
}
