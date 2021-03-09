import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

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
      : stateNotifier = ValueNotifier(initialState) {
    assert(initialState != null,
        "You must provide an initialState for ${this.runtimeType}");
  }

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
