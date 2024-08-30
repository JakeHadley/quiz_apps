import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:quiz_core/home_widgets/option_item.dart';

///
class GameOptions extends StatelessWidget {
  ///
  const GameOptions({
    required this.navigateToSingle,
    required this.navigateToMulti,
    required this.navigateToSpeed,
    required this.onNoConnection,
    required this.subtitleText,
    required this.singleText,
    required this.multiText,
    required this.speedText,
    super.key,
  });

  ///
  final VoidCallback navigateToSingle;

  ///
  final VoidCallback navigateToMulti;

  ///
  final VoidCallback navigateToSpeed;

  ///
  final VoidCallback onNoConnection;

  ///
  final String subtitleText;

  ///
  final String singleText;

  ///
  final String multiText;

  ///
  final String speedText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        VoidCallback multiPlayerFunction;
        Color multiPlayerColor;

        if (snapshot.hasData &&
            snapshot.data != null &&
            (snapshot.data!.contains(ConnectivityResult.mobile) ||
                snapshot.data!.contains(ConnectivityResult.wifi) ||
                snapshot.data!.contains(ConnectivityResult.ethernet))) {
          multiPlayerFunction = navigateToMulti;
          multiPlayerColor = theme.colorScheme.secondary;
        } else {
          multiPlayerFunction = onNoConnection;
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
                    subtitleText,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
              OptionItem(
                text: singleText,
                action: navigateToSingle,
                color: theme.primaryColorDark,
                iconWidget: const Icon(Icons.person, size: 80),
              ),
              const SizedBox(height: 20),
              OptionItem(
                text: multiText,
                action: multiPlayerFunction,
                color: multiPlayerColor,
                iconWidget: const Icon(Icons.groups, size: 80),
              ),
              const SizedBox(height: 20),
              OptionItem(
                text: speedText,
                action: navigateToSpeed,
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
