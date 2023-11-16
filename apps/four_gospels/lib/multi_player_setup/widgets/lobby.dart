import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:four_gospels/common_widgets/common_widgets.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:four_gospels/models/models.dart';
import 'package:four_gospels/multi_player_setup/multi_player_setup.dart';
import 'package:four_gospels/multi_player_setup/widgets/share_code.dart';
import 'package:four_gospels/multi_player_setup/widgets/widgets.dart';
import 'package:four_gospels/quiz/bloc/quiz_bloc.dart';
import 'package:four_gospels/quiz/models/models.dart';

class Lobby extends StatelessWidget {
  const Lobby({
    required this.onStart,
    required this.onBack,
    required this.onMultiStateChange,
    required this.onQuizStateChange,
    required this.onChangeSettings,
    super.key,
  });

  final void Function(String code) onStart;
  final VoidCallback onBack;
  final void Function(Room room) onMultiStateChange;
  final VoidCallback onQuizStateChange;
  final void Function(
    String code,
    SettingsOptions option,
    dynamic value,
  ) onChangeSettings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

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
                          ),
                          ShareCode(code: room.code),
                        ],
                        PlayerList(
                          users: room.users,
                          owner: room.owner,
                        ),
                        if (room.owner == multiState.name) ...[
                          ActionButton(
                            isLoading: quizState is QuizLoading,
                            onPress: () => onStart(room.code),
                            color: theme.colorScheme.primaryContainer,
                            text: l10n.startButton,
                          ),
                        ] else ...[
                          Text(
                            multiState.room.currentQuestionIndex > 0
                                ? '${l10n.waitingForGameFinish}...'
                                : '${l10n.waitingForOwnerStart}...',
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
                        l10n.roomDeleted,
                        style: theme.textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 50),
                    ActionButton(
                      onPress: onBack,
                      isLoading: multiState is MultiPlayerLoading,
                      text: l10n.goBackButton,
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
