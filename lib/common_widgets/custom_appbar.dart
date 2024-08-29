import 'package:flutter/material.dart';
import 'package:quiz_core/models/quiz_type.dart';

///
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  ///
  const CustomAppBar({
    required this.title,
    super.key,
    this.backButton,
    this.feedbackAction,
    this.type,
  });

  /// Text for app bar
  final String title;

  ///
  final Widget? backButton;

  ///
  final VoidCallback? feedbackAction;

  ///
  final QuizType? type;

  /// returns correct color based on [QuizType]
  Color? getColor(ThemeData theme) {
    switch (type) {
      case QuizType.single:
        return theme.primaryColor;
      case QuizType.speed:
        return theme.colorScheme.tertiary;
      case QuizType.multi:
        return theme.colorScheme.secondary;
      case null:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      leading: backButton,
      actions: [
        if (feedbackAction != null) ...[
          IconButton(
            icon: const Icon(Icons.feedback_outlined),
            color: Theme.of(context).iconTheme.color,
            onPressed: feedbackAction,
          ),
        ],
      ],
      backgroundColor: type != null ? getColor(theme) : null,
      centerTitle: true,
      title: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(title),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(75);
}
