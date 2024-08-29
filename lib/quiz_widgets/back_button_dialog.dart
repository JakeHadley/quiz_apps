import 'package:flutter/material.dart';

///
class BackButtonDialog extends StatelessWidget {
  ///
  const BackButtonDialog({
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
    return AlertDialog(
      content: Text(captionText),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: exitAction,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          child: Text(quitText),
        ),
      ],
    );
  }
}
