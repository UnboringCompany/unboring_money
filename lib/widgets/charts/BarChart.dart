import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class BarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final int selectedTab;

  const BarChart({
    Key? key,
    required this.data,
    required this.selectedTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          "No data available",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    // Group expenses by category and calculate the sum of expenses for each category
    final categorySums = data.fold<Map<String, double>>({}, (map, depense) {
      final category = depense['categorie'] as String;
      map[category] = (map[category] ?? 0) + (depense['valeur'] as double);
      return map;
    });

    // Convert the categorySums map into a list of maps that can be used as data for the chart
    final chartData = categorySums.entries.map((entry) {
      return {
        'category': entry.key,
        'amount': entry.value,
        'color': data.firstWhere((depense) => depense['categorie'] == entry.key)['couleur'],
      };
    }).toList();

    if (selectedTab == 0) {
      // Bar Chart
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Chart(
                data: chartData,
                variables: {
                  'category': Variable(
                    accessor: (Map map) => map['category'] as String,
                  ),
                  'amount': Variable(
                    accessor: (Map map) => map['amount'] as num,
                  ),
                },
                marks: [
                  IntervalMark(
                    position: Varset('category') * Varset('amount'),
                    color: ColorEncode(
                      variable: 'category',
                      values: chartData.length >= 2
                          ? chartData.map((data) => data['color'] as Color).toList()
                          : [Colors.grey, Colors.grey], // Au moins deux couleurs par défaut
                    ),
                    label: LabelEncode(
                      encoder: (tuple) => Label(
                        '${tuple['amount']}',
                        // LabelStyle(fontSize: 12),
                      ),
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
                      color: data['color'] as Color,
                    ),
                    const SizedBox(width: 4),
                    Text(data['category'].toString()),
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
                    accessor: (Map map) => map['category'] as String,
                  ),
                  'amount': Variable(
                    accessor: (Map map) => map['amount'] as num,
                  ),
                },
                marks: [
                  IntervalMark(
                    position: Varset('amount') / Varset('category'),
                    color: ColorEncode(
                      variable: 'category',
                      values: chartData.length >= 2
                          ? chartData.map((data) => data['color'] as Color).toList()
                          : [Colors.grey, Colors.grey], // Au moins deux couleurs par défaut
                    ),
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
                      color: data['color'] as Color,
                    ),
                    const SizedBox(width: 4),
                    Text(data['category'].toString()),
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
