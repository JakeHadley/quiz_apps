import 'package:flutter/material.dart';
import 'package:quiz_core/quiz_widgets/back_button_dialog.dart';

///
class QuizBackButton extends StatelessWidget {
  ///
  const QuizBackButton({
    required this.exitAction,
    required this.captionText,
    required this.quitText,
    required this.cancelText,
    super.key,
  });

  ///
  final VoidCallback exitAction;

  ///
  final String captionText;

  ///
  final String quitText;

  ///
  final String cancelText;

  @override
  Widget build(BuildContext context) {
    return BackButton(
      color: Theme.of(context).iconTheme.color,
      onPressed: () {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => BackButtonDialog(
            exitAction: exitAction,
            captionText: captionText,
            quitText: quitText,
            cancelText: cancelText,
          ),
        );
      },
    );
  }
}
