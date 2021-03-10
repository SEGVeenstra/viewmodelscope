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
      body: ViewModelConsumer<NumberViewModel>(
        // Use listeners to fire off Navigation, Dialogs, or any other action
        // which is not allowed while building the UI.
        listener: (context, vm) {
          if (vm.s.number == 10)
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('You reached 10!')));
        },
        builder: (context, vm, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '${vm.s.number}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Fabs(),
    );
  }
}

class Fabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          // You can use the context extension to access the closest ViewModel
          // when not inside the ViewModelConsumer's build function.
          onPressed: () => context.vm<NumberViewModel>().increment(),
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
        SizedBox(
          height: 10,
        ),
        ViewModelConsumer<NumberViewModel>(builder: (context, vm, _) {
          return FloatingActionButton(
            backgroundColor: vm.s.canDecrement ? null : Colors.grey,
            onPressed: vm.s.canDecrement ? () => vm.decrement() : null,
            tooltip: 'Increment',
            child: Icon(Icons.remove),
          );
        }),
      ],
    );
  }
}
