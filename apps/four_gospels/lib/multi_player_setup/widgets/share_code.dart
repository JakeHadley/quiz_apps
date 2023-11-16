import 'package:flutter/material.dart';
import 'package:four_gospels/l10n/l10n.dart';
import 'package:share_plus/share_plus.dart';

class ShareCode extends StatelessWidget {
  const ShareCode({
    required this.code,
    super.key,
  });

  final String code;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${l10n.code}: $code',
          style: theme.textTheme.headlineSmall,
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => Share.share('${l10n.share}: $code'),
          color: theme.primaryColor,
        ),
      ],
    );
  }
}
