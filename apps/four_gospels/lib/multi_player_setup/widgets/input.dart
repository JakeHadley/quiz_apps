import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  const Input({
    required this.controller,
    required this.label,
    super.key,
  });

  final TextEditingController controller;
  final String label;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextField(
        autocorrect: false,
        decoration: InputDecoration(labelText: widget.label),
        controller: widget.controller,
      ),
    );
  }
}
