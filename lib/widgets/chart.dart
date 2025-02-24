import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: LineChart(
          LineChartData(
            borderData: FlBorderData(show: true),
            titlesData: FlTitlesData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: [FlSpot(1, 10), FlSpot(2, 50), FlSpot(3, 30)],
                isCurved: true,
                barWidth: 4,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
