import 'package:flutter/material.dart';
import 'package:viewmodel/viewmodel.dart';

void main() {
  runApp(MyApp());
}

// Define your ViewModel, pass it the Type of the State
class NumberViewModel extends ViewModel<int> {
  NumberViewModel() : super(initialState: 0);

  increment() {
    setState(state + 1);
  }

  decrement() {
    setState(state - 1);
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            // Use a ViewModelConsumer to update the UI
            ViewModelConsumer<NumberViewModel, int>(
              builder: (context, state, _) => Text(
                '$state',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Use ViewModelScope.of to find the nearest ViewModelScope of a
              // specific Type to call methods on it.
              ViewModelScope.of<NumberViewModel>(context).increment();
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () {
              // Use ViewModelScope.of to find the nearest ViewModelScope of a
              // specific Type to call methods on it.
              ViewModelScope.of<NumberViewModel>(context).decrement()();
            },
            tooltip: 'Increment',
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
