import 'package:flutter/material.dart';
import 'package:four_gospels/quiz/widgets/back_button_dialog.dart';

class QuizBackButton extends StatelessWidget {
  const QuizBackButton({
    required this.exitAction,
    super.key,
  });

  final VoidCallback exitAction;

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => BackButtonDialog(
            exitAction: exitAction,
          ),
        );
      },
    );
  }
}
