import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:viewmodel/viewmodel.dart';

void main() {
  runApp(MyApp());
}

/// A [ViewModel] which will keep track of a counter.
///
/// Expose [counter] to get the value and
/// defines [increment] to increment the [counter].
class CounterViewModel extends ViewModel {
  final ValueNotifier<int> _counter = ValueNotifier(0);
  ValueListenable<int> get counter => _counter;

  CounterViewModel({Widget child}) : super(child: child);

  increment() {
    _counter.value = _counter.value + 1;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CounterViewModel(child: CountersPage()),
    );
  }
}

class CountersPage extends ViewModelConsumer<CounterViewModel> {
  @override
  Widget buildView(BuildContext context, CounterViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CountersPage'),
      ),
      body: Column(
        children: [
          TextualCounterWidget(),
          TextualCounterWidget(),
          TextualCounterWidget(),
          VisualCounterWidget()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          viewModel.increment();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class TextualCounterWidget extends ViewModelConsumer<CounterViewModel> {
  @override
  Widget buildView(BuildContext context, CounterViewModel viewModel) {
    return Center(
      child: ValueListenableBuilder<int>(
          valueListenable: viewModel.counter,
          builder: (context, count, _) {
            return Text('Counter: $count');
          }),
    );
  }
}

class VisualCounterWidget extends ViewModelConsumer<CounterViewModel> {
  @override
  Widget buildView(BuildContext context, CounterViewModel viewModel) {
    return ValueListenableBuilder<int>(
        valueListenable: viewModel.counter,
        builder: (context, count, _) {
          return Row(
            children: List.generate(
                count,
                (index) => Container(
                      color: Colors.amber,
                      child: Text('$index'),
                    )),
          );
        });
  }
}
