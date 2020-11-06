import 'dart:math';

import 'package:flutter/material.dart';
import 'package:viewmodel/viewmodel.dart';

void main() {
  runApp(MyApp());
}

class ColorViewModel extends ViewModel<Color> {
  final _rng = Random();

  ColorViewModel({Widget child}) : super(child: child) {
    refreshData();
  }

  refreshData() {
    setState(Color(_rng.nextInt(0xffffff)).withAlpha(255));
  }
}

class ColorWidget extends ViewModelConsumer<ColorViewModel> {
  @override
  Widget buildView(BuildContext context, ColorViewModel viewModel) {
    return InkWell(
      onTap: () {
        viewModel.refreshData();
      },
      child: ValueListenableBuilder<Color>(
          valueListenable: viewModel.state,
          builder: (context, color, _) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 500),
              color: color,
            );
          }),
    );
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
      home: Scaffold(
        appBar: AppBar(
          title: Text('ViewModel Sample'),
        ),
        body: ColorViewModel(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: ColorWidget()),
                  Expanded(child: ColorViewModel(child: ColorWidget())),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: ColorWidget()),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
