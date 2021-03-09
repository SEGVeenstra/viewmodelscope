import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

abstract class ViewModelWidget<TState> extends StatelessWidget {
  final Widget child;
  final ValueNotifier<TState> stateNotifier;
  TState get state => stateNotifier.value;

  setState(TState state) {
    stateNotifier.value = state;
  }

  ViewModelWidget({@required this.child, @required TState initialValue})
      : stateNotifier = ValueNotifier<TState>(initialValue);

  Widget build(BuildContext context) {
    return ValueListenableBuilder<TState>(
        child: child,
        valueListenable: stateNotifier,
        builder: (context, state, child) {
          return _State<TState>(state: state, child: child);
        });
  }

  static T of<T extends ViewModelWidget>(BuildContext context) {
    return context.findAncestorWidgetOfExactType<T>();
  }
}

class ViewModel<TState> {
  final ValueNotifier<TState> stateNotifier;
  TState get state => stateNotifier.value;
  Type get stateType => TState;

  ViewModel({@required TState initialState})
      : stateNotifier = ValueNotifier(initialState);

  setState(TState newState) {
    stateNotifier.value = newState;
  }
}

class ViewModelScope<TViewModel extends ViewModel> extends InheritedWidget {
  final TViewModel viewModel;
  final Widget child;

  ViewModelScope({@required this.child, @required this.viewModel});

  Widget build(BuildContext context) {
    return child;
  }

  static T of<T extends ViewModel>(BuildContext context) {
    return context.findAncestorWidgetOfExactType<ViewModelScope<T>>().viewModel;
  }

  @override
  bool updateShouldNotify(covariant ViewModelScope<TViewModel> oldWidget) =>
      true;
}

class _State<TState> extends InheritedWidget {
  final TState state;

  _State({@required Widget child, @required this.state}) : super(child: child);

  @override
  bool updateShouldNotify(covariant _State oldWidget) =>
      oldWidget.state != this.state;
}

class StateBuilder<TState> extends StatelessWidget {
  final Widget Function(TState) builder;

  StateBuilder({@required this.builder});

  @override
  Widget build(BuildContext context) {
    final state = context.dependOnInheritedWidgetOfExactType<_State<TState>>();
    return builder(state.state);
  }
}

class ViewModelBuilder<TViewModel extends ViewModel> extends StatelessWidget {
  final Widget Function(TViewModel) builder;

  ViewModelBuilder({@required this.builder});

  @override
  Widget build(BuildContext context) {
    final viewModel = context
        .dependOnInheritedWidgetOfExactType<ViewModelScope<TViewModel>>()
        .viewModel;
    return builder(viewModel);
  }
}

class StateListener<TState> extends StatelessWidget {
  final Widget child;
  final void Function(TState) listener;
  StateListener({@required this.child, @required this.listener});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TState>(
      valueListenable:
          ViewModelWidget.of<ViewModelWidget<TState>>(context).stateNotifier,
      builder: (context, state, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) => listener(state));
        return child;
      },
    );
  }
}

class NumberViewModel extends ViewModelWidget<NumberState> {
  NumberViewModel({@required Widget child})
      : super(child: child, initialValue: NumberState(0));

  increment() {
    setState(NumberState(state.current + 1));
  }
}

class NumberState {
  final int current;
  NumberState(this.current);
}

class NumViewModel extends ViewModel<int> {
  NumViewModel() : super(initialState: 0);

  increment() {
    setState(state + 1);
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
      home: ViewModelScope<NumViewModel>(
        viewModel: NumViewModel(),
        child: Builder(
          builder: (context) => Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                ViewModelScope.of<NumViewModel>(context).increment();
              },
            ),
            body: Center(
              child: ViewModelBuilder<NumViewModel>(
                builder: (vm) => Text(vm.state.toString()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
