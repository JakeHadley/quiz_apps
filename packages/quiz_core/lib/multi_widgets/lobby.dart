import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_core/blocs/multi_player_bloc/multi_player_bloc.dart';
import 'package:quiz_core/blocs/quiz_bloc/quiz_bloc.dart';
import 'package:quiz_core/common_widgets/common_widgets.dart';
import 'package:quiz_core/models/models.dart';
import 'package:quiz_core/multi_widgets/game_info.dart';
import 'package:quiz_core/multi_widgets/player_list.dart';
import 'package:quiz_core/multi_widgets/share_code.dart';

///
class Lobby extends StatelessWidget {
  ///
  const Lobby({
    required this.onStart,
    required this.onBack,
    required this.onMultiStateChange,
    required this.onQuizStateChange,
    required this.onChangeSettings,
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
  final void Function(String code) onStart;

  ///
  final VoidCallback onBack;

  ///
  final void Function(Room room) onMultiStateChange;

  ///
  final VoidCallback onQuizStateChange;

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
  final void Function(
    String code,
    SettingsOptions option,
    dynamic value,
  ) onChangeSettings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, quizState) {
        if (quizState is QuizLoaded) {
          onQuizStateChange();
        }
      },
      builder: (context, quizState) {
        return BlocConsumer<MultiPlayerBloc, MultiPlayerState>(
          listener: (context, multiState) {
            if (multiState is MultiPlayerActive) {
              if (multiState.room.status == 'active' &&
                  multiState.room.currentQuestionIndex == 0) {
                onMultiStateChange(multiState.room);
              }
            }
          },
          builder: (context, multiState) {
            if (multiState is MultiPlayerActive) {
              final room = multiState.room;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (room.owner != multiState.name) ...[
                          GameInfo(
                            code: room.code,
                            numberOfQuestions: room.numberOfQuestions,
                            mode: room.mode,
                            language: room.language,
                            getModeString: getModeString,
                            confirmQuestionsText: confirmQuestionsText,
                            confirmDifficultyText: confirmDifficultyText,
                            languageText: languageText,
                            codeText: codeText,
                            shareText: shareText,
                          ),
                        ] else ...[
                          Settings(
                            type: QuizType.multi,
                            onStateChange: ({int? timer}) {
                              // do nothing here since we're handling it already
                            },
                            onChangeSettings: (
                              SettingsOptions option,
                              dynamic value,
                            ) =>
                                onChangeSettings(room.code, option, value),
                            isCompact: true,
                            getModeString: getModeString,
                            numQuestionsText: numQuestionsText,
                            timerText: timerText,
                            confirmText: confirmText,
                            languageText: languageText,
                            startButtonText: startButtonText,
                          ),
                          ShareCode(
                            code: room.code,
                            codeText: codeText,
                            shareText: shareText,
                          ),
                        ],
                        PlayerList(
                          users: room.users,
                          owner: room.owner,
                          ownerText: ownerText,
                        ),
                        if (room.owner == multiState.name) ...[
                          ActionButton(
                            isLoading: quizState is QuizLoading,
                            onPress: () => onStart(room.code),
                            color: theme.colorScheme.primaryContainer,
                            text: startButtonText,
                          ),
                        ] else ...[
                          Text(
                            multiState.room.currentQuestionIndex > 0
                                ? '$waitingForGameText...'
                                : '$waitingForOwnerText...',
                            style: theme.textTheme.displaySmall,
                            textAlign: TextAlign.center,
                          )
                              .animate(
                                onPlay: (controller) =>
                                    controller.repeat(reverse: true),
                              )
                              .fadeIn(duration: 2.seconds),
                        ],
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              );
            }
            if (multiState is MultiPlayerRoomDeleted) {
              return SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        roomDeletedText,
                        style: theme.textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 50),
                    ActionButton(
                      onPress: onBack,
                      isLoading: multiState is MultiPlayerLoading,
                      text: goBackText,
                    ),
                  ],
                ),
              );
            }
            return const Text('Error lobby');
          },
        );
      },
    );
  }
}
