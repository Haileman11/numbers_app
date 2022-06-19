import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  String inputString = "";
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: (value) {
            inputString = value;
          },
          controller: controller,
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(onPressed: search, child: Text('Search')),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              ElevatedButton(onPressed: getRandom, child: Text('Get random')),
        ),
      ],
    );
  }

  void search() {
    context
        .read<NumberTriviaBloc>()
        .add(GetConcreteNumberTriviaEvent(inputString));
  }

  void getRandom() {
    context.read<NumberTriviaBloc>().add(GetRandomNumberTriviaEvent());
  }
}
