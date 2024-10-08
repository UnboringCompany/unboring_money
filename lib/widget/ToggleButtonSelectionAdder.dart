import 'package:flutter/material.dart';

class ToggleButtonSelectionAdder extends StatefulWidget {
  final Function(int) onSelectionChanged; // Callback pour notifier le changement de sélection

  ToggleButtonSelectionAdder({required this.onSelectionChanged});

  @override
  _ToggleButtonSelectionAdderState createState() =>
      _ToggleButtonSelectionAdderState();
}

class _ToggleButtonSelectionAdderState
    extends State<ToggleButtonSelectionAdder> {
  int _selectedIndex = 0; // L'index du bouton actuellement sélectionné

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text('Dépense'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text('Catégorie'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text('Compte'),
        ),
      ],
      isSelected: [
        _selectedIndex == 0,
        _selectedIndex == 1,
        _selectedIndex == 2,
      ],
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
    );
  }
}
