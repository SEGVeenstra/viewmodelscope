import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ViewModelScope(
        viewModel: NumberViewModel(),
        child: NumberPage(),
      ),
    );
  }
}

class NumberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ViewModelScope.of<NumberViewModel>(context).increment();
        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: ViewModelConsumer<NumberViewModel, int>(
          listener: (context, state) {
            if (state % 5 == 0) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('5!'),
              ));
            }
            if (state > 15) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewModelScope(
                          viewModel: NumberViewModel(), child: NumberPage())));
            }
          },
          builder: (context, value, _) {
            return Text(value.toString());
          },
        ),
      ),
    );
  }
}

class NumberViewModel extends ViewModel<int> {
  NumberViewModel() : super(initialState: 0);

  increment() {
    setState(state + 1);
  }
}

// ----------- LIB ------------ //

class ViewModelScope<TViewModel extends ViewModel> extends InheritedWidget {
  final TViewModel viewModel;

  ViewModelScope({@required Widget child, @required this.viewModel})
      : super(child: child);

  @override
  bool updateShouldNotify(covariant ViewModelScope<TViewModel> oldWidget) {
    return oldWidget.viewModel.state != viewModel.state;
  }

  static T of<T extends ViewModel>(BuildContext context) {
    final widget = context.findAncestorWidgetOfExactType<ViewModelScope<T>>();
    assert(widget != null, 'Could not find a ViewModelScope for Type: $T');
    return widget.viewModel;
  }
}

abstract class ViewModel<TState> {
  final ValueNotifier<TState> stateNotifier;
  TState get state => stateNotifier.value;

  ViewModel({@required TState initialState})
      : stateNotifier = ValueNotifier(initialState);

  setState(TState newState) {
    stateNotifier.value = newState;
  }
}

class ViewModelConsumer<TViewmodel extends ViewModel, TState>
    extends StatelessWidget {
  final Widget child;
  final Widget Function(BuildContext, TState, Widget) builder;
  final void Function(BuildContext, TState) listener;

  ViewModelConsumer({this.builder, this.listener, Widget child})
      : child = child ??= Container();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TState>(
      child: child,
      valueListenable: ViewModelScope.of<TViewmodel>(context).stateNotifier
          as ValueNotifier<TState>,
      builder: (context, state, child) {
        if (listener != null) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => listener(context, state));
        }
        return builder == null ? child : builder(context, state, child);
      },
    );
  }
}
