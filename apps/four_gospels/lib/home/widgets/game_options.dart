import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:four_gospels/app/auto_router.dart';
import 'package:four_gospels/home/widgets/option_item.dart';
import 'package:four_gospels/l10n/l10n.dart';

class GameOptions extends StatefulWidget {
  const GameOptions({super.key});

  @override
  State<GameOptions> createState() => _GameOptionsState();
}

class _GameOptionsState extends State<GameOptions> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    void showConnectionSnackbar() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.noConnection),
          backgroundColor: theme.colorScheme.error,
        ),
      );
    }

    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        VoidCallback multiPlayerFunction;
        Color multiPlayerColor;

        if (snapshot.hasData &&
            (snapshot.data == ConnectivityResult.mobile ||
                snapshot.data == ConnectivityResult.wifi)) {
          multiPlayerFunction =
              () => context.router.push(const MultiPlayerSetupRoute());
          multiPlayerColor = theme.colorScheme.secondary;
        } else {
          multiPlayerFunction = showConnectionSnackbar;
          multiPlayerColor = theme.disabledColor;
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.selectQuizSubtitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
              OptionItem(
                text: l10n.singlePlayerHome,
                action: () =>
                    context.router.push(const SinglePlayerSetupRoute()),
                color: theme.primaryColorDark,
                iconWidget: const Icon(Icons.person, size: 80),
              ),
              const SizedBox(height: 20),
              OptionItem(
                text: l10n.multiPlayer,
                action: multiPlayerFunction,
                color: multiPlayerColor,
                iconWidget: const Icon(Icons.groups, size: 80),
              ),
              const SizedBox(height: 20),
              OptionItem(
                text: l10n.speedRound,
                action: () => context.router.push(const SpeedSetupRoute()),
                color: theme.colorScheme.tertiary,
                iconWidget: const Icon(Icons.av_timer, size: 80),
              ),
            ],
          ),
        );
      },
    );
  }
}
