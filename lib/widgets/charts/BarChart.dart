// BarChart.dart

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:unboring_money/models/Depense.dart';

class BarChart extends StatelessWidget {
  final List<Depense> depenses;
  final int selectedTab;

  const BarChart({
    Key? key,
    required this.depenses,
    required this.selectedTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Group expenses by category and calculate the sum of expenses for each category
    final categorySums = depenses.fold<Map<int, double>>({}, (map, depense) {
      map[depense.categorieId] = (map[depense.categorieId] ?? 0) + depense.montant;
      return map;
    });

    // Convert the categorySums map into a list of maps that can be used as data for the chart
    final chartData = categorySums.entries.map((entry) {
      return {
        'category': entry.key,
        'amount': entry.value,
      };
    }).toList();

    if (selectedTab == 0) {
      // Bar Graph
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Chart(
                data: chartData,
                variables: {
                  'category': Variable(
                    accessor: (Map map) => map['category'] as int,
                  ),
                  'amount': Variable(
                    accessor: (Map map) => map['amount'] as num,
                  ),
                },
                marks: [
                  IntervalMark(
                    label: LabelEncode(
                      encoder: (tuple) => tuple['amount'], // Return the numeric value as a string
                    ),
                  ),
                ],
                axes: [
                  Defaults.horizontalAxis,
                  Defaults.verticalAxis,
                ],
                coord: RectCoord(
                  horizontalRange: [0.1, 0.9],
                ),
              ),
            ),
            // Custom legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: chartData.map((data) {
                return Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      color: Defaults.colors10[(data['category'] as int) % Defaults.colors10.length],
                    ),
                    const SizedBox(width: 4),
                    Text('Category ${data['category'].toString()}'),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      );
    } else if (selectedTab == 1) {
      // Pie Chart
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Chart(
                data: chartData,
                variables: {
                  'category': Variable(
                    accessor: (Map map) => map['category'] as int,
                  ),
                  'amount': Variable(
                    accessor: (Map map) => map['amount'] as num,
                  ),
                },
                marks: [
                  IntervalMark(
                    position: Varset('amount') / Varset('category'),
                    color: ColorEncode(variable: 'category', values: Defaults.colors10),
                    modifiers: [StackModifier()],
                  ),
                ],
                coord: PolarCoord(
                  transposed: true,
                  startRadius: 0.1,
                ),
              ),
            ),
            // Custom legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: chartData.map((data) {
                return Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      color: Defaults.colors10[(data['category'] as int) % Defaults.colors10.length],
                    ),
                    const SizedBox(width: 4),
                    Text('Category ${data['category'].toString()}'),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      );
    } else {
      return const Center(
        child: Text(
          "No data available",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
  }
}
