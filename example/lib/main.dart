import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:viewmodel/viewmodel.dart';

void main() {
  runApp(MyApp());
}

class ChartViewModel extends ViewModel {
  final _rng = Random();

  final ValueNotifier<List<ChartData>> _salesData = ValueNotifier([
    ChartData(2018, 35),
    ChartData(2019, 28),
    ChartData(2020, 34),
  ]);
  ValueListenable<List<ChartData>> get chartData => _salesData;

  ChartViewModel({Widget child}) : super(child: child);

  refreshData() {
    _salesData.value = [
      ChartData(2018, _rng.nextDouble() * 10),
      ChartData(2019, _rng.nextDouble() * 10),
      ChartData(2020, _rng.nextDouble() * 10),
    ];
  }
}

class ChartData {
  ChartData(this.year, this.values);
  final int year;
  final double values;
}

class PieChart extends ViewModelConsumer<ChartViewModel> {
  @override
  Widget buildView(BuildContext context, ChartViewModel viewModel) {
    return Stack(
      children: [
        ValueListenableBuilder<List<ChartData>>(
            valueListenable: viewModel.chartData,
            builder: (context, data, _) {
              return SfCircularChart(
                series: [
                  PieSeries<ChartData, int>(
                      dataSource: data,
                      xValueMapper: (ChartData data, _) => data.year,
                      yValueMapper: (ChartData data, _) => data.values)
                ],
              );
            }),
        InkWell(
          onTap: () {
            viewModel.refreshData();
          },
        )
      ],
    );
  }
}

class DoughnutChart extends ViewModelConsumer<ChartViewModel> {
  @override
  Widget buildView(BuildContext context, ChartViewModel viewModel) {
    return Stack(
      children: [
        ValueListenableBuilder<List<ChartData>>(
            valueListenable: viewModel.chartData,
            builder: (context, data, _) {
              return SfCircularChart(
                series: [
                  DoughnutSeries<ChartData, int>(
                      dataSource: data,
                      xValueMapper: (ChartData data, _) => data.year,
                      yValueMapper: (ChartData data, _) => data.values)
                ],
              );
            }),
        InkWell(
          onTap: () {
            viewModel.refreshData();
          },
        )
      ],
    );
  }
}

class LineChart extends ViewModelConsumer<ChartViewModel> {
  @override
  Widget buildView(BuildContext context, ChartViewModel viewModel) {
    return Stack(
      children: [
        ValueListenableBuilder<List<ChartData>>(
            valueListenable: viewModel.chartData,
            builder: (context, data, _) {
              return SfCartesianChart(
                series: [
                  AreaSeries<ChartData, int>(
                      dataSource: data,
                      xValueMapper: (ChartData data, _) => data.year,
                      yValueMapper: (ChartData data, _) => data.values)
                ],
              );
            }),
        InkWell(
          onTap: () {
            viewModel.refreshData();
          },
        )
      ],
    );
  }
}

class ColumnChart extends ViewModelConsumer<ChartViewModel> {
  @override
  Widget buildView(BuildContext context, ChartViewModel viewModel) {
    return Stack(
      children: [
        ValueListenableBuilder<List<ChartData>>(
            valueListenable: viewModel.chartData,
            builder: (context, data, _) {
              return SfCartesianChart(
                series: [
                  ColumnSeries<ChartData, int>(
                      dataSource: data,
                      xValueMapper: (ChartData data, _) => data.year,
                      yValueMapper: (ChartData data, _) => data.values)
                ],
              );
            }),
        InkWell(
          onTap: () {
            viewModel.refreshData();
          },
        )
      ],
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
        body: ChartViewModel(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: LineChart()),
                  Expanded(child: DoughnutChart()),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: PieChart()),
                  Expanded(child: ColumnChart()),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
