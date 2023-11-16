import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:four_gospels/app/auto_router.dart';
import 'package:four_gospels/common_widgets/common_widgets.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:four_gospels/models/models.dart';
import 'package:four_gospels/multi_player_setup/multi_player_setup.dart';
import 'package:four_gospels/multi_player_setup/widgets/lobby_back_button.dart';
import 'package:four_gospels/multi_player_setup/widgets/widgets.dart';
import 'package:four_gospels/quiz/quiz.dart';

@RoutePage()
class LobbyPage extends StatelessWidget {
  const LobbyPage({super.key});

  void onStart(BuildContext context, String code) {
    context.read<MultiPlayerBloc>().add(MultiPlayerStart(code: code));
    context.read<QuizBloc>().add(QuizLoad());
  }

  void exitAction(BuildContext context) {
    context.read<MultiPlayerBloc>().add(MultiPlayerReset());
    context.router.pop();
  }

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

  void onQuizStateChange(BuildContext context) {
    context.router.replaceAll([const QuizRoute()]);
  }

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
    final l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.lobbyAppBar,
        type: QuizType.multi,
        backButton: LobbyBackButton(
          exitAction: () {
            exitAction(context);
          },
        ),
      ),
      body: Lobby(
        onStart: (String code) {
          onStart(context, code);
        },
        onBack: () {
          exitAction(context);
        },
        onMultiStateChange: (Room room) {
          onMultiStateChange(context, room);
        },
        onQuizStateChange: () {
          onQuizStateChange(context);
        },
        onChangeSettings: (String code, SettingsOptions option, dynamic value) {
          onChangeSettings(context, code, option, value);
        },
      ),
    );
  }
}
