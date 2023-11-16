import 'package:four_gospels/l10n/l10n.dart';

enum Mode {
  easy,
  moderate,
  difficult,
  random;

  String toJson() => name;
  static Mode fromJson(String json) {
    final jsonString = json.toLowerCase();

    return values.byName(jsonString);
  }

  String toStringIntl(AppLocalizations l10n) {
    if (name == easy.name) {
      return l10n.difficultyEasy;
    } else if (name == moderate.name) {
      return l10n.difficultyModerate;
    } else if (name == difficult.name) {
      return l10n.difficultyHard;
    } else if (name == random.name) {
      return l10n.random;
    }
    return '';
  }
}
