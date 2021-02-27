import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A base class that manages the state of a [ViewModel].
///
/// You should extend this class and provide actions that can [setState].
///
/// Use a [ViewModelConsumer] to consume the ViewModel
///
/// ### Example
/// ```
/// class ColorViewModel extends ViewModel<Color> {
///   final _rng = Random();
///
///   ColorViewModel({Widget child}) : super(child: child) {
///     refreshData();
///   }
///
///   refreshData() {
///     setState(Color(_rng.nextInt(0xffffff)).withAlpha(255));
///   }
/// }
/// ```
abstract class ViewModel<T> extends StatelessWidget {
  final Widget child;
  final _state = ValueNotifier<T>(null);
  T get state => _state.value;

  ViewModel({@required this.child, Key key, @required T initialState})
      : super(key: key) {
    _state.value = initialState;
  }

  @protected
  setState(T state) {
    _state.value = state;
  }

  Widget build(BuildContext context) => child;

  static T of<T extends ViewModel>(BuildContext context) {
    return context.findAncestorWidgetOfExactType<T>();
  }
}

/// A base class which is meant for consuming a [ViewModel]
///
/// [ViewModelConsumer] will try to find the first parent of the passed in [Type]
/// and passes it in the [buildView] function where you can use the passed
/// [ViewModel] to build the Widget based on the [ViewModel.state] and connect
/// user actions to functions.
///
/// ### Example
/// ```
/// class ColorWidget extends ViewModelConsumer<ColorViewModel> {
///   @override
///   Widget buildView(BuildContext context, ColorViewModel viewModel) {
///     return InkWell(
///         onTap: () {
///           viewModel.refreshData();
///         },
///         child: AnimatedContainer(
///           duration: Duration(milliseconds: 200),
///           color: viewModel.state,
///         ));
///   }
/// }
/// ```
abstract class ViewModelConsumer<TViewModel extends ViewModel, TState>
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = viewModelOf(context);
    return ValueListenableBuilder(
        valueListenable: viewModel._state,
        builder: (context, state, _) {
          return buildView(context, state);
        });
  }

  Widget buildView(BuildContext context, TState state);

  TViewModel viewModelOf(BuildContext context) {
    return ViewModel.of<TViewModel>(context);
  }
}
