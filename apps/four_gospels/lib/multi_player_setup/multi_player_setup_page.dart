import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:four_gospels/app/auto_router.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:quiz_core/multi_widgets/multi_player_setup_wrapper.dart';

@RoutePage()
class MultiPlayerSetupPage extends StatefulWidget {
  const MultiPlayerSetupPage({super.key});

  @override
  State<MultiPlayerSetupPage> createState() => _MultiPlayerSetupPageState();
}

class _MultiPlayerSetupPageState extends State<MultiPlayerSetupPage> {
  void navigateToLobby(BuildContext context) {
    context.router.navigate(const LobbyRoute());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MultiPlayerSetupWrapper(
      title: l10n.multiPlayerAppBar,
      navigateToLobby: () => navigateToLobby(context),
      nameTakenText: l10n.nameTaken,
      noRoomText: l10n.noRoom,
      enterNameText: l10n.enterNameField,
      createGameText: l10n.createGameButton,
      orText: l10n.or,
      enterCodeText: l10n.enterCodeField,
      joinGameText: l10n.joinGameButton,
    );
  }
}
