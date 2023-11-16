import 'package:flutter/material.dart';
import 'package:four_gospels/l10n/l10n.dart';

class BackButtonDialog extends StatelessWidget {
  const BackButtonDialog({
    required this.exitAction,
    super.key,
  });

  final VoidCallback exitAction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      content: Text(l10n.quitDialogCaption),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.quitDialogCancel),
        ),
        ElevatedButton(
          onPressed: exitAction,
          child: Text(l10n.quitDialogQuit),
        ),
      ],
    );
  }
}
