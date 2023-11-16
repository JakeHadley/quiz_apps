import 'package:flutter/material.dart';

class OptionItem extends StatelessWidget {
  const OptionItem({
    required this.text,
    required this.action,
    required this.color,
    required this.iconWidget,
    super.key,
    this.darkText = false,
    this.equalWidth = false,
  });

  final String text;
  final void Function()? action;
  final Color color;
  final Widget iconWidget;
  final bool darkText;
  final bool equalWidth;

  @override
  Widget build(BuildContext context) {
    final border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40),
    );

    final textStyle = darkText
        ? Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).primaryIconTheme.color,
            )
        : Theme.of(context).textTheme.headlineMedium;

    return SizedBox(
      height: 100,
      child: Card(
        shape: border,
        color: color,
        child: InkWell(
          customBorder: border,
          onTap: action,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Expanded(flex: equalWidth ? 1 : 0, child: iconWidget),
                Expanded(
                  child: Text(
                    text,
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
