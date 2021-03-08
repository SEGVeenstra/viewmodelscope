import 'package:flutter/material.dart';
import 'package:viewmodel/viewmodel.dart';

void main() {
  runApp(MyApp());
}

class NumberViewModel extends ViewModel<int> {
  NumberViewModel({Widget child}) : super(child: child, initialState: 0);

  increment() {
    setState(state + 1);
  }
}

class NumberWidget extends ViewModelConsumer<NumberViewModel, int> {
  @override
  Widget buildView(BuildContext context, int state) {
    return ViewModelListener<NumberViewModel, int>(
      listener: (state) {
        if (state == 5) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('You reached 5'),
                  ));
        }
      },
      child: InkWell(
          onTap: () {
            viewModelOf(context).increment();
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            child: Center(
              child: Text(
                '$state',
                style: TextStyle(fontSize: 64),
              ),
            ),
          )),
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
        body: NumberViewModel(child: NumberWidget()),
      ),
    );
  }
}
