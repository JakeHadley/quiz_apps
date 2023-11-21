import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_core/blocs/blocs.dart';
import 'package:quiz_core/common_widgets/custom_appbar.dart';
import 'package:quiz_core/models/models.dart';
import 'package:quiz_core/multi_widgets/lobby.dart';
import 'package:quiz_core/multi_widgets/lobby_back_button.dart';

///
class LobbyWrapper extends StatelessWidget {
  ///
  const LobbyWrapper({
    required this.title,
    required this.pop,
    required this.navigateToQuiz,
    required this.getModeString,
    required this.numQuestionsText,
    required this.timerText,
    required this.confirmText,
    required this.languageText,
    required this.startButtonText,
    required this.codeText,
    required this.shareText,
    required this.ownerText,
    required this.waitingForGameText,
    required this.waitingForOwnerText,
    required this.roomDeletedText,
    required this.goBackText,
    required this.confirmQuestionsText,
    required this.confirmDifficultyText,
    super.key,
  });

  ///
  final String title;

  ///
  final VoidCallback pop;

  ///
  final VoidCallback navigateToQuiz;

  ///
  final String Function(Mode mode) getModeString;

  ///
  final String numQuestionsText;

  ///
  final String timerText;

  ///
  final String confirmText;

  ///
  final String languageText;

  ///
  final String startButtonText;

  ///
  final String codeText;

  ///
  final String shareText;

  ///
  final String ownerText;

  ///
  final String waitingForGameText;

  ///
  final String waitingForOwnerText;

  ///
  final String roomDeletedText;

  ///
  final String goBackText;

  ///
  final String confirmQuestionsText;

  ///
  final String confirmDifficultyText;

  ///
  void exitAction(BuildContext context) {
    context.read<MultiPlayerBloc>().add(MultiPlayerReset());
    pop();
  }

  ///
  void onStart(BuildContext context, String code) {
    context.read<MultiPlayerBloc>().add(MultiPlayerStart(code: code));
    context.read<QuizBloc>().add(QuizLoad());
  }

  ///
  void onMultiStateChange(BuildContext context, Room room) {
    context.read<QuizBloc>().add(
          QuizStart.multi(
            numberOfQuestions: room.numberOfQuestions,
            mode: room.mode,
            questions: room.questions,
            language: room.language,
          ),
        );
  }

  ///
  void onQuizStateChange() {
    navigateToQuiz();
  }

  ///
  void onChangeSettings(
    BuildContext context,
    String code,
    SettingsOptions option,
    dynamic value,
  ) {
    context.read<MultiPlayerBloc>().add(
          MultiPlayerModifyRoomSettings(
            code: code,
            option: option,
            value: value,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        type: QuizType.multi,
        backButton: LobbyBackButton(
          exitAction: () => exitAction(context),
        ),
      ),
      body: Lobby(
        onStart: (String code) => onStart(context, code),
        onBack: () => exitAction(context),
        onMultiStateChange: (Room room) => onMultiStateChange(context, room),
        onQuizStateChange: onQuizStateChange,
        onChangeSettings: (String code, SettingsOptions option, dynamic value) {
          onChangeSettings(context, code, option, value);
        },
        getModeString: getModeString,
        numQuestionsText: numQuestionsText,
        timerText: timerText,
        confirmText: confirmText,
        languageText: languageText,
        startButtonText: startButtonText,
        codeText: codeText,
        shareText: shareText,
        ownerText: ownerText,
        waitingForGameText: waitingForGameText,
        waitingForOwnerText: waitingForOwnerText,
        roomDeletedText: roomDeletedText,
        goBackText: goBackText,
        confirmQuestionsText: confirmQuestionsText,
        confirmDifficultyText: confirmDifficultyText,
      ),
    );
  }
}
