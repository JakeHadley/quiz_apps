import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

///
class ShareCode extends StatelessWidget {
  ///
  const ShareCode({
    required this.code,
    required this.codeText,
    required this.shareText,
    super.key,
  });

  ///
  final String code;

  ///
  final String codeText;

  ///
  final String shareText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$codeText: $code',
          style: theme.textTheme.headlineSmall,
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => Share.share('$shareText: $code'),
          color: theme.primaryColor,
        ),
      ],
    );
  }
}
