import 'package:flutter/material.dart';
import 'package:viewmodelscope/viewmodelscope.dart';

void main() {
  runApp(MyApp());
}

// Define your State object
class NumberState {
  final int number;
  final bool canDecrement;

  NumberState({@required this.number, @required this.canDecrement});
}

// Define your ViewModel, pass it the Type of the State
class NumberViewModel extends ViewModel<NumberState> {
  NumberViewModel()
      // Pass the initial state for the Viewmodel
      : super(initialState: NumberState(number: 0, canDecrement: false));

  increment() {
    // You can access the previous state to calculate the new state
    final newState = NumberState(number: state.number + 1, canDecrement: true);
    // Use setState() to set the new state
    setState(newState);
  }

  decrement() {
    // Use the current state to make decisions on how to update the state
    if (!state.canDecrement) return;

    final newState =
        NumberState(number: state.number - 1, canDecrement: state.number > 1);
    setState(newState);
  }
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
      // Use a ViewModelConsumer to use the nearest ViewModel of the given Type.
      body: ViewModelConsumer<NumberViewModel>(
        // Use listener to fire off Navigation, Dialogs, or any other action
        // that is not allowed while building the UI.
        listener: (context, vm) {
          if (vm.s.number == 10)
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('You reached 10!')));
        },
        // Use builder to build your UI.
        builder: (context, vm, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                // Access the ViewModel's state to build your UI.
                // vm.s is just a shorter notation for vm.state.
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
          //
          // This FAB doesn't update so no need for a ViewModelConsumer
          onPressed: () => context.vm<NumberViewModel>().increment(),
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
        SizedBox(
          height: 10,
        ),
        // This next FAB disables whenever the number is 0.
        // To make it update, we use the ViewModelConsumer.
        ViewModelConsumer<NumberViewModel>(builder: (context, vm, _) {
          return FloatingActionButton(
            backgroundColor: vm.s.canDecrement ? null : Colors.grey,
            onPressed: vm.s.canDecrement
                ? () =>
                    // Because we are inside the build function we can easily access
                    // the ViewModel and call functions on it.
                    vm.decrement()
                : null,
            tooltip: 'Increment',
            child: Icon(Icons.remove),
          );
        }),
      ],
    );
  }
}
