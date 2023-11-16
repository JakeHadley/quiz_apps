import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  const InfoBox({
    required this.text1,
    required this.text2,
    super.key,
  });

  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                text1,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                text2,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
