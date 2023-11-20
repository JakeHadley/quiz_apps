import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:four_gospels/app/auto_router.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:quiz_core/home_widgets/home_widgets.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void navigateToSingle(BuildContext context) {
    context.router.push(const SinglePlayerSetupRoute());
  }

  void navigateToMulti(BuildContext context) {
    context.router.push(const MultiPlayerSetupRoute());
  }

  void navigateToSpeed(BuildContext context) {
    context.router.push(const SpeedSetupRoute());
  }

  void onNoConnection(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.noConnection),
        backgroundColor: theme.colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return HomeWrapper(
      title: l10n.homePageAppBarTitle,
      navigateToSingle: () => navigateToSingle(context),
      navigateToMulti: () => navigateToMulti(context),
      navigateToSpeed: () => navigateToSpeed(context),
      onNoConnection: () => onNoConnection(context, l10n, theme),
      subtitleText: l10n.selectQuizSubtitle,
      singleText: l10n.singlePlayerHome,
      multiText: l10n.multiPlayer,
      speedText: l10n.speedRound,
    );
  }
}
