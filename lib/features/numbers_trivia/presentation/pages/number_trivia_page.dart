import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numbers/features/numbers_trivia/presentation/widgets/trivia_display.dart';
import 'package:numbers/injection_container.dart' as di;

import '../../domain/entities/number_trivia.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/trivia_controls.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Number trivia page')),
      body: BlocProvider(
        create: (_) => di.sl<NumberTriviaBloc>(),
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case Loading:
                      return Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 2,
                        child: CircularProgressIndicator(),
                      );
                    case Loaded:
                      state as Loaded;
                      return Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 2,
                        child: TriviaDisplay(
                          numberTrivia: state.numberTrivia,
                        ),
                      );
                    case Empty:
                      return Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 2,
                        child: Text('Start searching'),
                      );
                    default:
                      state as Error;
                      return Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 2,
                        child: Text('${state.message}'),
                      );
                  }
                },
              ),
              TriviaControls(),
            ],
          ),
        )),
      ),
    );
  }
}
