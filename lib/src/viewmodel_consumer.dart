import 'package:flutter/widgets.dart';
import 'package:viewmodel/src/viewmodel.dart';

abstract class ViewModelConsumer<T extends ViewModel> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildView(context, viewModelOf(context));
  }

  Widget buildView(BuildContext context, T viewModel);

  T viewModelOf(BuildContext context) {
    return ViewModel.of<T>(context);
  }
}
