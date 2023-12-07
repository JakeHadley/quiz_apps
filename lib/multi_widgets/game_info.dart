import 'package:flutter/material.dart';
import 'package:quiz_core/models/models.dart';
import 'package:quiz_core/multi_widgets/share_code.dart';

///
class GameInfo extends StatelessWidget {
  ///
  const GameInfo({
    required this.code,
    required this.numberOfQuestions,
    required this.mode,
    required this.language,
    required this.getModeString,
    required this.confirmQuestionsText,
    required this.confirmDifficultyText,
    required this.languageText,
    required this.codeText,
    required this.shareText,
    super.key,
  });

  ///
  final String code;

  ///
  final int numberOfQuestions;

  ///
  final Mode mode;

  ///
  final String language;

  ///
  final String Function(Mode mode) getModeString;

  ///
  final String confirmQuestionsText;

  ///
  final String confirmDifficultyText;

  ///
  final String languageText;

  ///
  final String codeText;

  ///
  final String shareText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  confirmQuestionsText,
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
                  confirmDifficultyText,
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  getModeString(mode),
                  style: theme.textTheme.headlineSmall,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  languageText,
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
        ShareCode(
          code: code,
          codeText: codeText,
          shareText: shareText,
        ),
      ],
    );
  }
}
