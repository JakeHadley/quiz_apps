import 'package:flutter/material.dart';

///
class LobbyBackButton extends StatelessWidget {
  ///
  const LobbyBackButton({
    required this.exitAction,
    super.key,
  });

  ///
  final VoidCallback exitAction;

  @override
  Widget build(BuildContext context) {
    return BackButton(
      color: Theme.of(context).iconTheme.color,
      onPressed: exitAction,
    );
  }
}
