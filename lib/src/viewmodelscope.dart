import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ViewModelScope<TViewModel extends ViewModel> extends InheritedWidget {
  final TViewModel viewModel;

  ViewModelScope({required Widget child, required this.viewModel})
      : super(child: child);

  @override
  bool updateShouldNotify(covariant ViewModelScope<TViewModel> oldWidget) {
    return oldWidget.viewModel.state != viewModel.state;
  }
}

abstract class ViewModel<TState> {
  final ValueNotifier<TState> stateNotifier;
  TState get state => stateNotifier.value;
  TState get s => state;

  ViewModel({required TState initialState})
      : stateNotifier = ValueNotifier(initialState) {
    assert(initialState != null,
        "You must provide an initialState for ${this.runtimeType}");
  }

  setState(TState newState) {
    stateNotifier.value = newState;
  }

  static T of<T extends ViewModel>(BuildContext context) {
    final widget = context.findAncestorWidgetOfExactType<ViewModelScope<T>>();
    assert(widget != null, 'Could not find a ViewModelScope for Type: $T');
    return widget!.viewModel;
  }
}

class ViewModelConsumer<TViewmodel extends ViewModel> extends StatelessWidget {
  final Widget child;
  final bool update;

  final Widget Function(BuildContext, TViewmodel, Widget)? builder;
  final void Function(BuildContext, TViewmodel)? listener;

  ViewModelConsumer({this.builder, this.listener, Widget? child, bool? update})
      : child = child ??= Container(),
        update = update ??= true,
        assert(builder != null || listener != null,
            'Use atleast builder OR listener'),
        assert(update || listener != null,
            'Listener will not be triggered if update is false');

  @override
  Widget build(BuildContext context) {
    final viewModel = context.vm<TViewmodel>();
    return update
        ? ValueListenableBuilder(
            child: child,
            valueListenable: viewModel.stateNotifier,
            builder: (context, dynamic _, child) {
              if (listener != null) {
                WidgetsBinding.instance!
                    .addPostFrameCallback((_) => listener!(context, viewModel));
              }
              return builder == null
                  ? child!
                  : builder!(context, viewModel, child!);
            },
          )
        : builder == null
            ? child
            : builder!(context, viewModel, child);
  }
}

extension ViewModelScopeContextExtension on BuildContext {
  T vm<T extends ViewModel>() {
    return ViewModel.of<T>(this);
  }
}
