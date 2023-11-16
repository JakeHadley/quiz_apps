import 'package:flutter/material.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:four_gospels/multi_player_setup/widgets/share_code.dart';
import 'package:four_gospels/quiz/models/models.dart';
import 'package:quiz_core/models/language.dart';

class GameInfo extends StatelessWidget {
  const GameInfo({
    required this.code,
    required this.numberOfQuestions,
    required this.mode,
    required this.language,
    super.key,
  });

  final String code;
  final int numberOfQuestions;
  final Mode mode;
  final String language;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Column(
      children: [
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 40,
          runSpacing: 10,
          children: [
            Column(
              children: [
                Text(
                  l10n.confirmSettingsNumberQuestions,
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  '$numberOfQuestions',
                  style: theme.textTheme.headlineSmall,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  l10n.confirmSettingsDifficulty,
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  mode.toStringIntl(l10n),
                  style: theme.textTheme.headlineSmall,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  l10n.quizLanguage,
                  style: theme.textTheme.titleMedium,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: SizedBox(
                    height: 30,
                    width: 40,
                    child: flags[Languages.values.byName(language).index],
                  ),
                ),
              ],
            ),
          ],
        ),
        ShareCode(code: code),
      ],
    );
  }
}
