import 'package:four_gospels/l10n/l10n.dart';
import 'package:quiz_core/models/quiz_type.dart';

extension LocalizedQuizType on QuizType {
  String toStringIntl(AppLocalizations l10n) {
    if (name == QuizType.single.name) {
      return l10n.singlePlayerAppBar;
    } else if (name == QuizType.speed.name) {
      return l10n.speedRoundAppBar;
    } else if (name == QuizType.multi.name) {
      return l10n.multiPlayerAppBar;
    }
    return '';
  }
}

String getTypeString(QuizType type, AppLocalizations l10n) {
  return type.toStringIntl(l10n);
}
