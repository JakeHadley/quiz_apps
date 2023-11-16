import 'package:flutter/material.dart';
import 'package:four_gospels/l10n/l10n.dart';

class PlayerList extends StatelessWidget {
  const PlayerList({
    required this.users,
    required this.owner,
    super.key,
  });

  final List<String> users;
  final String owner;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var text = Text(users[index]);
              if (owner == users[index]) {
                text = Text('${users[index]} (${l10n.owner})');
              }
              return ListTile(
                title: text,
              );
            },
          ),
        ),
      ),
    );
  }
}
