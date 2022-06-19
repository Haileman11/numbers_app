import 'package:flutter/material.dart';

import '../../domain/entities/number_trivia.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;
  const TriviaDisplay({Key? key, required this.numberTrivia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${numberTrivia.number}",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          numberTrivia.text,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
