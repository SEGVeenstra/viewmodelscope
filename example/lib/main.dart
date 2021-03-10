import 'package:flutter/material.dart';
import 'package:viewmodelscope/viewmodel.dart';

void main() {
  runApp(MyApp());
}

// Define your ViewModel, pass it the Type of the State
class NumberViewModel extends ViewModel<NumberState> {
  NumberViewModel()
      : super(initialState: NumberState(number: 0, canDecrement: false));

  increment() {
    final newState = NumberState(number: state.number + 1, canDecrement: true);
    setState(newState);
  }

  decrement() {
    if (!state.canDecrement) return;

    final newState =
        NumberState(number: state.number - 1, canDecrement: state.number > 1);
    setState(newState);
  }
}

class NumberState {
  final int number;
  final bool canDecrement;

  NumberState({@required this.number, @required this.canDecrement});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Set a ViewModelScope and pass it in an instance of the NumberViewModel
      home: ViewModelScope<NumberViewModel>(
          viewModel: NumberViewModel(),
          child: MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            // Use a ViewModelConsumer to update the UI
            ViewModelConsumer<NumberViewModel, NumberState>(
              builder: (context, state, _) => Text(
                '${state.number}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ViewModelConsumer<NumberViewModel, NumberState>(
          builder: (context, state, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                // Use the BuildContext extension to find the nearest ViewModel of a
                // specific Type to call methods on it.
                context.vm<NumberViewModel>().increment();
              },
              tooltip: 'Increment',
              child: Icon(Icons.add),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              backgroundColor: state.canDecrement ? null : Colors.grey,
              onPressed: state.canDecrement
                  ? () {
                      context.vm<NumberViewModel>().decrement();
                    }
                  : null,
              tooltip: 'Increment',
              child: Icon(Icons.remove),
            ),
          ],
        );
      }),
    );
  }
}
