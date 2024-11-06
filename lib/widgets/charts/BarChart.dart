import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';

class BarChart extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const BarChart({
    super.key,
    required this.data,
  });

  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  String? selectedLegend;
  double? selectedValue;
  num? selectedOrder;
  Offset? tapPosition;

  Color getColorForCategory(int categorieId) {
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.yellow,
    ];
    return colors[
        categorieId % colors.length]; // Distribution cyclique des couleurs
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const Center(
        child: Text(
          "Aucune donnée ne correspond à la recherche",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    // Group data by legend (e.g., date) and prepare data for stacked bar chart
    final Map<String, List<Map<String, dynamic>>> groupedData = {};
    for (var entry in widget.data) {
      var legend = entry['legende'] as String;

      try {
        final dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
        final formattedDate = dateFormat.parse(legend);
        legend = DateFormat("dd/MM/yyyy").format(formattedDate);
        // ignore: empty_catches
      } catch (e) {}

      groupedData.putIfAbsent(legend, () => []).add(entry);
    }

    // Prepare chart data format
    final chartData = <Map<String, dynamic>>[];
    groupedData.forEach((legend, entries) {
      for (var entry in entries) {
        chartData.add({
          'legende': legend,
          'valeur': entry['valeur'] ?? 0,
          'order': entry['order'] ?? 0,
        });
      }
    });

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Chart(
            data: chartData,
            variables: {
              'legende': Variable(
                accessor: (Map map) => map['legende'] as String,
              ),
              'valeur': Variable(
                accessor: (Map map) => map['valeur'] as num,
              ),
              'order': Variable(
                accessor: (Map map) => map['order'] as num,
              ),
            },
            marks: groupedData.entries.map((entry) {
              final entries = entry.value;
              final colorValues = entries
                  .map((data) => getColorForCategory(data['order'] as int))
                  .toList();

              // Vérifiez que colorValues a au moins deux couleurs
              if (colorValues.length < 2) {
                colorValues.add(Colors
                    .blue); // Ajouter une couleur par défaut pour éviter l'erreur
              }

              return IntervalMark(
                position: Varset('legende') * Varset('valeur'),
                color: ColorEncode(
                  variable: 'order',
                  values: colorValues,
                ),
                label: LabelEncode(
                  encoder: (tuple) => Label(
                    '${tuple['valeur']}',
                    // LabelStyle(fontSize: 12),
                  ),
                ),
                modifiers: [StackModifier()],
              );
            }).toList(),
            axes: [
              Defaults.horizontalAxis,
              Defaults.verticalAxis,
            ],
            coord: RectCoord(
              horizontalRange: [0.1, 0.9],
            ),
          ),
        ),
        if (selectedLegend != null &&
            selectedValue != null &&
            selectedOrder != null &&
            tapPosition != null)
          Positioned(
            left: tapPosition!.dx - 50,
            top: tapPosition!.dy - 80,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Date: $selectedLegend',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Text(
                      'Value: $selectedValue',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Text(
                      'Order: $selectedOrder',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
