import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

abstract class ViewModel<T> extends StatelessWidget {
  final Widget child;
  final _state = ValueNotifier<T>(null);
  ValueListenable<T> get state => _state;

  ViewModel({@required this.child, Key key, T initialState}) : super(key: key) {
    _state.value = initialState;
  }

  setState(T state) {
    _state.value = state;
  }

  Widget build(BuildContext context) => child;

  static T of<T extends ViewModel>(BuildContext context) {
    return context.findAncestorWidgetOfExactType<T>();
  }
}
