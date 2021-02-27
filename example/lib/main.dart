import 'dart:math';

import 'package:flutter/material.dart';
import 'package:viewmodel/viewmodel.dart';

void main() {
  runApp(MyApp());
}

class NumberViewModel extends ViewModel<int> {
  final _rng = Random();

  NumberViewModel({Widget child}) : super(child: child, initialState: 0);

  randomNumber() {
    setState(_rng.nextInt(10));
  }
}

class NumberWidget extends ViewModelConsumer<NumberViewModel, int> {
  @override
  Widget buildView(BuildContext context, int state) {
    return InkWell(
        onTap: () {
          viewModelOf(context).randomNumber();
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          child: Center(
            child: Text(
              '$state',
              style: TextStyle(fontSize: 64),
            ),
          ),
        ));
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
        body: NumberViewModel(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: NumberWidget()),
                  Expanded(child: NumberViewModel(child: NumberWidget())),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: NumberWidget()),
                  Expanded(child: NumberViewModel(child: NumberWidget())),
                  Expanded(child: NumberWidget()),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
