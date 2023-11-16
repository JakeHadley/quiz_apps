import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    required this.onPress,
    required this.isLoading,
    required this.text,
    this.height = 65,
    this.color,
    this.textStyle,
    super.key,
  });

  final VoidCallback onPress;
  final bool isLoading;
  final String text;
  final double height;
  final Color? color;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = isLoading ? 100.0 : 315.0;

    return GestureDetector(
      onTap: isLoading ? () {} : onPress,
      child: AnimatedContainer(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: color ?? theme.primaryColor,
        ),
        duration: const Duration(milliseconds: 200),
        width: width,
        height: height,
        child: AnimatedSwitcher(
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(text, style: textStyle ?? theme.textTheme.headlineMedium),
        ),
      ),
    );
  }
}
