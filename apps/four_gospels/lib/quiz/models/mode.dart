import 'package:four_gospels/l10n/l10n.dart';
import 'package:quiz_core/models/mode.dart';

extension LocalizedMode on Mode {
  String toStringIntl(AppLocalizations l10n) {
    if (name == Mode.easy.name) {
      return l10n.difficultyEasy;
    } else if (name == Mode.moderate.name) {
      return l10n.difficultyModerate;
    } else if (name == Mode.difficult.name) {
      return l10n.difficultyHard;
    } else if (name == Mode.random.name) {
      return l10n.random;
    }
    return '';
  }
}

String getModeString(Mode mode, AppLocalizations l10n) {
  return mode.toStringIntl(l10n);
}
