import 'package:four_gospels/l10n/l10n.dart';

enum QuizType {
  single,
  speed,
  multi;

  String toStringIntl(AppLocalizations l10n) {
    if (name == single.name) {
      return l10n.singlePlayerAppBar;
    } else if (name == speed.name) {
      return l10n.speedRoundAppBar;
    } else if (name == multi.name) {
      return l10n.multiPlayerAppBar;
    }
    return '';
  }
}
