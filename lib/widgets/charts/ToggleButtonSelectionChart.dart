import 'package:flutter/material.dart';

class ToggleButtonSelectionChart extends StatefulWidget {
  final Function(int) onSelectionChanged; // Callback pour notifier le changement de sélection
  final int initialIndex; // Index initial du bouton sélectionné

  const ToggleButtonSelectionChart({super.key, required this.onSelectionChanged, this.initialIndex = 0});

  @override
  _ToggleButtonSelectionChartState createState() =>
      _ToggleButtonSelectionChartState();
}

class _ToggleButtonSelectionChartState
    extends State<ToggleButtonSelectionChart> {
  late int _selectedIndex = 0; // L'index du bouton actuellement sélectionné

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: List.generate(2, (index) => index == _selectedIndex),
      onPressed: (index) {
        setState(() {
          _selectedIndex = index;
        });
        widget.onSelectionChanged(index); // Appel de la callback pour notifier
      },
      color: Colors.black54,
      selectedColor: Colors.teal[700],
      fillColor: Colors.teal[300],
      borderRadius: BorderRadius.circular(20),
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text('Bar Graph'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text('Round Graph'),
        ),
      ],
    );
  }
}
