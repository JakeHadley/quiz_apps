import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quiz_core/helpers/helpers.dart';
import 'package:url_launcher/url_launcher.dart';

///
class Reference extends StatelessWidget {
  ///
  const Reference({
    required this.reference,
    required this.currentQuestionAnswered,
    required this.localeNameText,
    super.key,
  });

  ///
  final String reference;

  ///
  final bool currentQuestionAnswered;

  ///
  final String localeNameText;

  @override
  Widget build(BuildContext context) {
    final uri = getUriFromReference(reference, localeNameText);
    return AnimatedOpacity(
      opacity: currentQuestionAnswered ? 1 : 0,
      duration:
          currentQuestionAnswered ? const Duration(seconds: 1) : Duration.zero,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: reference,
              style: Theme.of(context).textTheme.bodySmall,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    throw Exception('Could not launch');
                  }
                },
            ),
          ],
        ),
      ),
    );
  }
}
