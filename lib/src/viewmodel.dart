import 'package:flutter/widgets.dart';

abstract class ViewModel extends StatelessWidget {
  final Widget child;

  ViewModel({@required this.child, Key key}) : super(key: key);

  Widget build(BuildContext context) => child;

  static T of<T extends ViewModel>(BuildContext context) {
    return context.findAncestorWidgetOfExactType<T>();
  }
}
